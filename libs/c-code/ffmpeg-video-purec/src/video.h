#pragma once

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct Video Video;

Video* video_create(uint8_t* data, int64_t size);
void video_destroy(Video* v);

int video_open(Video* v, char* error, int errorSize);
void video_close(Video* v);

int video_read_frame(Video* v, void* dst, double* timestamp);
int video_seek(Video* v, double time, char* error, int errorSize);

int video_get_width(Video* v);
int video_get_height(Video* v);
double video_get_duration(Video* v);
double video_tell(Video* v);
double video_get_fps(Video* v);

#ifdef __cplusplus
}
#endif
