#Team members: 
#Ian Ricardo Díaz Meda
#Luis Joaquín Ávalos Guzmán

.text

main:
	addi $s0, $zero, 3#Number of discs
	#initializing pointers
	addi $s5, $zero,0x1001 #s5 -> origin tower
	sll $s5, $s5, 16
	
	addi $s6, $zero,0x1001 #s6 -> dist tower
	sll $s6, $s6, 16
	add $s6, $s6, 0x0020
	
	addi $s7, $zero,0x1001 #s7 -> aux tower
	sll $s7, $s7, 16
	add $s7, $s7, 0x0040
	
loadDiscs:
	add $t0, $zero, $s0
	loop_LD: 
	sw $t0, 0($s5)
	add $s5, $s5, 4
	addi, $t0, $t0, -1
	bne $t0, $zero, loop_LD
	
	#contadores de discos, servirán para manejar apuntadores
	add $s2, $zero, $s0   #Orig Tower count -> s5
	add $s3, $zero, $zero #Dest Tower count -> s6
	add $s4, $zero, $zero #Aux  Tower count -> s7
	########################################################
	
	add $s5, $s5, -4 #Para que no apunte a un elemento vacio 
	
	#prepping arguments of Hanoi
	add $a0, $zero, $s0 
	add $a1, $zero, $s5 
	add $a2, $zero, $s7
	add $a3, $zero, $s6
	jal Hanoi
	j exit
#Hanoi(int n, Stack org, Stack dest, Stack aux);
#n    => #a0
#org  => #a1
#dest => #a2
#aux  => #a3
Hanoi:
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $t8, 4($sp)
	sw $ra, 8($sp)
	beq $a0, 1, baseCase #if (n == 1) { baseCase}
	#casoInductivo:
	
	#else {
	#Hanoi ( n - 1, org, dest, aux)
	#Move disc from org to dest
	#Hanoi (n - 1, aux, dest, org)
	#}

	addi $a0,$a0,-1 # n = n - 1
	sw $a0, 0($sp)
	
	#en este primer paso del caso en esta llamada el origen siempre es el mismo pero cambios en la torres aux y dest
	#en cada llamada aux será dest y dest será aux variando en los casos en que llame esta función
	#n => #a0
	#Orig Tower count -> s2 (De s5)
	#Dest Tower count -> s3 (De s6)
	#Aux  Tower count -> s4 (De s7)

	#Cambiando apuntadores de pilas
	add $t7,$zero,$a2 # t7  = destino
	add $a2,$zero,$a3 #dest = aux
	add $a3,$zero,$t7 #aux  = destino
	#Cambiando contadores de pilas
	#add $t7, $zero, $s3 #t7 = contador de pila destino
	#add $s3, $zero, $s4 #s2(destino) = contador de pila aux
	#add $s4, $zero, $t7 #s4(aux) = contador de pila destino
	#Llamando a Hanoi(n-1,org,aux,dest)
	jal Hanoi
	lw $a0, 0($sp)
	lw $t8, 4($sp)
	lw $ra, 8($sp)
	
	add $t7, $zero, $a2 #ty = aux
	add $a2, $zero, $a3 #aux = dest
	add $a3, $zero, $t7 #dest = aux
	
	#add $t7, $zero, $s3 #t7 = contador de pila aux
	#add $s3, $zero, $s4 #s2(aux) = contador de pila destino
	#add $s4, $zero, $t7 #s4(dest) = contador de pila aux
	#dest.push(o.pop());
	lw $t8,0($a1) # $t8 = o.pop();
	sw $zero,0($a1)
	addi $a1,$a1,-4
	bne $s2, 1, afterOrigFix
	addi $a1, $a1, 4
	
	afterOrigFix:
	add $s2, $s2, -1
	sw $t8,0($a2)#d.push($t8);
	addi $a2,$a2,4
	bne $s3, 0, afterDestFix #Si la pila de destino esta vacia...
	addi $a2,$a2,-4
	
	afterDestFix:
	add $s3, $s3, 1
	sw $a0, 0($sp)
	sw $t8, 4($sp)
	sw $ra, 8($sp)
	#en este paso del caso en esta llamada el dest siempre es el mismo pero habrá cambios en las torres aux y orig
	#en cada llamada aux será orig y origin será aux variando en los casos en que llame esta función
	add $t7,$zero,$a1 #t7 = org
	add $a1,$zero,$a3 #org = aux
	add $a3,$zero,$t7 #aux = org
	
	#add $t7, $zero, $s2 #t7 = contador de pila orig
	#add $s2, $zero, $s4 #s2(orig) = contador de pila aux
	#add $s4, $zero, $t7 #s4(aux) = contador de pila org
	addi $a0,$a0,-1 #n-1
	jal Hanoi #hanoi(n-1,aux,dest,origin)
	add $t7, $zero, $a1 #ty = aux
	add $a1, $zero, $a3 #aux = dest
	add $a3, $zero, $t7 #dest = aux
	
	#add $t7, $zero, $s2 #t7 = contador de pila orig
	#add $s2, $zero, $s4 #s2(orig) = contador de pila aux
	#add $s4, $zero, $t7 #s4(aux) = contador de pila org
	
	j endHanoi

	baseCase:
	#Mov disc from orig to dest
	lw $t8,0($a1) # $t8 = o.pop();
	sw $zero,0($a1)
	addi $a1,$a1,-4
	bne $s2, 1, afterOrigFix2
	addi $a1, $a1, 4
	
	afterOrigFix2:
	add $s2, $s2, -1
	sw $t8,0($a2)#d.push($t8);
	addi $a2,$a2,4
	bne $s3, 0, afterDestFix2 #Si la pila de destino esta vacia...
	addi $a2,$a2,-4
	
	afterDestFix2:
	add $s3, $s3, 1
	endHanoi:
	#terminando Hanoi
	lw $a0, 0($sp)
	lw $t8, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra	
	

exit:
	
