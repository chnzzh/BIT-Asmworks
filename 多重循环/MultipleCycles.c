#include <stdio.h>

int main()
{
	int i, j, k, l, ans;
	for (i = 0; i < 10; i++)
	{
		for (j = 0; j < 10; j++)
		{
			for (k = 0; k < 10; k++)
			{
				for (l = 0; l < 10; l++)
				{

					ans = i * j + k - l;
					printf("%2d/", ans);
				}
                printf("\n");
			}
			printf("\n");
		}
		printf("\n");
	}
	return 0;
}
