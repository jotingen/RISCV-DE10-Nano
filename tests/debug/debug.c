#define FINAL_ANSWER (*((volatile unsigned int *) (0x00001000)))
int main(void) {
  //int a,b,c;
  int a;
  a = 1;
  //b = 1;
  //a = a + b * 2;
FINAL_ANSWER = a;
while(1);
}

