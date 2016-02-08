outer_latest_image=".outer_latest_img"
inner_latest_image=".inner_latest_img"
image_name_delimeters="_-"
combined_image_keyword="unified"
outer_images=(xcc360g tj1700 tj14xx teraxc)
total_outer=${#outer_images[@]};
inner_images=(cef5 elan10)
total_inner=${#inner_images[@]};
timestamp_override_token=".my_priority_1"
final_outer=".combine_me_outer"
final_inner=".combine_me_inner"
image_extraction_dir="tejas"
should_this_be_outer_image () {
   image=$1
   for ((index=0; index<$total_outer; index++))
   do
        if [ "${outer_images[$index]}" == "${image}" ]; then
            echo "yes"
            return
        fi
   done;
   echo "no"
}
should_this_be_inner_image () {
   image=$1
   for ((index=0; index<$total_inner; index++))
   do
        if [ "${inner_images[$index]}" == "${image}" ]; then
            echo "yes"
            return
        fi
   done;
   echo "no"
}
cimg () 
{   
    fresh_token=$1
    taginfo_relative_path=$(reverse_recursive_search taginfo);
    if [[ "$taginfo_relative_path" == "" ]]; then
        echo "It doesn't seem to be a checkout area.";
        return;
    fi;
    taginfo_absolute_path=$(readlink -e $taginfo_relative_path);
    taginfo_absolute_path=${taginfo_absolute_path%taginfo};
    if ! [[ -e ${taginfo_absolute_path}${mirrors_of_checkout_file} ]]; then
        echo "It seems you haven't created/updated mirrors_list file. Please Run fxn -> uml (=update_mirror_list)";
        return;
    fi;
    readarray -t mirrors <<< "$(cat ${taginfo_absolute_path}${mirrors_of_checkout_file})";
    echo "Resetting $outer_latest_image & $inner_latest_image"
    echo -n > ${taginfo_absolute_path}/$outer_latest_image
    echo -n > ${taginfo_absolute_path}/$inner_latest_image
    echo -n > ${taginfo_absolute_path}/$final_inner
    echo -n > ${taginfo_absolute_path}/$final_outer
    timestamp_override_outer="0"
    timestamp_override_inner="0"
    total_results=${#mirrors[@]};
    if [[ "$total_results" != "1" ]]; then
        echo "Found $total_results Mirrors. Creating list of latest builds present in them.";
        for ((index=0; index<$total_results; index++))
        do
            this_mirror_latest=$(ls -1rt ${mirrors[$index]}*.img |grep -v "download\|$combined_image_keyword"| tail -n 1)
            this_mirror_latest_type=${this_mirror_latest##*\/}
            this_mirror_latest_type=${this_mirror_latest_type%%[$image_name_delimeters]*}
            if [[ "$(should_this_be_outer_image $this_mirror_latest_type)" == "yes" ]];then
            	echo "$this_mirror_latest" >> ${taginfo_absolute_path}/$outer_latest_image
            	if [ -e ${mirrors[$index]}/$timestamp_override_token ];then
            		echo "$this_mirror_latest" > ${taginfo_absolute_path}/$final_outer
            		let timestamp_override_outer=timestamp_override_outer+1
            	fi
            else
            	echo "$this_mirror_latest" >> ${taginfo_absolute_path}/$inner_latest_image
            	if [ -e ${mirrors[$index]}/$timestamp_override_token ];then
            		echo "$this_mirror_latest" > ${taginfo_absolute_path}/$final_inner
            		let timestamp_override_inner=timestamp_override_inner+1
            	fi
            fi
        done;

        if [[ "$timestamp_override_outer" == "0"]];then
        	ls -1rt $(cat ${taginfo_absolute_path}/$outer_latest_image) | tail -n 1 > ${taginfo_absolute_path}/$final_outer
        fi

        if [[ "$timestamp_override_inner" == "0"]];then
        	ls -1rt $(cat ${taginfo_absolute_path}/$inner_latest_image) | tail -n 1 > ${taginfo_absolute_path}/$final_inner
        fi
        
        temp_outer=$(cat ${taginfo_absolute_path}/$final_outer)
        outer_dir=${temp_outer%\/*}
        outer_file=${temp_outer*##\/}
        temp_inner=$(cat ${taginfo_absolute_path}/$final_inner)
        inner_dir=${temp_inner%\/*}
        inner_file=${temp_inner*##\/}
        inner_type=${inner_file%%[$image_name_delimeters]*}
        outer_type=${outer_file%%[$image_name_delimeters]*}
        path_to_mksquashfs="$outer_dir/tj100_mc/scripts"
        if [[ "$fresh_token" == "t" ]];then
        	epoch_timestamp=$(date +%s)
            combined_image_name="${outer_type}-${combined_image_keyword}-${inner_type}-${epoch_timestamp}.squash.img"
        elif [[ "$fresh_token" == "" ]];then
        	combined_image_name="${outer_type}-${combined_image_keyword}-${inner_type}-constant_name.squash.img"
        else
        	combined_image_name="${outer_type}-${combined_image_keyword}-${inner_type}-${$fresh_token}.squash.img"
        fi
        pushd $outer_dir >/dev/null
        rm -rf $outer_dir/$image_extraction_dir 2>/dev/null
        tar -xzvf $outer_file
        mkdir -p $outer_dir/$image_extraction_dir/$inner_type
        cp ${temp_inner} $outer_dir/$image_extraction_dir/$inner_type/${inner_type}.squash.img
        cp ${temp_inner}.md5 $outer_dir/$image_extraction_dir/$inner_type/${inner_type}.squash.img.md5
        tj100_mc/scripts/create_squashfsimg.sh $image_extraction_dir $combined_image_name tj100_mc/scripts
        echo "Combined the images successfully."
        ls -lrt
    else
        if [[ "$total_results" == "1" ]] && [[ "${mirrors}" != "" ]]; then
            echo "Only Single Mirror is there. At least one Control Card & one Line Card Image is needed to combine."
            return;
        else
            echo "No mirrors found for this checkout area.";
            return;
        fi;
    fi;
}


