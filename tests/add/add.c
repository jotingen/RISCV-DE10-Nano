#define FINAL_ANSWER (*((volatile unsigned int *) (0x00000100)))

int main(void) {
  int a,b,c;
  a = 1;
  b = 1;
  while(a<3000) {
    c = b;
    b = a;
    a = b + c;
  }
FINAL_ANSWER = a;
while(1);
}
