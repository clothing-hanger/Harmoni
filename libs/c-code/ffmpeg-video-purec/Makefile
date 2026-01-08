CC := gcc
TARGET := video.dll
SRC := src/video.c src/lua_video.c
OBJ := $(SRC:.c=.o)

CFLAGS  := -O3 -DNDEBUG -std=c11 -Wall -Wextra -fPIC
LDFLAGS := -shared

FFMPEG_CFLAGS := $(shell pkg-config --cflags libavformat libavcodec libswscale libswresample libavutil)
FFMPEG_LIBS := $(shell pkg-config --libs libavformat libavcodec libswscale libswresample libavutil)

LUA_CFLAGS := $(shell pkg-config --cflags luajit)
LUA_LIBS := $(shell pkg-config --libs luajit)

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(LDFLAGS) -o $@ $^ \
		$(FFMPEG_LIBS) \
		$(LUA_LIBS)

%.o: %.c
	$(CC) $(CFLAGS) \
		$(FFMPEG_CFLAGS) \
		$(LUA_CFLAGS) \
		-c $< -o $@

clean:
	rm -f $(OBJ) $(TARGET)

.PHONY: all clean
