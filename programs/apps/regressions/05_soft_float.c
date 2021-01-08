#include <stdint.h>
#include <stdio.h>

#include "../../lib/utils.h"
#include "../../lib/printf.h"
#include "../../lib/led.h"

float add_floats(float a, float b) {
  return a + b;
}
void main(void) {

  float a = 1.1;
  float b = 2.3;
  float c;

  LED_set(1);
  printf("%3f\n", a);
  LED_set(2);
  printf("%3f\n", b);
  LED_set(3);
  c = add_floats(a,b);
  LED_set(4);
  printf("%3f\n", c);
  LED_set(5);

  while(1) {}
}
