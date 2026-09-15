#include "checksum.h"

uint8 XOR_Checksum(const uint8 *Copy_pu8Buf, uint16 Copy_u16Len) {
    uint8 Local_u8Checksum = 0;
    while (Copy_u16Len--) {
        Local_u8Checksum ^= *Copy_pu8Buf++;
    }
    return Local_u8Checksum;
}