UNAME := $(shell uname)

MIPSEL_TOOLCHAIN_PREFIX=mipsel-openwrt-linux-
ARM_TOOLCHAIN_PREFIX=arm-linux-gnueabihf-
MINGW_TOOLCHAIN_PREFIX=i586-mingw32msvc-

ifndef TARGET
ifeq ($(UNAME), Linux)
TARGET=POSIX
else ifeq ($(findstring MINGW,$(UNAME)), MINGW)
TARGET=WIN32
endif
endif

ifeq ($(TARGET), WIN32)
HAL_IMPL = WIN32
LIB_OBJS_DIR = build_win32
CFLAGS=-g -Wno-error=incompatible-pointer-types -fcommon -Wl,--allow-multiple-definition -include stdlib.h -include string.h -include byte_buffer.h -include linked_list.h -include mms_server.h -DWIN32
LDLIBS=-lws2_32
else
HAL_IMPL = POSIX

ifeq ($(TARGET), LINUX-MIPSEL)
LIB_OBJS_DIR = build-mipsel
else ifeq ($(TARGET), LINUX-ARM)
LIB_OBJS_DIR = build-arm
else
LIB_OBJS_DIR = build
endif

CFLAGS=-g -Wno-error=incompatible-pointer-types -fcommon -include stdlib.h -include string.h -include byte_buffer.h -include linked_list.h -include mms_server.h
LDFLAGS=-Wl,--allow-multiple-definition
LDLIBS=-lpthread
endif

CC=$(TOOLCHAIN_PREFIX)gcc
CPP=$(TOOLCHAIN_PREFIX)g++
AR=$(TOOLCHAIN_PREFIX)ar
RANLIB=$(TOOLCHAIN_PREFIX)ranlib

BIN_DIR = bin

EXAMPLE_1 = simple_server_example1
EXAMPLE_2 = mms_client_example
EXAMPLE_3 = simple_server_example2
EXAMPLE_4 = simple_server_example3
EXAMPLE_5 = mms_server_example

ifeq ($(TARGET), WIN32)
EXAMPLE_1 := $(EXAMPLE_1).exe
EXAMPLE_2 := $(EXAMPLE_2).exe
EXAMPLE_3 := $(EXAMPLE_3).exe
EXAMPLE_4 := $(EXAMPLE_4).exe
EXAMPLE_5 := $(EXAMPLE_5).exe
endif

EXAMPLES = bin/$(EXAMPLE_1) bin/$(EXAMPLE_2) bin/$(EXAMPLE_3) bin/$(EXAMPLE_4) bin/$(EXAMPLE_5)

LIB_NAME = $(LIB_OBJS_DIR)/libiec61850.a

INCLUDES = -Iinc
INCLUDES += -Isrc/common
INCLUDES += -Isrc/mms/iso_presentation
INCLUDES += -Isrc/mms/iso_presentation/asn1c
INCLUDES += -Isrc/mms/iso_session
INCLUDES += -Isrc/mms/iso_cotp 
INCLUDES += -Isrc/mms/iso_acse
INCLUDES += -Isrc/mms/iso_acse/asn1c
INCLUDES += -Isrc/mms/iso_mms/common
INCLUDES += -Isrc/mms/iso_mms/client
INCLUDES += -Isrc/mms/iso_mms/server
INCLUDES += -Isrc/mms/iso_client
INCLUDES += -Isrc/mms/iso_server
INCLUDES += -Isrc/mms/asn1
INCLUDES += -Isrc/mms_mapping
INCLUDES += -Isrc/model
INCLUDES += -Isrc/api
INCLUDES += -Isrc/hal
INCLUDES += -Isrc/hal/thread
INCLUDES += -Isrc/hal/socket

LIB_SOURCE_DIRS = src/mms/iso_acse
LIB_SOURCE_DIRS += src/mms/iso_acse/asn1c
LIB_SOURCE_DIRS += src/mms/iso_presentation/asn1c 
LIB_SOURCE_DIRS += src/mms/iso_presentation
LIB_SOURCE_DIRS += src/mms/iso_session
LIB_SOURCE_DIRS += src/common
LIB_SOURCE_DIRS += src/mms/asn1
LIB_SOURCE_DIRS += src/mms/iso_cotp
LIB_SOURCE_DIRS += src/mms/iso_mms/server
LIB_SOURCE_DIRS += src/mms/iso_mms/client
LIB_SOURCE_DIRS += src/mms/iso_client/impl
LIB_SOURCE_DIRS += src/mms/iso_mms/common
LIB_SOURCE_DIRS += src/mms/iso_mms/asn1c
LIB_SOURCE_DIRS += src/mms_mapping
LIB_SOURCE_DIRS += src/model
LIB_SOURCE_DIRS += src/mms/iso_server
LIB_SOURCE_DIRS += src/iedserver/simple_api
LIB_SOURCE_DIRS += src/hal
ifeq ($(HAL_IMPL), WIN32)
LIB_SOURCE_DIRS += src/hal/socket/win32
LIB_SOURCE_DIRS += src/hal/thread/win32
else ifeq ($(HAL_IMPL), POSIX)
LIB_SOURCE_DIRS += src/hal/socket/linux
LIB_SOURCE_DIRS += src/hal/thread/linux
endif

