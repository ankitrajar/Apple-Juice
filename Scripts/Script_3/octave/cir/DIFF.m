#! /usr/bin/octave -qf
fig = figure;
data = dlmread("finput.txt"," ");
size(data);
set(fig, "visible", "off");
GUICIR = data(:,1);
HWCIR = data(:,2);
DIFF = data(:,3);

plot(GUICIR,DIFF,";DIFF;"), grid
xlabel("GUICIR");
ylabel("DIFF");
print("DIFF.jpg", "-djpg");
		
