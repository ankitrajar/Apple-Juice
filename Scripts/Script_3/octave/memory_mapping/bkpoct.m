#! /usr/bin/octave -qf
fig = figure;
data = dlmread("input.txt"," ");
size(data);
set(fig, "visible", "off");
time=0:5:500;
MemTotal = data(:,1);
MemFree = data(:,2);
Buffers = data(:,3);
Cached = data(:,4);
SwapCached = data(:,5);
Active = data(:,6);
Inactive = data(:,7);
SwapTotal = data(:,8);
SwapFree = data(:,9);
Dirty = data(:,10);
Writeback = data(:,11);
AnonPages = data(:,12);
Mapped = data(:,13);
Slab = data(:,14);
SReclaimable = data(:,15);
SUnreclaim = data(:,16);
PageTables = data(:,17);
NFS_Unstable = data(:,18);
Bounce = data(:,19);
WritebackTmp = data(:,20);
CommitLimit = data(:,21);
Committed_AS = data(:,22);
VmallocTotal = data(:,23);
VmallocUsed = data(:,24);
VmallocChunk = data(:,25);

plot(time,MemFree,";MemFree;")
xlabel("Time (5min)");
ylabel("Free Memory (KB)");
print("MyPNG.png", "-dpng");

