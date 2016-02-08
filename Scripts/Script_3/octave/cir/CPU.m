#! /usr/bin/octave -qf
fig = figure;
data = dlmread("finput.txt"," ");
size(data);
set(fig, "visible", "off");
TIME = data(:,1);
MEMORY = data(:,2);
CPU = data(:,3);

plot(TIME,CPU,";CPU;"), grid
xlabel("TIME");
ylabel("CPU");
print("CPU.jpg", "-djpg");
		
