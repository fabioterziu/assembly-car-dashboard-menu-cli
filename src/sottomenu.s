.section .data             

#OPZIONI MENU
    ON:
        .ascii "ON\n"

    ON_len:
        .long . - ON

    OFF:
        .ascii "OFF\n"

    OFF_len:
        .long . - OFF


    pressione_gomme:
        .ascii "Pressione gomme resettata\n"
    pressione_gomme_len:
        .long . - pressione_gomme

    valore2:
        .ascii "numero di frecce attuale: 2\n"
    valore2_len:
        .long . - valore2

     valore3:
        .ascii "numero di frecce attuale: 3\n"
    valore3_len:
        .long . - valore3

    valore4:
        .ascii "numero di frecce attuale: 4\n"
    valore4_len:
        .long . - valore4

    valore5:
        .ascii "numero di frecce attuale: 5\n"
    valore5_len:
        .long . - valore5
       

    


.section .text

.global print_sottomenu

.type print_sottomenu, @function

print_sottomenu:
    movl 4(%esp), %eax          #recupero posizione menu

        cmpl $4, (%eax)             
    je  bloccoporte     #

        cmpl $5, (%eax)             
    je  backhome     #
    cmpl $7, (%eax)             
    je  frecce_direzionali     

    cmpl $8, (%eax)             
    je reset_gomme     
    



    bloccoporte:
    movl 8(%esp), %eax         # 
    cmpl $1 , (%eax)
    je bloccoporte_on
    movl $4, %eax               
    movl $1, %ebx               
    leal OFF, %ecx      
    movl OFF_len, %edx  
    int $0x80
    jmp end
    
    bloccoporte_on:
    movl $4, %eax               
    movl $1, %ebx               
    leal ON, %ecx      
    movl ON_len, %edx  
    int $0x80
    jmp end


    backhome:
    movl 12(%esp), %eax         
    cmpl $1 , (%eax)
    je backhome_on
    movl $4, %eax               
    movl $1, %ebx               
    leal OFF, %ecx      
    movl OFF_len, %edx  
    int $0x80
    jmp end


    backhome_on:
    movl $4, %eax               
    movl $1, %ebx               
    leal ON, %ecx      
    movl ON_len, %edx  
    int $0x80
    jmp end


    frecce_direzionali:
    movl 16(%esp), %eax           
    cmpb $50 , (%eax)
    je freccia_2
    cmpb $51 , (%eax)
    je freccia_3
    cmpb $52 , (%eax)
    je freccia_4
    cmpb $53 , (%eax)
    je freccia_5



    freccia_2:
    movl $4, %eax               
    movl $1, %ebx               
    leal valore2, %ecx      
    movl valore2_len, %edx  
    int $0x80
    jmp end
    freccia_3:
    movl $4, %eax               
    movl $1, %ebx               
    leal valore3, %ecx      
    movl valore3_len, %edx  
    int $0x80
    jmp end
    freccia_4:
    movl $4, %eax               
    movl $1, %ebx               
    leal valore4, %ecx      
    movl valore4_len, %edx  
    int $0x80
    jmp end
    freccia_5:
    movl $4, %eax               
    movl $1, %ebx               
    leal valore5, %ecx      
    movl valore5_len, %edx  
    int $0x80
    jmp end


    reset_gomme:
    movl $4, %eax
    movl $1, %ebx
    leal pressione_gomme, %ecx        
    movl pressione_gomme_len, %edx
    int $0x80

    jmp end

   end:
    ret




