

TARGET 	= stlv
CC	= gcc
LEX	= flex
YACC	= bison


all: stlv

stlv:  stlv.c 
	$(CC) stlv.c  -lfl -o stlv

#stlv-lib: stlv.c
#	$(CC) stlv.c -DSTLV_LIB -lfl -o stlv.o

#stlv-call: stlv-lib
#	$(CC) stlv_call.c stlv.o -o stlv_call

regenerate-parser:
	make -B stlv.c


stllex.c:  stllex.l
	$(LEX) stllex.l

stlv.c: stlv.y stllex.c
	$(BISON) stlv.y

clean:
	@rm -f $(TARGET) stllex.c stllex.h stlv.c stlv.h *.o *~

test:
	./stlv < ex1.stl
