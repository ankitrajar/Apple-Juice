#! /usr/bin/octave -qf
fig = figure;
data = dlmread("finput.txt"," ");
size(data);
set(fig, "visible", "off");
EPCOH_SECOND = data(:,1);
AVG_TEMP = data(:,2);
plot(,EPCOH_SECOND,AVG_TEMP,";AVG_TEMP;"), grid
xlabel("EPCOH_SECOND");
ylabel("ALL_VARIABLES");
print("ALL.png", "-dpng");
	
