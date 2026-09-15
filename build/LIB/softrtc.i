# 0 "LIB/softrtc.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "LIB/softrtc.c"
# 1 "C:/avr-gcc/avr/include/stdio.h" 1 3
# 44 "C:/avr-gcc/avr/include/stdio.h" 3
# 1 "C:/avr-gcc/avr/include/inttypes.h" 1 3
# 37 "C:/avr-gcc/avr/include/inttypes.h" 3
# 1 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 1 3 4
# 9 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 3 4
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpedantic"
# 1 "C:/avr-gcc/avr/include/stdint.h" 1 3 4
# 125 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef signed int int8_t __attribute__((__mode__(__QI__)));
typedef unsigned int uint8_t __attribute__((__mode__(__QI__)));
typedef signed int int16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int uint16_t __attribute__ ((__mode__ (__HI__)));
typedef signed int int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int uint32_t __attribute__ ((__mode__ (__SI__)));

typedef signed int int64_t __attribute__((__mode__(__DI__)));
typedef unsigned int uint64_t __attribute__((__mode__(__DI__)));
# 146 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int16_t intptr_t;




typedef uint16_t uintptr_t;
# 163 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int8_t int_least8_t;




typedef uint8_t uint_least8_t;




typedef int16_t int_least16_t;




typedef uint16_t uint_least16_t;




typedef int32_t int_least32_t;




typedef uint32_t uint_least32_t;







typedef int64_t int_least64_t;






typedef uint64_t uint_least64_t;
# 217 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int8_t int_fast8_t;




typedef uint8_t uint_fast8_t;




typedef int16_t int_fast16_t;




typedef uint16_t uint_fast16_t;




typedef int32_t int_fast32_t;




typedef uint32_t uint_fast32_t;







typedef int64_t int_fast64_t;






typedef uint64_t uint_fast64_t;
# 277 "C:/avr-gcc/avr/include/stdint.h" 3 4
typedef int64_t intmax_t;




typedef uint64_t uintmax_t;
# 12 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdint.h" 2 3 4
#pragma GCC diagnostic pop
# 38 "C:/avr-gcc/avr/include/inttypes.h" 2 3
# 77 "C:/avr-gcc/avr/include/inttypes.h" 3
typedef int32_t int_farptr_t;





typedef uint32_t uint_farptr_t;
# 45 "C:/avr-gcc/avr/include/stdio.h" 2 3
# 1 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdarg.h" 1 3 4
# 40 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdarg.h" 3 4
typedef __builtin_va_list __gnuc_va_list;
# 103 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stdarg.h" 3 4
typedef __gnuc_va_list va_list;
# 46 "C:/avr-gcc/avr/include/stdio.h" 2 3




# 1 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 1 3 4
# 229 "C:/avr-gcc/lib/gcc/avr/15.2.0/include/stddef.h" 3 4
typedef unsigned int size_t;
# 51 "C:/avr-gcc/avr/include/stdio.h" 2 3
# 250 "C:/avr-gcc/avr/include/stdio.h" 3
struct __file {
 char *buf;
 unsigned char unget;
 uint8_t flags;
# 269 "C:/avr-gcc/avr/include/stdio.h" 3
 int size;
 int len;
 int (*put)(char, struct __file *);
 int (*get)(struct __file *);
 void *udata;
};
# 283 "C:/avr-gcc/avr/include/stdio.h" 3
typedef struct __file FILE;
# 420 "C:/avr-gcc/avr/include/stdio.h" 3
extern struct __file *__iob[];
# 432 "C:/avr-gcc/avr/include/stdio.h" 3
extern FILE *fdevopen(int (*__put)(char, FILE*), int (*__get)(FILE*));
# 449 "C:/avr-gcc/avr/include/stdio.h" 3
extern int fclose(FILE *__stream);
# 623 "C:/avr-gcc/avr/include/stdio.h" 3
extern int vfprintf(FILE *__stream, const char *__fmt, va_list __ap);





extern int vfprintf_P(FILE *__stream, const char *__fmt, va_list __ap);






extern int fputc(int __c, FILE *__stream);




extern int putc(int __c, FILE *__stream);


extern int putchar(int __c);
# 664 "C:/avr-gcc/avr/include/stdio.h" 3
extern int printf(const char *__fmt, ...);





extern int printf_P(const char *__fmt, ...);







extern int vprintf(const char *__fmt, va_list __ap);





extern int sprintf(char *__s, const char *__fmt, ...);





extern int sprintf_P(char *__s, const char *__fmt, ...);
# 700 "C:/avr-gcc/avr/include/stdio.h" 3
extern int snprintf(char *__s, size_t __n, const char *__fmt, ...);





extern int snprintf_P(char *__s, size_t __n, const char *__fmt, ...);





extern int vsprintf(char *__s, const char *__fmt, va_list ap);





