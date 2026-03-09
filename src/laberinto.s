.data

startLED: .word 0xf0000090

# -1 appears when we ignore or skip more than one led, it tells the program that in that point no path should be created
#The algorithm leaves a single space as default between path lenghts, that is: 4, 4 paints one pixel, ignores the next and paints the other
rowPathLen: .word 16, 12,12,12,20,12, 24, -1# Row 1
            .word -1 4,-1,12,4,4,4,4,4,4,-1,-1,4,4,4,4,-1,4,4 -1 # Row 2
            .word 4, -1, -1,24,12,12,4,12,4, 24, -1 # Row 3
            .word 20, -1, -1, 4, -1, -1, 4, -1, -1, 4, -1, 4, -1, -1, -1, -1, 4, 4,-1,4,4,0
         

            
# Edges are the literal borders of the maze or the inner walls to be ignored when painting            
edges: .word 0xf0000114, 0xf0000118 # Row 1
       .word 0xf0000118, 0xf00001a0 # Row 2
       .word 0xf00001a4, 0xf000022c # Row 3
       .word 0xf0000230, 0xf00002b8 # Row 4
    

.text
li s2, 0xFFFFFFF # white color to paint paths
la s3, startLED
la s4 rowPathLen
la s5 edges

lw t0, 0(s3) #led position pointer
li t6, -1
paintPath:    
    lw t3, 0(s4) #element inside address for path lengths or length indicator 
    add t2, t0, t3 # total path length, the final position to paint
    lw t4, 0(s5) # map edges of current row  
    
    paintloop: 
        beq t3, x0, stopPaint # if we reach the end    
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
            
            
    stopPaint:
        jal x0, stopPaint
                
