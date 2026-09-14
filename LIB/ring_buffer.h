#ifndef RING_BUFFER_H
#define RING_BUFFER_H

#include "STD_TYPES.h"

typedef struct
{
    uint8 *buffer;
    uint16 capacity;
    uint16 head;
    uint16 tail;
    uint16 count;
} RingBuffer;

STD_ReturnType RingBuffer_Init(
    RingBuffer *Copy_pstBuffer,
    uint8 *Copy_pu8Array,
    uint16 Copy_u16Capacity
);

STD_ReturnType RingBuffer_Push(
    RingBuffer *Copy_pstBuffer,
    uint8 Copy_u8Data
);

STD_ReturnType RingBuffer_Pop(
    RingBuffer *Copy_pstBuffer,
    uint8 *Copy_pu8Data
);

STD_ReturnType RingBuffer_IsEmpty(
    RingBuffer *Copy_pstBuffer,
    uint8 *Copy_pu8Result
);

STD_ReturnType RingBuffer_IsFull(
    RingBuffer *Copy_pstBuffer,
    uint8 *Copy_pu8Result
);

STD_ReturnType RingBuffer_Size(
    RingBuffer *Copy_pstBuffer,
    uint16 *Copy_pu16Size
);

STD_ReturnType RingBuffer_Clear(
    RingBuffer *Copy_pstBuffer
);

#endif