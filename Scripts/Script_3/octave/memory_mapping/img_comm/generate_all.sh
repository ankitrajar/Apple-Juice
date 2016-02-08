declare -a arr=("MemTotal" "MemFree" "Buffers" "Cached" "SwapCached" "Active" "Inactive" "SwapTotal" "SwapFree" "Dirty" "Writeback" "AnonPages" "Mapped" "Slab" "SReclaimable" "SUnreclaim" "PageTables" "NFS_Unstable" "Bounce" "WritebackTmp" "CommitLimit" "Committed_AS" "VmallocTotal" "VmallocUsed" "VmallocChunk")

#declare -a arr2=("MemTotal_sec" "MemFree_sec" "Buffers_sec" "Cached_sec" "SwapCached_sec" "Active_sec" "Inactive_sec" "SwapTotal_sec" "SwapFree_sec" "Dirty_sec" "Writeback_sec" "AnonPages_sec" "Mapped_sec" "Slab_sec" "SReclaimable_sec" "SUnreclaim_sec" "PageTables_sec" "NFS_Unstable_sec" "Bounce_sec" "WritebackTmp_sec" "CommitLimit_sec" "Committed_AS_sec" "VmallocTotal_sec" "VmallocUsed_sec" "VmallocChunk_sec")

# now loop through the above array
for i in "${arr[@]}"
do
echo "$i"
echo "#! /usr/bin/octave -qf
fig = figure;
data = dlmread(\"finput.txt\",\" \");
data_sec = dlmread(\"finput_sec.txt\",\" \");
size(data);
size(data_sec);
set(fig, \"visible\", \"off\");

time =  data(:,1);
MemTotal =  data(:,2);
MemFree =  data(:,3);
Buffers =  data(:,4);
Cached =  data(:,5);
SwapCached =  data(:,6);
Active =  data(:,7);
Inactive =  data(:,8);
SwapTotal =  data(:,9);
SwapFree =  data(:,10);
Dirty =  data(:,11);
Writeback =  data(:,12);
AnonPages =  data(:,13);
Mapped =  data(:,14);
Slab =  data(:,15);
SReclaimable =  data(:,16);
SUnreclaim =  data(:,17);
PageTables =  data(:,18);
NFS_Unstable =  data(:,19);
Bounce =  data(:,20);
WritebackTmp =  data(:,21);
CommitLimit =  data(:,22);
Committed_AS =  data(:,23);
VmallocTotal =  data(:,24);
VmallocUsed =  data(:,25);
VmallocChunk =  data(:,26);

time_sec =  data_sec(:,1);
MemTotal_sec =  data_sec(:,2);
MemFree_sec =  data_sec(:,3);
Buffers_sec =  data_sec(:,4);
Cached_sec =  data_sec(:,5);
SwapCached_sec =  data_sec(:,6);
Active_sec =  data_sec(:,7);
Inactive_sec =  data_sec(:,8);
SwapTotal_sec =  data_sec(:,9);
SwapFree_sec =  data_sec(:,10);
Dirty_sec =  data_sec(:,11);
Writeback_sec =  data_sec(:,12);
AnonPages_sec =  data_sec(:,13);
Mapped_sec =  data_sec(:,14);
Slab_sec =  data_sec(:,15);
SReclaimable_sec =  data_sec(:,16);
SUnreclaim_sec =  data_sec(:,17);
PageTables_sec =  data_sec(:,18);
NFS_Unstable_sec =  data_sec(:,19);
Bounce_sec =  data_sec(:,20);
WritebackTmp_sec =  data_sec(:,21);
CommitLimit_sec =  data_sec(:,22);
Committed_AS_sec =  data_sec(:,23);
VmallocTotal_sec =  data_sec(:,24);
VmallocUsed_sec =  data_sec(:,25);
VmallocChunk_sec =  data_sec(:,26);


plot(time,$i,\";$i" Prim";\",time,$i"_sec",\";$i" Sec";\"), grid

xlabel(\"Time (5min)\");
ylabel(\"$i\");
print(\"$i.png\", \"-dpng\");

" > $i.m;

done
