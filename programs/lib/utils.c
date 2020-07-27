#include <stdio.h> 

#include "utils.h"
#include "uart.h"

//struct __FILE
//{
//  int dummyVar; //Just for the sake of redefining __FILE, we won't we using it anyways ;)
//};
//
//FILE __stdout;
//FILE __stdin;
//
////Doesnt seem to work
//int putc(int c, FILE * stream)
//{
//  uart_write(c);
//  return c; //return the character written to denote a successfull write
//}
//
////Doesnt seem to work
//int getc(FILE * stream)
//{
//  char c = 't'; //FIXME uart_read();
//  uart_write(c); //To echo Received characters back to serial Terminal
//  return c;
//}

//int _write(int fd, char * str, int len)
//{
//      for (int i = 0; i < len; i++)
//            {
//                      uart_write(str[i]);
//                          }
//          return len;
//}

void _putchar(char character)
{
  // send char to console etc.
  uart_write(character);
}
