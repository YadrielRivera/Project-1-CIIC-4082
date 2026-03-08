.data

startLED: .word 0xf0000090

# -1 appears when we ignore or skip a led to be painted
rowPathLen: .word 16, 12, 12, 12, 20, 12, 24, -1 # Row 1
            .word 4,-1, -1,12,4,4,4,4,4,4, -1, -1, -1, 4, 4, 4, 4, -1, -1,4,-1 #Row 2
            .word 4, 24, 12, 12, 4, 12, 4, 24, 0 # Row 3
            
# Edges are the literal borders of the maze or the inner walls to be ignored when painting            
edges: .word 0xf0000114, 0xf0000118 # Row 1
       .word 0xf0000120, 0xf0000124, 0xf0000134,0xf000013c, 0xf0000144,0xf000014c,0xf0000154, 0xf000015c, 0xf0000164,0xf0000168,0xf000016c,0xf0000174,0xf000017c, 0xf0000184, 0xf000018c, 0xf0000190, 0xf0000198, 0xf00001a0 # Row 2
       .word 0xf00001a4,0xf00001ac, 0xf00001b0,0xf00001b4, 0xf000022c #Row 3

.text
la s1, LED_MATRIX_0_BASE
la s2, 0xFFFFFFF # white color to paint paths
la s3, startLED
la s4 rowPathLen
la s5 edges

lw t0, 0(s3) #led position
add t3, x0, s4 #address for path length 

paintPath:    

    lw t1, 0(t3) # relative pos of wall 
    lw t4, 0(s5)
    add t2, t0, t1 # absolute pos of wall 
  
    
    paintloop: 
        beq t0, t4, skip     
        beq t1, x0, stopPaint 
        beq t4, x0, stopPaint
        beq t0, t2, nextWall #break when we find wall        
        sw s2, 0(t0)
        addi t0, t0, 4
        jal x0 paintloop      
          
        nextWall: #skips the wall to paint path after it
            addi t0, t0, 4
            addi t3,t3, 4
            jal x0, paintPath  
             
        skip: # skip the edges
            addi t0, t0, 4
            addi t3,t3, 4
            addi s5,s5,4
            jal x0, paintPath
            
    stopPaint:
        jal x0, stopPaint
                
