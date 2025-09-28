.section .data

user:
    .long 0             #0 utente normale, 1 supervisor

max_posizione:
    .long 6             #6 utente normale, 8 supervisor

posizione_menu:
   .long 1              # Dove mi trovo sul menu

sottomenu:
   .long 0              # 0 menu 1 sottomenu

porte:                  # porte 0 off 1 on
    .long 0

home:                   # backhome 0 off 1 on
    .long 0    
    
frecce:                 # valore delle frecce
    .ascii "3"


#Variabili non utilizzate
errore_comando: 
   .ascii "Comando non valido\n"
errore_comando_len:
   .long . - errore_comando

ClearTerm: 
   .ascii   "\033[H\033[2J"   # <ESC> [H <ESC> [2J
CLEARLEN:   
   .long  . - ClearTerm       # Length of term clear string


.section .text
    .global _start
_start:
                           #controllo se è stato passato un parametro, se = 2244 sono supervisor
   xorl %eax, %eax         #pulisco registro eax
   movl (%esp), %eax       #metto argc in eax  
   cmpl $2, %eax           #se passo un parametro, argc = 2
   je verificacodice       
   jmp inizializzazione


verificacodice:
   xorl %edx, %edx
   xorl %eax, %eax

   movl 8(%esp), %eax         #in questa zona di memoria trovo il parametro passato, (%esp) contiene argc(numero di valori nel vettore argv), 4(%esp) contiene il primo valore di argv

   movb (%eax,%edx), %cl      #edx è lo spiazzamento, adesso è = 0
   testb %cl, %cl             #controllo se ci sono altri caratteri
   jz inizializzazione        #se risultato di test è zero esco dal controllo
   cmpb $50, %cl              #comparo il 2 (50 in ascii) con cl
   jne inizializzazione  
   
   incl %edx

   movb (%eax,%edx), %cl
   testb %cl, %cl    
   jz inizializzazione
   cmpb $50, %cl              #comparo il 2 (50 in ascii) con cl
   jne inizializzazione  
   
   incl %edx
   
   movb (%eax,%edx), %cl
   testb %cl, %cl    
   jz inizializzazione
   cmpb $52, %cl              #comparo il 4 (52 in ascii) con cl
   jne inizializzazione  
   
   incl %edx   
   
   movb (%eax,%edx), %cl
   testb %cl, %cl    
   jz inizializzazione
   cmpb $52, %cl              #comparo il 4 (52 in ascii) con cl
   jne inizializzazione  

   incl %edx   
   
   movb (%eax,%edx), %cl      #controllo che non ci siano altri caratteri dopo 2244
   testb %cl, %cl    
   jnz inizializzazione
      
   leal user , %ebx
   movl $1, (%ebx)            #cambio il valore di user per modalita supervisor
   leal max_posizione , %ebx
   movl $8, (%ebx)            #cambio il valore di max posizione per modalita supervisor

   
inizializzazione:             #carico tutte le variabili che serviranno alle funzioni chiamate, non carico i valori ma i relativi indirizzi di memoria
   leal user, %eax            # esp+20
   pushl %eax   
   leal frecce, %eax          # esp+16
   pushl %eax   
   leal home, %eax            # esp+12
   pushl %eax   
   leal porte, %eax           # esp+8
   pushl %eax   
   leal posizione_menu, %eax  # esp+4
   pushl %eax 


inizio_menu:

                              #   movl $4, %eax
                              #   movl $1, %ebx
                              #   leal ClearTerm, %ecx
                              #   movl CLEARLEN, %edx
                              #   int $0x80


   leal sottomenu, %ebx       #controllo se mi trovo in un sottomenu
   cmpl $1, (%ebx)
   je inizio_sottomenu

   call print_menu

