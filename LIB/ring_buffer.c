#include "ring_buffer.h"

STD_ReturnType RingBuffer_Init(
    RingBuffer *Copy_pstBuffer,
    uint8 *Copy_pu8Array,
    uint16 Copy_u16Capacity
)
{
    if ((Copy_pstBuffer == NULL) ||
        (Copy_pu8Array == NULL) ||
        (Copy_u16Capacity == 0u))
    {
        return E_NOK;
    }

    Copy_pstBuffer->buffer = Copy_pu8Array;
    Copy_pstBuffer->capacity = Copy_u16Capacity;
    Copy_pstBuffer->head = 0u;
    Copy_pstBuffer->tail = 0u;
    Copy_pstBuffer->count = 0u;

    return E_OK;
}

STD_ReturnType RingBuffer_Push(
    RingBuffer *Copy_pstBuffer,
    uint8 Copy_u8Data
)
{
    if (Copy_pstBuffer == NULL)
    {
        return E_NOK;
    }

    if (Copy_pstBuffer->count >= Copy_pstBuffer->capacity)
    {
        return E_NOK;
    }

    Copy_pstBuffer->buffer[Copy_pstBuffer->head] = Copy_u8Data;

    Copy_pstBuffer->head++;
    if (Copy_pstBuffer->head >= Copy_pstBuffer->capacity)
    {
        Copy_pstBuffer->head = 0u;
    }

    Copy_pstBuffer->count++;

    return E_OK;
}

STD_ReturnType RingBuffer_Pop(
    RingBuffer *Copy_pstBuffer,
    uint8 *Copy_pu8Data
)
{
    if ((Copy_pstBuffer == NULL) || (Copy_pu8Data == NULL))
    {
        return E_NOK;
    }

    if (Copy_pstBuffer->count == 0u)
    {
        return E_NOK;
    }

    *Copy_pu8Data = Copy_pstBuffer->buffer[Copy_pstBuffer->tail];

    Copy_pstBuffer->tail++;
    if (Copy_pstBuffer->tail >= Copy_pstBuffer->capacity)
    {
        Copy_pstBuffer->tail = 0u;
    }

    Copy_pstBuffer->count--;

    return E_OK;
}

STD_ReturnType RingBuffer_IsEmpty(
    RingBuffer *Copy_pstBuffer,
    uint8 *Copy_pu8Result
)
{
    if ((Copy_pstBuffer == NULL) || (Copy_pu8Result == NULL))
    {
        return E_NOK;
    }

    *Copy_pu8Result = (Copy_pstBuffer->count == 0u) ? STD_HIGH : STD_LOW;

    return E_OK;
}

STD_ReturnType RingBuffer_IsFull(
    RingBuffer *Copy_pstBuffer,
    uint8 *Copy_pu8Result
)
{
    if ((Copy_pstBuffer == NULL) || (Copy_pu8Result == NULL))
    {
        return E_NOK;
    }

    *Copy_pu8Result =
        (Copy_pstBuffer->count >= Copy_pstBuffer->capacity)
        ? STD_HIGH
        : STD_LOW;

    return E_OK;
}

STD_ReturnType RingBuffer_Size(
    RingBuffer *Copy_pstBuffer,
    uint16 *Copy_pu16Size
)
{
    if ((Copy_pstBuffer == NULL) || (Copy_pu16Size == NULL))
    {
        return E_NOK;
    }

    *Copy_pu16Size = Copy_pstBuffer->count;

    return E_OK;
}

STD_ReturnType RingBuffer_Clear(
    RingBuffer *Copy_pstBuffer
)
{
    if (Copy_pstBuffer == NULL)
    {
        return E_NOK;
    }

    Copy_pstBuffer->head = 0u;
    Copy_pstBuffer->tail = 0u;
    Copy_pstBuffer->count = 0u;

    return E_OK;
}