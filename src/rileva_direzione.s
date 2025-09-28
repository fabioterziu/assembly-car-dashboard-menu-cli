#invio ascii 10
#freccia su ^[[A sequenza ascii 27 91 65
#freccia giu ^[[B sequenza ascii 27 91 66
#freccia destra ^[[C sequenza ascii 27 91 67
#freccia sinistra ^[[D sequenza ascii 27 91 68
#invio ascii 10



.section .data
  input_freccia: 
    .ascii "00000"   



.section .text

.global rileva_direzione

.type rileva_direzione, @function

            

rileva_direzione:		
	xorl %ecx, %ecx

 movl %esp, %esi 
  movl $3, %eax
  movl $1, %ebx
  leal input_freccia, %ecx 		#il risultato viene salvato in ecx
  movl $5, %edx            
  int $0x80

xorl %edx, %edx

movb (%ecx, %edx), %al      #sposto il primo byte(carattere)
	cmpb $10, %al 	          #se invio devo uscire
	je fine 
	cmpb $27, %al 		  	    #se ^[ vado avanti, se valore diverso esco
	jne svuota_buffer
	incl %edx

movb (%ecx, %edx), %al 		  #sposto secondo carattere
  cmpb $91, %al 		 				#se [ vado avanti, se valore diverso esco
	jne svuota_buffer
	incl %edx

movb (%ecx, %edx), %al 		  #sposto terzo carattere
incl %edx										#non faccio controlli sul 3 carattere

	
  movb (%ecx, %edx), %ah 		#sposto quarto carattere
  cmpb $10, %ah 		 				#se invio è molto probabile che abbia una freccia (non ho controllato terzo carattere)
  je fine




	incl %edx	
  movb (%ecx, %edx), %ah 		#sposto quinto carattere
  cmpb $48, %ah 		 				#se [ vado avanti, se valore diverso esco			
  je fine

  svuota_buffer:
  movl %esp, %esi 
  movl $3, %eax
  movl $1, %ebx
  leal input_freccia, %ecx
  movl $1, %edx            
  int $0x80

  movb (%ecx), %al
  cmpb $10, %al
  jne svuota_buffer
  

	
input_errato:
 movb $0, %al           # se l'input non è una freccia metto 0 in nel registro a

fine:
movl %esi, %esp 



  ret


