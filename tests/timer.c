#define FINAL_ANSWER (*((volatile unsigned int *) (0x00000100)))
#define LED (*((volatile unsigned int *) (0x00040000)))

int main(void) {
  int a,b,c;
  a = 1;
  b = 1;
  while(a<1000000) {
    c = b;
    b = a;
    a = b + c;
  }
FINAL_ANSWER = a;
LED = a;
while(1);
}
