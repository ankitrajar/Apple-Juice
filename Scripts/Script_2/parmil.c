#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
   FILE * fp;
if(argc!=3)
{
printf("Invalid no. of args passed");return 0;
}
   fp = fopen (argv[2], "w+");
fprintf(fp,
"for signal in \"-15\" \"-1\" \"-9\"\n\
do\n\
  pids=`ps -ef | grep -ih %s | awk '{print $2}'`\n\
  kill $signal $pids 2> /dev/null\n\
  echo Killed pid\\(s\\) $pids with signal $signal\n\
done\n"\
,argv[1]);
fclose(fp);
return(0);
}
