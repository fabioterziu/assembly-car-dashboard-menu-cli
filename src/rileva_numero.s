#invio ascii 10
#numeri ascii da 48 a 57 inclusi



.section .data
  input_numero: 
    .ascii "00000"  


.section .text
.global rileva_numero
.type rileva_numero, @function

            
rileva_numero:

  xorl %ecx, %ecx


  movl %esp, %esi 

  xorl %ecx, %ecx


  movl $3, %eax
  movl $1, %ebx
  leal input_numero, %ecx 		#il risultato viene salvato in ecx
  movl $5, %edx            
  int $0x80

xorl %edx, %edx



primo_carattere:
  movb (%ecx, %edx), %al    #sposto il primo byte(carattere)
	cmpb $10, %al 	          #se invio devo uscire
	je fine 
	cmpb $48, %al 		  	    #controllo se è maggiore di 0 in ascii
	jl input_errato
  cmpb $57, %al             #controllo se è maggiore di 9 in ascii
  jg input_errato           
	incl %edx

secondo_carattere:
  movb (%ecx, %edx), %al    #sposto il primo byte(carattere)
  cmpb $10, %al             #se invio devo uscire
  je fine_sequenza       
  cmpb $48, %al             #controllo se è maggiore di 0 in ascii
  jl input_errato
  cmpb $57, %al             #controllo se è maggiore di 9 in ascii
  jg input_errato           
  incl %edx


  ciclo:
  cmpl $6,%edx
  je input_errato
  movb (%ecx, %edx), %al    #sposto il secondo byte(carattere)
  cmpb $10, %al             #se invio devo uscire
  je max 
  cmpb $48, %al             #controllo se è maggiore di 0 in ascii
  jl input_errato
  cmpb $57, %al             #controllo se è maggiore di 9 in ascii
  jg input_errato           
  incl %edx
  jmp ciclo


fine_sequenza:
  movb (%ecx), %al
  cmpb $50, %al
  jle min
  cmpb $53, %al
  jge max
  movl 16(%esp), %ebx
  movb %al,(%ebx)
jmp fine


min:
  movl 16(%esp), %ebx
  movb $50,(%ebx)
  jmp fine

max:
  movl 16(%esp), %ebx
  movb $53,(%ebx)
  xorl %eax, %eax
  jmp fine

input_errato:
 movb $0, %al           # se l'input non è una freccia metto 0 in nel registro a
 cmpb $5, %dl
 jl fine

svuota_buffer:
  movl %esp, %esi 
  movl $3, %eax
  movl $1, %ebx
  leal input_numero, %ecx
  movl $1, %edx            
  int $0x80

  movb (%ecx), %al
  cmpb $10, %al
  jne svuota_buffer
  xorl %eax, %eax
  
fine:
movl %esi, %esp 



  ret


