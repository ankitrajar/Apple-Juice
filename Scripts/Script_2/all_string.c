#include<stdio.h>

int main()
{
	int i,j,k,l,m,n;
	char arr[]={'c','u','t','e','k','i','t','t','y','m','e','o','w','m','e','o','w','m','e','o','w','m','e','o','w','m','e','o','w'};
	for(i=1;i<29;i++)
	{
		for(j=1;j<30 && (i+j)<29;j++)
		{
			// k=i+j;
			// for(l=0;l<j;l++)
			// printf("%c", arr[l]);
			// printf(".");
			// for(m=l;m<k;m++)
			// printf("%c", arr[m]);
			// printf(".");
			// for(n=m;n<30;n++)
			// printf("%c",arr[n] );
			// printf("\n");
			for(l=0;l<30;l++)
			{
				if(l==i || l==i+j)
					printf(".");
				
					printf("%c",arr[l]);
			}
			printf("@gmail.com\n");

		}
	
	
	}
	return 0;
}
