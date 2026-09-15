# 0 "LIB/checksum.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "LIB/checksum.c"
# 1 "LIB/checksum.h" 1



# 1 "LIB/STD_TYPES.h" 1



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
# 5 "LIB/checksum.h" 2

uint8 XOR_Checksum(const uint8 *Copy_pu8Buf, uint16 Copy_u16Len);
# 2 "LIB/checksum.c" 2

uint8 XOR_Checksum(const uint8 *Copy_pu8Buf, uint16 Copy_u16Len) {
    uint8 Local_u8Checksum = 0;
    while (Copy_u16Len--) {
        Local_u8Checksum ^= *Copy_pu8Buf++;
    }
    return Local_u8Checksum;
}
