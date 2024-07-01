#include <iostream>
using namespace std;
int n;
float f;
int main()
{
  cin >> n;
  
  for(int i=1; i<=n; i++)
  {
    cin >> f;
    cout << 1/f << endl;
  }
  return 0;
}
