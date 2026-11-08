LIB_ROOT = ../..
LIB_ROOT = ../..

CC = gcc
CFLAGS = -g -Wno-error=incompatible-pointer-types -fcommon \
         -include stdlib.h -include string.h -include byte_buffer.h \
         -include linked_list.h -include mms_server.h

INCLUDES = -I$(LIB_ROOT)/inc \
           -I$(LIB_ROOT)/src/common \
           -I$(LIB_ROOT)/src/mms/iso_presentation \
           -I$(LIB_ROOT)/src/mms/iso_presentation/asn1c \
           -I$(LIB_ROOT)/src/mms/iso_session \
           -I$(LIB_ROOT)/src/mms/iso_cotp \
           -I$(LIB_ROOT)/src/mms/iso_acse \
           -I$(LIB_ROOT)/src/mms/iso_acse/asn1c \
           -I$(LIB_ROOT)/src/mms/iso_mms/common \
           -I$(LIB_ROOT)/src/mms/iso_mms/client \
           -I$(LIB_ROOT)/src/mms/iso_mms/server \
           -I$(LIB_ROOT)/src/mms/iso_client \
           -I$(LIB_ROOT)/src/mms/iso_server \
           -I$(LIB_ROOT)/src/mms/asn1 \
           -I$(LIB_ROOT)/src/mms_mapping \
           -I$(LIB_ROOT)/src/model \
           -I$(LIB_ROOT)/src/api \
           -I$(LIB_ROOT)/src/hal \
           -I$(LIB_ROOT)/src/hal/thread \
           -I$(LIB_ROOT)/src/hal/socket

# Caminho exato da biblioteca estática gerada pela FLR
LIB_NAME = $(LIB_ROOT)/build/libiec61850.a
LDLIBS = -lpthread -lm

# TARGET alterado para apontar para dentro do diretório bin/
TARGET = bin/IED-Disjuntor

all: $(TARGET)

$(TARGET): IED-Disjuntor.c static_model.c
	@mkdir -p bin
	@echo "Compilando objetos..."
	$(CC) $(CFLAGS) $(INCLUDES) -c IED-Disjuntor.c -o bin/IED-Disjuntor.o
	$(CC) $(CFLAGS) $(INCLUDES) -c static_model.c -o bin/static_model.o
	@echo "Linkando executável final em $(TARGET)..."
	$(CC) -g -fcommon bin/IED-Disjuntor.o bin/static_model.o $(LIB_NAME) -o $(TARGET) $(LDLIBS)
	@echo "=========================================================="
	@echo " Sucesso! Executável '$(TARGET)' gerado com êxito."
	@echo "=========================================================="

clean:
	rm -rf bin
	@echo "Diretório bin/ e arquivos antigos removidos."


