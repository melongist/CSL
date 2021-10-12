#include <stdio.h>
#include <string.h>

char s1[20], s2[20];

//문자열 배열 지우기
void clear()
{
  for(int i=0; i<20; i++)
    s1[i] = s2[i] = 0; //0은 '\0', NULL 의 정수값임.
}

//s배열에, 10진수 n을 k진법으로 p위치부터 거꾸로 채우기
void f(char *s, int n, int k, int p)
{
  if(n>=k) f(s, n/k, k, p+1);
  s[p] = (n%k + '0');
}

//정수 뒤집기.. 123 입력하면 321 리턴함
int r(int n)
{
  int sum=0;
  for(; n>0; n/=10)
  {
    sum *= 10;
    sum += n%10;
  }
  return sum;
}

//s문자배열 p위치부터 마지막까지 거꾸로 출력하기
void rprint(char *s, int p)
{
  if(s[p+1] != 0) rprint(s, p+1);
  printf("%c", s[p]);
  if(p==0) printf("\n");
}

//문자열 회문 체크... 순서대로 읽으나, 뒤에서부터 읽으나 같으면 1 리턴
int rcheck(char *s1, char *s2)
{
  int cnt1 = (int)strlen(s1);
  int cnt2 = (int)strlen(s2);
  
  if(cnt1 != cnt2)
    return 0;
  
  for(int i=0; i<cnt1; i++)
    if(s1[i] != s2[cnt1-i-1])
      return 0;
  
  return 1;
}

//두 문자열에서 사용된 숫자0~9 세트가 같은가? 같으면 1 리턴, 예를 들어 1023 과 1032는 1리턴됨
int check(char *s1, char *s2)
{
  int d1[10]={};
  int d2[10]={};
  
  for(int i=0; i<20; i++)
    if(s1[i]>='0' && s1[i]<='9')
      d1[s1[i]-'0'] = 1;
  
  for(int i=0; i<20; i++)
    if(s2[i]>='0' && s2[i]<='9')
      d2[s2[i]-'0'] = 1;

  for(int i=1; i<10; i++)
    if(d1[i] != d2[i])
      return 0;
        
  return 1;
}

int main()
{
  for(int i=10; i<=9999; i++)  //10진수 100부터 9999까지만~ 돌려봄
  {
    for(int k=2; k<=10; k++)   //2진법부터 10진법까지 모두 돌려봄
    {
      f(s1, i, k, 0);    //10진수 i를 s1 배열에 k 진법으로 바꾸어 채우고
      f(s2, 2*i, k, 0);  //10진수 2*i를 s2 배열에 k 진법으로 바꾸어 채우고
      
      if(rcheck(s1, s2)==1)  //s1 과 s2 가 회문 관계가 되면
      {
        //답을 출력해보자~~~~ ^^
        printf("decimal %d\n", i);
        printf("%d - notation\n", k);
        printf("   "); rprint(s1, 0);
        printf("+  "); rprint(s1, 0);
        printf("-------------\n");
        printf("   "); rprint(s2, 0);
        printf("\n");
      }
      
      clear();
    }
  }
  
  return 0;
}
