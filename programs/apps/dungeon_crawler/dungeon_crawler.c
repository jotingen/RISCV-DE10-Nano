#include <stdint.h>

#include "../../lib/utils.h"
#include "../../lib/printf.h"
#include "../../lib/rand.h"

struct attributes_t {
  uint8_t strength;
  uint8_t intellegence;
  uint8_t charisma;
};
struct character_t {
  char name[257];
  struct attributes_t attributes;
  uint8_t health;
  uint32_t gold;
};

void print_character(struct character_t * character) {
  printf("Name: %s\n", character->name);
  printf("Strength: %s\n", character->attributes.strength);
  printf("Intellegence: %s\n", character->attributes.intellegence);
  printf("Charisma: %s\n", character->attributes.charisma);
  printf("Health: %d\n", character->health);
  printf("Gold: %d\n", character->gold);
}

uint8_t roll_die(void) {
  return (rand() % 6) + 1;
}

void main(void) {

  struct character_t character;

  //Initialize random number generator
  rand_seed_init(0);

  printf("Dungeon Crawler Test\n\n");

  strcpy(character.name, "John Doe");
  character.health = 100;
  character.gold = 50;

  for(uint32_t i = 0; i < 7; i++) {
    uint8_t roll_value;
    printf("Roll %d\n", i);

    roll_value = roll_die();
    printf("  %d\n", roll_value);

  }

  print_character(&character);

}