LIB_INCLUDES = -Isrc/mms/iso_presentation/asn1c
LIB_INCLUDES +=	-Isrc/mms/iso_presentation
LIB_INCLUDES +=	-Isrc/mms/iso_session
LIB_INCLUDES +=	-Isrc/mms/iso_cotp
LIB_INCLUDES +=	-Isrc/mms/iso_acse
LIB_INCLUDES +=	-Isrc/mms/iso_acse/asn1c
LIB_INCLUDES +=	-Iinc
LIB_INCLUDES += -Isrc/mms/asn1
LIB_INCLUDES += -Isrc/mms
LIB_INCLUDES += -Isrc/mms/iso_client
LIB_INCLUDES += -Isrc/mms/iso_server
LIB_INCLUDES +=	-Isrc/mms/iso_mms
LIB_INCLUDES +=	-Isrc/mms/iso_mms/asn1c
LIB_INCLUDES +=	-Isrc/mms/iso_mms/client
LIB_INCLUDES +=	-Isrc/mms/iso_mms/common
LIB_INCLUDES +=	-Isrc/mms/iso_mms/server
LIB_INCLUDES +=	-Isrc/mms_mapping
LIB_INCLUDES +=	-Isrc/model
LIB_INCLUDES +=	-Isrc/common
LIB_INCLUDES +=	-Isrc/hal/socket
LIB_INCLUDES +=	-Isrc/hal/thread
LIB_INCLUDES +=	-Isrc/hal
LIB_INCLUDES +=	-Isrc/api
LIB_INCLUDES +=	-Isrc/mms/iso_server

get_sources_from_directory  = $(wildcard $1/*.c)
get_sources = $(foreach dir, $1, $(call get_sources_from_directory,$(dir)))
src_to = $(addprefix $(LIB_OBJS_DIR)/,$(subst .c,$1,$2))

LIB_SOURCES = $(call get_sources,$(LIB_SOURCE_DIRS))
LIB_OBJS = $(call src_to,.o,$(LIB_SOURCES))

all:	lib

examples:	$(EXAMPLES)

lib:	$(LIB_NAME)

$(LIB_NAME):	$(LIB_OBJS)
	$(AR) r $(LIB_NAME) $(LIB_OBJS)
	$(RANLIB) $(LIB_NAME)

$(LIB_OBJS_DIR)/%.o: %.c
	@echo compiling $(notdir $<)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $(LIB_INCLUDES) $(OUTPUT_OPTION) $<

# Novas regras robustas para compilação dos exemplos usando objetos intermediários
bin/$(EXAMPLE_1): examples/simple_server_example1.c examples/static_model.c $(LIB_NAME)
	@mkdir -p bin
	$(CC) $(CFLAGS) $(INCLUDES) -c examples/simple_server_example1.c -o bin/simple_server_example1.o
	$(CC) $(CFLAGS) $(INCLUDES) -c examples/static_model.c -o bin/static_model1.o
	$(CC) $(CFLAGS) -o bin/$(EXAMPLE_1) bin/simple_server_example1.o bin/static_model1.o $(LIB_NAME) $(LDFLAGS) $(LDLIBS)
	@rm -f bin/*.o

bin/$(EXAMPLE_2): examples/mms_client_example.c $(LIB_NAME)
	@mkdir -p bin
	$(CC) $(CFLAGS) $(INCLUDES) -c examples/mms_client_example.c -o bin/mms_client_example.o
	$(CC) $(CFLAGS) -o bin/$(EXAMPLE_2) bin/mms_client_example.o $(LIB_NAME) $(LDFLAGS) $(LDLIBS)
	@rm -f bin/*.o
	
bin/$(EXAMPLE_3): examples/simple_server_example2.c examples/static_model.c $(LIB_NAME)
	@mkdir -p bin
	$(CC) $(CFLAGS) $(INCLUDES) -c examples/simple_server_example2.c -o bin/simple_server_example2.o
	$(CC) $(CFLAGS) $(INCLUDES) -c examples/static_model.c -o bin/static_model3.o
	$(CC) $(CFLAGS) -o bin/$(EXAMPLE_3) bin/simple_server_example2.o bin/static_model3.o $(LIB_NAME) $(LDFLAGS) $(LDLIBS)
	@rm -f bin/*.o
	
bin/$(EXAMPLE_4): examples/simple_server_example3.c examples/static_model.c $(LIB_NAME)
	@mkdir -p bin
	$(CC) $(CFLAGS) $(INCLUDES) -c examples/simple_server_example3.c -o bin/simple_server_example3.o
	$(CC) $(CFLAGS) $(INCLUDES) -c examples/static_model.c -o bin/static_model4.o
	$(CC) $(CFLAGS) -o bin/$(EXAMPLE_4) bin/simple_server_example3.o bin/static_model4.o $(LIB_NAME) $(LDFLAGS) $(LDLIBS)
	@rm -f bin/*.o
	
bin/$(EXAMPLE_5): examples/mms_server_example.c examples/static_model.c $(LIB_NAME)
	@mkdir -p bin
	$(CC) $(CFLAGS) $(INCLUDES) -c examples/mms_server_example.c -o bin/mms_server_example.o
	$(CC) $(CFLAGS) $(INCLUDES) -c examples/static_model.c -o bin/static_model5.o
	$(CC) $(CFLAGS) -o bin/$(EXAMPLE_5) bin/mms_server_example.o bin/static_model5.o $(LIB_NAME) $(LDFLAGS) $(LDLIBS)
	@rm -f bin/*.o

clean:
	rm -rf $(LIB_OBJS_DIR)
	rm -rf bin
