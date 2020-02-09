#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>

// kind of works maybe
int64_t tenhourtime() {
  int localoffset = LOCAL_OFFSET;

  struct timespec res;
  clock_gettime(CLOCK_REALTIME, &res);

  time_t sec = res.tv_sec;
  int64_t ms = res.tv_sec * 1000 + (res.tv_nsec / 1000000);

  struct tm *currenttime = gmtime(&sec);
  currenttime->tm_hour = 0;
  currenttime->tm_min = 0;
  currenttime->tm_sec = 0;
  time_t daystart = timegm(currenttime);
  int64_t daystart_ms = daystart * 1000;

  int64_t diff = ms - daystart_ms;
  double diffd = diff;
  double something = (24. * 60. * 60. * 1000.) / 100000000.;
  int64_t percent = diffd / something;

  return percent;
}

struct tht_time {
  int LL;
  int cc;
  int ii;
  int qm;
};

struct tht_time seperatetime(int64_t time) {
  struct tht_time result;
  result.LL = time / 1000000;
  result.cc = (time / 10000) % 100;
  result.ii = (time / 100) % 100;
  result.qm = (time / 1) % 100;
  return result;
}