#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define true 1
#define MEMBLOCSIZE ((2<<20)*500)//1000MB

int readMemory( int* data, int* dataEnd, int numReads, int incrementPerRead ) {
  int accum = 0;
  int* ptr = data;

  while(true) {
    accum += *ptr;
    if( numReads-- == 0)
      return accum;

    ptr += incrementPerRead;

    if( ptr >= dataEnd )
      ptr = data;
  }
}

int main()
{
  int* data = (int*)malloc(MEMBLOCSIZE);
  int* dataEnd = data+(MEMBLOCSIZE / sizeof(int));

  int numReads = (MEMBLOCSIZE / sizeof(int));
  int dummyTotal = 0;
  int increment = 1;
  for( int loop = 0; loop < 28; ++loop ) {
    int startTime = clock();

    dummyTotal += readMemory(data, dataEnd, numReads, increment);

    int endTime = clock();
    double deltaTime = (double)(endTime-startTime)/(double)(CLOCKS_PER_SEC);

    printf("time=%f byteIncrement=%d numReadLocations=%d numReads=%d\n",
      deltaTime, increment*sizeof(int), MEMBLOCSIZE/(increment*sizeof(int)), numReads);

    increment *= 2;
  }
  //Use dummyTotal: make sure the optimizer is not removing my code...
  return dummyTotal == 666 ? 1: 0;
}
