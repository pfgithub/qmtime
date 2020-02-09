#include "tenhourtime.c"
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv) {

  struct timespec sleeptime;
  sleeptime.tv_sec = 0;
  sleeptime.tv_nsec = 10 * 1000000;
  struct timespec rem;

  int raw = 0;
  int forever = 0;

  for (int i = 1; i < argc; i++) {
    if (strcmp(argv[i], "--help") == 0) {
      printf("tenhourtime\n"
             "--help    | show help\n"
             "-m        | select mode\n"
             "-m raw    | print raw value, eg: `19079284`\n"
             "-m format | [default] print formatted time, eg: `19LL 07cc 92ii "
             "84qm`\n"
             "--update  | run until ctrl+c\n",
             argv[i]);
      return 0;
    } else if (strcmp(argv[i], "-m") == 0) {
      i++;
      if (i >= argc) {
        printf("Missing mode: raw | format");
        return 1;
      }
      if (strcmp(argv[i], "raw") == 0) {
        raw = 1;
      } else if (strcmp(argv[i], "format") == 0) {
        raw = 0;
      } else {
        printf("Invalid -m option. Must be: raw | format");
        return 1;
      }
    } else if (strcmp(argv[i], "--update") == 0) {
      forever = 1;
    } else {
      printf("Invalid argument %s\n", argv[i]);
      return 1;
    }
  }

  do {
    int64_t currenttime = tenhourtime();

    if (forever) {
      printf("\r");
    }

    if (raw) {
      printf("%" PRId64, currenttime);
    } else {
      struct tht_time sepertime = seperatetime(currenttime);
      printf("%02dLL %02dcc %02dii %02dqm", sepertime.LL, sepertime.cc,
             sepertime.ii, sepertime.qm);
    }

    if (forever) {
      printf("\x1b[0K");
      fflush(stdout);
    } else {
      printf("\n");
    }

    nanosleep(&sleeptime, &rem);
  } while (forever);
  return 0;
}