#! /usr/bin/octave -qf
fig = figure;
data = dlmread("finput.txt"," ");
size(data);
set(fig, "visible", "off");
GUICIR = data(:,1);
HWCIR = data(:,2);
DIFF = data(:,3);

plot(GUICIR,HWCIR,";HWCIR;"), grid
xlabel("GUICIR");
ylabel("HWCIR");
print("HWCIR.jpg", "-djpg");
		
