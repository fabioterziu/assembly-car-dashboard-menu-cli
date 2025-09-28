
BIN= bin/menu							
AS_FLAGS= as --32 -gstabs 
LD_FLAGS= ld -m elf_i386
OBJ= obj/main.o obj/menu.o obj/sottomenu.o obj/rileva_direzione.o obj/rileva_numero.o

all: $(OBJ) 				
	$(LD_FLAGS) $(OBJ) -o $(BIN)  		

obj/main.o: src/main.s 								
	$(AS_FLAGS) src/main.s -o obj/main.o 

obj/menu.o: src/menu.s 
	$(AS_FLAGS) src/menu.s -o obj/menu.o 

obj/sottomenu.o: src/sottomenu.s 								
	$(AS_FLAGS) src/sottomenu.s -o obj/sottomenu.o  	 

obj/rileva_direzione.o: src/rileva_direzione.s 
	$(AS_FLAGS) src/rileva_direzione.s -o obj/rileva_direzione.o 

obj/rileva_numero.o: src/rileva_numero.s 
	$(AS_FLAGS) src/rileva_numero.s -o obj/rileva_numero.o 	

.PHONY:clean
clean: 
	rm -f $(OBJ) $(BIN)

