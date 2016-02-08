import fileinput
import re
from time import strptime

f_names = ['bcmHaldlog001', 'initl2Svcmgrdlog001'] # names of log files
lines = list(fileinput.input(f_names))
t_fmt = '%d/%m/%y %H:%M:%S:%f' # format of time stamps
t_pat = re.compile(r"^(.*?)\:\ ",re.U) # pattern to extract timestamp
print t_fmt
print t_pat.findall

# for l in sorted(lines, key=lambda l: strptime(t_pat.search(l).group(1), t_fmt)):
# 	print l,