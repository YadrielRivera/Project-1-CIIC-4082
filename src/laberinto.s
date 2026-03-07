.data

startLED: .word 0xf0000090
rowPathLen: .word 28, 20, 20, 12, 36, 8, 8, 0
edges: .word 0xf0000114, 0xf0000118

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
                
