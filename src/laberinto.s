.data

startLED: .word 0xf0000090
endLED: .word 0xf0000bb0

#The algorithm leaves a single space as default between path lenghts, that is: 4, 4 paints one pixel, ignores the next and paints the other
# so when you see a -1 it is repeated for k-1 times, where k is the amount of leds we want to skip. Basically,it is how many extra leds you want to skip
# -1 also marks the end of a row
rowPathLen: .word 16, 12,12,12,20,12, 24, -1# Row 1
            .word -1 4,-1,12,4,4,4,4,4,4,-1,-1,4,4,4,4,-1,4,4 -1 # Row 2
            .word 4, -1, -1,24,12,12,4,12,4, 24, -1 # Row 3
            .word 20, -1, -1, 4, -1, -1, 4, -1, -1, 4, -1, 4, -1, -1, -1, -1, 4, 4,-1,4,4,-1 # Row 4
            .word 4,4,-1,12,-1,-1,68, 8, 4, -1 # Row 5
            .word 4, 16,12,4,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,4,-1,4,-1 # Row 6
            .word 4,-1,-1,-1,-1,8,4,32,24,-1,20, -1 # Row 7
            .word 28,-1,4,-1,4,-1,-1,-1,-1,4,4,-1,-1,-1,4,-1,4,-1,-1,-1,-1 # Row 8
            .word -1, -1, -1,-1,-1,4,-1,24,28,28,12,-1 # Row 9
            .word 32,-1,-1,-1,12,-1,-1,-1,-1,-1,-1,4,-1,4,-1,-1,-1,4,4,-1 # Row 10
            .word 4, -1,-1,-1,-1,-1, 20, -1,-1,-1, 28, -1, 24,4, -1 #Row 11
            .word 28,-1,-1,-1,4,-1,12,4,-1,-1,-1,-1,-1,4,-1,-1,-1,-1,-1,4,-1 # Row 12
            .word 4,4,4,16, 16,4,4,24,24,-1 # Row 13
            .word 4,4,4,-1,-1,-1,4,-1,4,4,4,4,4,4,4,-1,4,-1,-1,-1,-1,-1,-1 # Row 14
            .word 4,44, 4,4,4,4,4,4,8,16,-1 # Row 15
            .word 4, 4, 4, 4, -1, -1,4, 36,4,4,4,-1,4,-1,4,-1 # Row 16
            .word 4,4,4,28,-1,4,4,-1,52,-1 # Row 17
            .word 4, 20,-1,4,-1,4,-1,4,4,-1,-1,-1,-1,4,-1,-1,-1,4,4,4,-1 # Row 18
            .word 4,4,4,40,48,4,4,-1 # Row 19
            .word 4,4,4,-1,-1,-1,4,-1,-1,-1,4,-1,4,-1,-1,-1,-1,4,-1,4,4,12, -1 # Row 20
            .word 4,24,4,8,16,32,4,4,4,-1 # Row 21
            .word 4,-1,-1,-1,-1,-1,4,4,4,-1,4,-1,4,4,-1,-1,4,-1,4,4,4,4,-1 # Row 22
            .word 24,52,-1,-1,16,4,12, 0
         

            
# Edges are the literal borders of the maze to be ignored when painting            
edges: .word 0xf0000114, 0xf0000118 # Row 1
       .word 0xf0000118, 0xf00001a0 # Row 2
       .word 0xf00001a4, 0xf000022c # Row 3
       .word 0xf0000230, 0xf00002b8 # Row 4
       .word 0xf00002bc, 0xf0000344 # Row 5
       .word 0xf0000348, 0xf00003d0 # Row 6
       .word 0xf00003d4, 0xf000045c # Row 7
       .word 0xf0000460, 0xf00004e8 # Row 8
       .word 0xf00004ec, 0xf0000574 # Row 9
       .word 0xf0000578, 0xf0000600 # Row 10
       .word 0xf0000604, 0xf000068c # Row 11 
       .word 0xf0000690, 0xf0000718 # Row 12
       .word 0xf000071c, 0xf00007a4 # Row 13
       .word 0xf00007a8, 0xf0000830 # Row 14
       .word 0xf0000834, 0xf00008bc # Row 15
       .word 0xf00008c0, 0xf0000948 # Row 16
       .word 0xf000094c, 0xf00009d4 # Row 17
       .word 0xf00009d8, 0xf0000a60 # Row 18
       .word 0xf0000a64, 0xf0000aec # Row 19
       .word 0xf0000af0, 0xf0000b78 # Row 20
       .word 0xf0000b7c, 0xf0000c04 # Row 21
       .word 0xf0000c08, 0xf0000c90 # Row 22
       .word 0xf0000c94, 0xf0000d1c # Row 23
       
