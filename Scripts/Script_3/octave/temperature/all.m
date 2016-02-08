#! /usr/bin/octave -qf
fig = figure;
data = dlmread("finput.txt"," ");
size(data);
set(fig, "visible", "off");
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

plot(,time,MemTotal,";MemTotal;",time,MemFree,";MemFree;",time,Buffers,";Buffers;",time,Cached,";Cached;",time,SwapCached,";SwapCached;",time,Active,";Active;",time,Inactive,";Inactive;",time,SwapTotal,";SwapTotal;",time,SwapFree,";SwapFree;",time,Dirty,";Dirty;",time,Writeback,";Writeback;",time,AnonPages,";AnonPages;",time,Mapped,";Mapped;",time,Slab,";Slab;",time,SReclaimable,";SReclaimable;",time,SUnreclaim,";SUnreclaim;",time,PageTables,";PageTables;",time,NFS_Unstable,";NFS_Unstable;",time,Bounce,";Bounce;",time,WritebackTmp,";WritebackTmp;",time,CommitLimit,";CommitLimit;",time,Committed_AS,";Committed_AS;",time,VmallocTotal,";VmallocTotal;",time,VmallocUsed,";VmallocUsed;",time,VmallocChunk,";VmallocChunk;"), grid
xlabel("Time");
ylabel("All");
print("All.png", "-dpng");

