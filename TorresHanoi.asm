#Team members: 
#Ian Ricardo Díaz Meda
#Luis Joaquín Ávalos Guzmán

.text

main:
	addi $s0, $zero, 3 #Number of discs
	#initializing pointers
	addi $s5, $zero,0x1001 #s5 -> origin tower
	sll $s5, $s5, 16
	
	addi $s6, $zero,0x1001 #s6 -> aux tower
	sll $s6, $s6, 16
	add $s6, $s6, 0x0020
	
	addi $s7, $zero,0x1001 #s7 -> dest tower
	sll $s7, $s7, 16
	add $s6, $s6, 0x0040
	
loadDiscs:
	add $t0, $zero, $s0
	loop_LD: 
	sw $t0, 0($s5)
	add $s5, $s5, 4
	addi, $t0, $t0, -1
	bne $t0, $zero, loop_LD
	
	#prepping arguments of Hanoi
	add $a0, $zero, $s0
	add $a1, $zero, $s5
	add $a2, $zero, $s7
	add $a3, $zero, $s6
#Hanoi(int N, Stack org, Stack dest, Stack aux);
#n    => #a0
#org  => #a1
#dest => #a2
#aux  => #a3
Hanoi:
	