inizio_rilevamento:
   call rileva_direzione


    cmpb $65, %al             # comparo con A la freccia
    je su
    cmpb $66, %al             # comparo con B la freccia    
    je giu
    cmpb $67, %al             # comparo con C la freccia
    je destra
    cmpb $10, %al             # controllo se ho ricevuto solo un invio
    je invio
    cmpb $0, %al          
    je input_errato
   cmpb $68, %al          
    je fine

    jmp fine                  # se non ho nessuno dei casi precedenti esco


su:
   xorl %eax, %eax        
   leal posizione_menu, %edi            
   cmpl $1, (%edi)
   je posizione_negativa      # se sono in posizione in posizione uno vado in max posizione
   decl (%edi)                # altrimenti decremento posizione_menu
   jmp inizio_menu                         

posizione_negativa:
   leal posizione_menu, %edi 
   leal max_posizione, %esi   
   movl (%esi) , %ebx
   movl %ebx , (%edi)              
   jmp inizio_menu          
   

giu:
   leal posizione_menu, %edi             
   movl (%edi), %ebx
   leal max_posizione, %esi   
   cmpl %ebx, (%esi)
   je posizione_reset         #se sono in max posizione vado in posizione 1
   incl (%edi)                #altrimenti incremento posizione_menu
   jmp inizio_menu 


input_errato:
                              #movl $4, %eax               
                              #movl $1, %ebx               
                              #leal errore_comando, %ecx       
                              #movl errore_comando_len, %edx   
                              #int $0x80
   jmp inizio_menu


posizione_reset:
   movl $1, (%edi) 
   jmp inizio_menu


destra:                       #controllo se esiste un sottomenu per l'attuale posizione  
   leal posizione_menu, %edi                
   cmpl $4, (%edi)
   je sottomenu_on

   cmpl $5, (%edi)
   je sottomenu_on

   cmpl $7, (%edi)
   je sottomenu_on

   cmpl $8, (%edi)
   je sottomenu_on
   jmp inizio_menu


sottomenu_on:                 #accendo la variabile sottomenu e torno ad inizio ciclo
   leal sottomenu, %edi                
   movl $1 , (%edi)              
   jmp inizio_menu


inizio_sottomenu:
   call print_sottomenu
   leal posizione_menu, %edi   
   cmpl $8, (%edi)            #se sono in posizione 8 devo solo stampare una stringa senza rilevare un input
   je invio
   
   
   leal posizione_menu, %edi             # 
   cmpl $4, (%edi)
   je cambiaporta
   cmpl $5, (%edi)
   je cambiahome
   cmpl $7, (%edi)
   je cambiafreccia
   jmp invio


cambiaporta:
call rileva_direzione
   cmpb $65, %al          
   je setporta
   cmpb $66, %al          
   je setporta
   cmpb $10, %al
   je invio
   jmp input_errato

setporta:
   leal porte , %ebx     
   cmpl $1, (%ebx)
   je reset_stato
   movl $1, (%ebx)
   jmp inizio_menu
   reset_stato:
   movl $0, (%ebx)
   jmp inizio_menu


cambiahome:
call rileva_direzione
   cmpb $65, %al          
   je sethome
   cmpb $66, %al         
   je sethome
   cmpb $10, %al
   je invio
   jmp input_errato

sethome:
   leal home , %ebx     
   cmpl $1, (%ebx)
   je reset_stato
   movl $1, (%ebx)
   jmp inizio_menu


cambiafreccia:
   call rileva_numero
   cmpb $10, %al
   je invio
   jmp inizio_menu


invio:
   leal sottomenu , %ebx      #se sono nel sottomenu esco dal sottomenu, si potrebbe resettare in ogni caso senza condizione
   cmpl $1 , (%ebx)
   je reset_sottomenu
   jmp inizio_menu


reset_sottomenu:
   movl $0, (%ebx)
   jmp inizio_menu


fine:
   movl %ebp, %esp            # ripristino lo stack pointer
   movl $1, %eax              # esco dal programma
   movl $0, %ebx        
   int $0x80            
   