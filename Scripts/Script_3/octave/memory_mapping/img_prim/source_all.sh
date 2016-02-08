declare -a arr=("MemTotal" "MemFree" "Buffers" "Cached" "SwapCached" "Active" "Inactive" "SwapTotal" "SwapFree" "Dirty" "Writeback" "AnonPages" "Mapped" "Slab" "SReclaimable" "SUnreclaim" "PageTables" "NFS_Unstable" "Bounce" "WritebackTmp" "CommitLimit" "Committed_AS" "VmallocTotal" "VmallocUsed" "VmallocChunk")

## now loop through the above array
for i in "${arr[@]}"
do
echo "$i"
echo "
source $i.m
" >> sall.m;

done