.text
li s2, 0xFFFFFFF # white color to paint paths
la s3, startLED
la s4 rowPathLen
la s5 edges
la s6 endLED

lw t0, 0(s3) #led position pointer
li t6, -1
paintPath:    
    lw t3, 0(s4) #element inside address for path lengths or length indicator 
    add t2, t0, t3 # total path length, the final position to paint
    lw t4, 0(s5) # map edges of current row  
    
    paintloop: 
        beq t3, x0, setPlayer # if we reach the end    
        beq t3, t6, skipWall #if our position indicates a -1 (inner wall) 
        beq t0, t4, skipEdge #if our position is an edge
        beq t0, t2, skipWall
        
        sw s2, 0(t0)
        addi t0, t0, 4
        jal x0 paintloop      
          
        skipWall: #skips the wall to paint path after it
             addi t0, t0, 4
             addi s4, s4, 4
             jal x0, paintPath
             
        skipEdge: # skip the edges
            addi t0, t0, 4
            addi s4, s4, 4
            addi s5, s5, 4
            jal x0, paintPath
            
            
setPlayer:
    lw t0, 0(s3) # go back to initial position
    li t1, 0x44d62c #green
    sw t1, 0(t0)   
    sw t1, 0(t0)
    mv s7, t0
    mv s8, t0
    
setEnd: 
    lw t0, 0(s6) # go back to initial position
    li t1, 0xFF0000 #red
    sw t1, 0(t0)     
                
    jal x0, gameLoop
    
gameLoop:
    li t4, 0xf0000dac      # UP
    lw t5, 0(t4)
    bne t5, x0 moveUp

    li t4, 0xf0000db0      # DOWN
    lw t5, 0(t4)
    bne t5, x0 moveDown

    li t4, 0xf0000db4      # LEFT
    lw t5, 0(t4)
    bne t5, x0 moveLeft

    li t4, 0xf0000db8      # RIGHT
    lw t5, 0(t4)
    bne t5, x0 moveRight

    jal x0, gameLoop


waitRelease:
    li t4, 0xf0000dac      # UP
    lw t5, 0(t4)
    bne t5, x0 waitRelease

    li t4, 0xf0000db0      # DOWN
    lw t5, 0(t4)
    bne t5, x0 waitRelease

    li t4, 0xf0000db4      # LEFT
    lw t5, 0(t4)
    bne t5, x0 waitRelease

    li t4, 0xf0000db8      # RIGHT
    lw t5, 0(t4)
    bne t5,x0 waitRelease

    jal x0, gameLoop

moveRight:
    addi t2, s7, 4
    lw t3, 0(t2)

    li t4, 0xFF0000 # red
    beq t3, t4, wonGame

    add t4, s2, x0
    bne t3, t4, gameLoop

    sw s2, 0(s7)
    add s7, t2, x0

    li t1, 0x44d62c
    sw t1, 0(s7)

    jal x0, waitRelease


moveLeft:
    addi t2, s7, -4
    lw t3, 0(t2)

    li t4, 0xFF0000
    beq t3, t4, wonGame

    add t4, s2, x0
    bne t3, t4, gameLoop

    sw s2, 0(s7)
    add s7, t2, x0

    li t1, 0x44d62c
    sw t1, 0(s7)

    jal x0, waitRelease


moveDown:
    addi t2, s7, 140
    lw t3, 0(t2)

    li t4, 0xFF0000
    beq t3, t4, wonGame

    add t4, s2, x0
    bne t3, t4, gameLoop

    sw s2, 0(s7)
    add s7, t2, x0

    li t1, 0x44d62c
    sw t1, 0(s7)

    jal x0, waitRelease


moveUp:
    addi t2, s7, -140
    lw t3, 0(t2)

    li t4, 0xFF0000
    beq t3, t4, wonGame

    add t4, s2, x0
    bne t3, t4, gameLoop

    sw s2, 0(s7)
    add s7, t2, x0

    li t1, 0x44d62c
    sw t1, 0(s7)

    jal x0, waitRelease
    
wonGame:
    la s1, LED_MATRIX_0_BASE
    add t0, x0, s1
    lw t1, 0(t0)
    li t2, 0x44d62c # green
    li t3, 0xda8
    add t4, t1, t3 #last led
    
    paintWinScreen:
        lw t1, 0(t0)
        beq t1, t4, exitgame
        sw t2, 0(t0)
        addi t0, t0, 4
        jal x0, paintWinScreen

exitgame:
    add x0,x0,x0 # meaningless instruction so that label is valid and program ends