extern int vsprintf_P(char *__s, const char *__fmt, va_list ap);
# 728 "C:/avr-gcc/avr/include/stdio.h" 3
extern int vsnprintf(char *__s, size_t __n, const char *__fmt, va_list ap);





extern int vsnprintf_P(char *__s, size_t __n, const char *__fmt, va_list ap);




extern int fprintf(FILE *__stream, const char *__fmt, ...);





extern int fprintf_P(FILE *__stream, const char *__fmt, ...);






extern int fputs(const char *__str, FILE *__stream);




extern int fputs_P(const char *__str, FILE *__stream);





extern int puts(const char *__str);




extern int puts_P(const char *__str);
# 777 "C:/avr-gcc/avr/include/stdio.h" 3
extern size_t fwrite(const void *__ptr, size_t __size, size_t __nmemb,
         FILE *__stream);







extern int fgetc(FILE *__stream);




extern int getc(FILE *__stream);


extern int getchar(void);
# 825 "C:/avr-gcc/avr/include/stdio.h" 3
extern int ungetc(int __c, FILE *__stream);
# 837 "C:/avr-gcc/avr/include/stdio.h" 3
extern char *fgets(char *__str, int __size, FILE *__stream);






extern char *gets(char *__str);
# 855 "C:/avr-gcc/avr/include/stdio.h" 3
extern size_t fread(void *__ptr, size_t __size, size_t __nmemb,
        FILE *__stream);




extern void clearerr(FILE *__stream);
# 872 "C:/avr-gcc/avr/include/stdio.h" 3
extern int feof(FILE *__stream);
# 883 "C:/avr-gcc/avr/include/stdio.h" 3
extern int ferror(FILE *__stream);






extern int vfscanf(FILE *__stream, const char *__fmt, va_list __ap);




extern int vfscanf_P(FILE *__stream, const char *__fmt, va_list __ap);







extern int fscanf(FILE *__stream, const char *__fmt, ...);




extern int fscanf_P(FILE *__stream, const char *__fmt, ...);






extern int scanf(const char *__fmt, ...);




extern int scanf_P(const char *__fmt, ...);







extern int vscanf(const char *__fmt, va_list __ap);







extern int sscanf(const char *__buf, const char *__fmt, ...);




extern int sscanf_P(const char *__buf, const char *__fmt, ...);
# 953 "C:/avr-gcc/avr/include/stdio.h" 3
static __inline__ int fflush(FILE *stream __attribute__((unused)))
{
 return 0;
}






__extension__ typedef long long fpos_t;
extern int fgetpos(FILE *stream, fpos_t *pos);
extern FILE *fopen(const char *path, const char *mode);
extern FILE *freopen(const char *path, const char *mode, FILE *stream);
extern FILE *fdopen(int, const char *);
extern int fseek(FILE *stream, long offset, int whence);
extern int fsetpos(FILE *stream, fpos_t *pos);
extern long ftell(FILE *stream);
extern int fileno(FILE *);
extern void perror(const char *s);
extern int remove(const char *pathname);
extern int rename(const char *oldpath, const char *newpath);
extern void rewind(FILE *stream);
extern void setbuf(FILE *stream, char *buf);
extern int setvbuf(FILE *stream, char *buf, int mode, size_t size);
extern FILE *tmpfile(void);
extern char *tmpnam (char *s);
# 2 "LIB/softrtc.c" 2
# 1 "LIB/softrtc.h" 1



# 1 "LIB/STD_TYPES.h" 1




# 4 "LIB/STD_TYPES.h"
typedef unsigned char uint8;
typedef signed char sint8;
typedef unsigned short uint16;
typedef signed short sint16;
typedef unsigned long uint32;
typedef signed long sint32;
typedef unsigned long long uint64;
typedef signed long long sint64;

typedef float float32;
typedef double float64;
# 23 "LIB/STD_TYPES.h"
typedef uint8 STD_ReturnType;
# 5 "LIB/softrtc.h" 2

void RTC_Tick10ms(void);
uint32 RTC_Seconds(void);
void RTC_Format(uint32 Copy_u32Sec, char *Copy_pcBuf);
# 3 "LIB/softrtc.c" 2

static volatile uint32 g_u32UptimeSec = 0;
static uint8 g_u8SubTick = 0;

void RTC_Tick10ms(void) {
    if (++g_u8SubTick >= 100u) {
        g_u8SubTick = 0;
        g_u32UptimeSec++;
    }
}

uint32 RTC_Seconds(void) {
    return g_u32UptimeSec;
}

void RTC_Format(uint32 Copy_u32Sec, char *Copy_pcBuf) {
    uint32 Local_u32Hours = Copy_u32Sec / 3600u;
    uint8 Local_u8Minutes = (uint8)((Copy_u32Sec % 3600u) / 60u);
    uint8 Local_u8Seconds = (uint8)(Copy_u32Sec % 60u);

    sprintf(Copy_pcBuf, "%03lu:%02u:%02u", (unsigned long)Local_u32Hours, Local_u8Minutes, Local_u8Seconds);
}
