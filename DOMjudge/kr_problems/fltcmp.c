#include <stdio.h>
int n;
float f;
int main()
{
  int i;
  scanf("%d", &n);
  for(i=1; i<=n; i++)
  {
    scanf("%f", &f);
    printf("%f\n", 1/f);
  }
  return 0;
}


