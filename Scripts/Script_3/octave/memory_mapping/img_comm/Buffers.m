#! /usr/bin/octave -qf
fig = figure;
data = dlmread("finput.txt"," ");
data_sec = dlmread("finput_sec.txt"," ");
size(data);
size(data_sec);
set(fig, "visible", "off");

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


plot(time,Buffers,";Buffers Prim;",time,Buffers_sec,";Buffers Sec;"), grid

xlabel("Time (5min)");
ylabel("Buffers");
print("Buffers.png", "-dpng");


