set term postscript
set output "ssd.ps" 

speed=6
size=64
writecount=100000
set yrange [0:1]
set xrange [800000:20000000]
plot (0.5*(1+erf(((x*(speed*1000*1000*1000/10)/(size*1000*1000*1000))-writecount)/sqrt(2*((writecount*0.1)**2)))))
replot
set term x11
