.section .data             

#OPZIONI MENU
    supervisor:
        .ascii "1. Setting automobile (supervisor)\n"

    supervisor_len:
        .long . - supervisor

    utente:
        .ascii "1. Setting automobile:\n"

    utente_len:
        .long . - utente

    data:
        .ascii "2. Data: 15/06/2014\n"
    data_len:
        .long . - data

    ora:
        .ascii "3. Ora: 15:32\n"
    ora_len:
        .long . - ora

    Blocco_automatico_porte_on:
        .ascii "4. Blocco automatico porte: ON\n"
    Blocco_automatico_porte_on_len:
        .long . - Blocco_automatico_porte_on

        Blocco_automatico_porte_off:
        .ascii "4. Blocco automatico porte: OFF\n"
    Blocco_automatico_porte_off_len:
        .long . - Blocco_automatico_porte_off    

    back_home_on:
        .ascii "5. Back-home: ON\n"
    back_home_on_len:
        .long . - back_home_on

    back_home_off:
        .ascii "5. Back-home: OFF\n"
    back_home_off_len:
        .long . - back_home_off

    check_olio:
        .ascii "6. Check olio\n"
    check_olio_len:
        .long . - check_olio

    frecce_direzione:
        .ascii "7. Frecce direzione\n"
    frecce_direzione_len:
        .long . - frecce_direzione

    
    Reset_pressione_gomme:
        .ascii "8. Reset pressione gomme\n"
    Reset_pressione_gomme_len:
        .long . - Reset_pressione_gomme


    


.section .text

.global print_menu

.type print_menu, @function

print_menu:

    movl 4(%esp), %eax        

    cmpl $1, (%eax)            
    je posizione1                  
    cmpl $2, (%eax)             
    je posizione2                    
    cmpl $3, (%eax)             
    je posizione3                   
    cmpl $4, (%eax)             
    je posizione4                 
    cmpl $5, (%eax)             
    je posizione5                    
    cmpl $6, (%eax)            
    je posizione6                
    cmpl $7, (%eax)           
    je posizione7                 
    cmpl $8, (%eax)            
    je posizione8                    



    posizione1:
    movl 20(%esp), %eax          #modalita utente o supervisor

    cmpl $1, (%eax)             
    je modalità_supervisor      #se 1 entro nella modalita supervisore
    movl $4, %eax               
    movl $1, %ebx               
    leal utente, %ecx       
    movl utente_len, %edx   
    int $0x80
    jmp fine


modalità_supervisor:

    movl $4, %eax			    
	movl $1, %ebx			    
	leal supervisor, %ecx  		
	movl supervisor_len, %edx	
	int $0x80
    jmp fine
    



posizione2:
    movl $4, %eax               
    movl $1, %ebx               
    leal data, %ecx       
    movl data_len, %edx   
    int $0x80
    jmp fine

posizione3:
    movl $4, %eax               
    movl $1, %ebx               
    leal ora, %ecx       
    movl ora_len, %edx   
    int $0x80
    jmp fine

posizione4:
    movl 8(%esp), %eax          
    cmpl $1, (%eax)        
    je porte_on
    movl $4, %eax               
    movl $1, %ebx               
    leal Blocco_automatico_porte_off, %ecx       
    movl Blocco_automatico_porte_off_len, %edx   
    int $0x80
    jmp fine
  porte_on:
    movl $4, %eax               
    movl $1, %ebx               
    leal Blocco_automatico_porte_on, %ecx       
    movl Blocco_automatico_porte_on_len, %edx   
    int $0x80
    jmp fine
 

 posizione5:
    movl 12(%esp), %eax         
    cmpl $1, (%eax)     
    je home_on
     movl $4, %eax               
    movl $1, %ebx               
    leal back_home_off, %ecx       
    movl back_home_off_len, %edx   
    int $0x80
    jmp fine
    home_on:
    movl $4, %eax               
    movl $1, %ebx               
    leal back_home_on, %ecx       
    movl back_home_on_len, %edx   
    int $0x80
    jmp fine

posizione6:
        movl $4, %eax               
    movl $1, %ebx               
    leal check_olio, %ecx       
    movl check_olio_len, %edx   
    int $0x80
    jmp fine

posizione7:
    movl $4, %eax               
    movl $1, %ebx               
    leal frecce_direzione, %ecx       
    movl frecce_direzione_len, %edx   
    int $0x80
    jmp fine

posizione8:
    movl $4, %eax               
    movl $1, %ebx               
    leal Reset_pressione_gomme, %ecx       
    movl Reset_pressione_gomme_len, %edx   
    int $0x80
    jmp fine


   fine:
    ret
