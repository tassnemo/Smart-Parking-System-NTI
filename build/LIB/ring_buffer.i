# 0 "LIB/ring_buffer.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "LIB/ring_buffer.c"
# 1 "LIB/ring_buffer.h" 1



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
# 5 "LIB/ring_buffer.h" 2

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
# 2 "LIB/ring_buffer.c" 2

STD_ReturnType RingBuffer_Init(
    RingBuffer *Copy_pstBuffer,
    uint8 *Copy_pu8Array,
    uint16 Copy_u16Capacity
)
{
    if ((Copy_pstBuffer == ((void *)0)) ||
        (Copy_pu8Array == ((void *)0)) ||
        (Copy_u16Capacity == 0u))
    {
        return 1u;
    }

    Copy_pstBuffer->buffer = Copy_pu8Array;
    Copy_pstBuffer->capacity = Copy_u16Capacity;
    Copy_pstBuffer->head = 0u;
    Copy_pstBuffer->tail = 0u;
    Copy_pstBuffer->count = 0u;

    return 0u;
}

STD_ReturnType RingBuffer_Push(
    RingBuffer *Copy_pstBuffer,
    uint8 Copy_u8Data
)
{
    if (Copy_pstBuffer == ((void *)0))
    {
        return 1u;
    }

    if (Copy_pstBuffer->count >= Copy_pstBuffer->capacity)
    {
        return 1u;
    }

    Copy_pstBuffer->buffer[Copy_pstBuffer->head] = Copy_u8Data;

    Copy_pstBuffer->head++;
    if (Copy_pstBuffer->head >= Copy_pstBuffer->capacity)
    {
        Copy_pstBuffer->head = 0u;
    }

    Copy_pstBuffer->count++;

    return 0u;
}

STD_ReturnType RingBuffer_Pop(
    RingBuffer *Copy_pstBuffer,
    uint8 *Copy_pu8Data
)
{
    if ((Copy_pstBuffer == ((void *)0)) || (Copy_pu8Data == ((void *)0)))
    {
        return 1u;
    }

    if (Copy_pstBuffer->count == 0u)
    {
        return 1u;
    }

    *Copy_pu8Data = Copy_pstBuffer->buffer[Copy_pstBuffer->tail];

    Copy_pstBuffer->tail++;
    if (Copy_pstBuffer->tail >= Copy_pstBuffer->capacity)
    {
        Copy_pstBuffer->tail = 0u;
    }

    Copy_pstBuffer->count--;

    return 0u;
}

STD_ReturnType RingBuffer_IsEmpty(
    RingBuffer *Copy_pstBuffer,
    uint8 *Copy_pu8Result
)
{
    if ((Copy_pstBuffer == ((void *)0)) || (Copy_pu8Result == ((void *)0)))
    {
        return 1u;
    }

    *Copy_pu8Result = (Copy_pstBuffer->count == 0u) ? 1u : 0u;

    return 0u;
}

STD_ReturnType RingBuffer_IsFull(
    RingBuffer *Copy_pstBuffer,
    uint8 *Copy_pu8Result
)
{
    if ((Copy_pstBuffer == ((void *)0)) || (Copy_pu8Result == ((void *)0)))
    {
        return 1u;
    }

    *Copy_pu8Result =
        (Copy_pstBuffer->count >= Copy_pstBuffer->capacity)
        ? 1u
        : 0u;

    return 0u;
}

STD_ReturnType RingBuffer_Size(
    RingBuffer *Copy_pstBuffer,
    uint16 *Copy_pu16Size
)
{
    if ((Copy_pstBuffer == ((void *)0)) || (Copy_pu16Size == ((void *)0)))
    {
        return 1u;
    }

    *Copy_pu16Size = Copy_pstBuffer->count;

    return 0u;
}

STD_ReturnType RingBuffer_Clear(
    RingBuffer *Copy_pstBuffer
)
{
    if (Copy_pstBuffer == ((void *)0))
    {
        return 1u;
    }

    Copy_pstBuffer->head = 0u;
    Copy_pstBuffer->tail = 0u;
    Copy_pstBuffer->count = 0u;

    return 0u;
}
