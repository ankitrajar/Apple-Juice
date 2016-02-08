declare -a arr=("MemTotal" "MemFree" "Buffers" "Cached" "SwapCached" "Active" "Inactive" "SwapTotal" "SwapFree" "Dirty" "Writeback" "AnonPages" "Mapped" "Slab" "SReclaimable" "SUnreclaim" "PageTables" "NFS_Unstable" "Bounce" "WritebackTmp" "CommitLimit" "Committed_AS" "VmallocTotal" "VmallocUsed" "VmallocChunk")

## now loop through the above array

echo "#! /usr/bin/octave -qf
fig = figure;
data = dlmread(\"finput.txt\",\" \");
size(data);
set(fig, \"visible\", \"off\");
time = data(:,1);
MemTotal = data(:,2);
MemFree = data(:,3);
Buffers = data(:,4);
Cached = data(:,5);
SwapCached = data(:,6);
Active = data(:,7);
Inactive = data(:,8);
SwapTotal = data(:,9);
SwapFree = data(:,10);
Dirty = data(:,11);
Writeback = data(:,12);
AnonPages = data(:,13);
Mapped = data(:,14);
Slab = data(:,15);
SReclaimable = data(:,16);
SUnreclaim = data(:,17);
PageTables = data(:,18);
NFS_Unstable = data(:,19);
Bounce = data(:,20);
WritebackTmp = data(:,21);
CommitLimit = data(:,22);
Committed_AS = data(:,23);
VmallocTotal = data(:,24);
VmallocUsed = data(:,25);
VmallocChunk = data(:,26);
">>all.m
echo -n "plot(">>all.m
for i in "${arr[@]}"
do
echo -n ",time,$i,\";$i;\"">>all.m
done
echo -n "), grid">>all.m
echo -n "
xlabel(\"Time\");
ylabel(\"All\");
print(\"All.png\", \"-dpng\");

" >> all.m;

