////////////////////////
//                    //
// Project Submission //
//                    //
////////////////////////

// Partner1: Gokul Swaminathan, A16127419
// Partner2: Zhan Ouyang, A16686044

////////////////////////
//                    //
//       main         //
//                    //
////////////////////////
   
    // // Code to test partition
    // lda x0, list1
    // addi x1, xzr, #16
    // bl Partition

    lda x0, list1
    bl printList            // Print OG list

    addi x0, xzr, #10
    putchar x0              // Add new line (\n)

    lda x0, list1
    bl QuickSortWrapper     // return sorted list in x1
    add x0, x1, XZR
    bl printList            // entirely sorted

    stop


////////////////////////
//                    //
//   SwapNodeValue    //
//                    //
////////////////////////
SwapNodeValue:
    // input:
    //	   x0: The address of (pointer to) one node (corresponding to n1) on the linked list.
    //	   x1: The address of (pointer to) another node (corresponding to n2) on the linked list.
    
    // Load the two node values
    LDUR X3, [X0, #0]
    LDUR X4, [X1, #0]

    // Swap and store the two node values
    STUR X4, [X0, #0]
    STUR X3, [X1, #0]

    br lr 
    
////////////////////////
//                    //
//   GetLastNode      //
//                    //
////////////////////////
GetLastNode:
    // input:
    //     x0: The address of (pointer to) a node (corresponding to head) on the linked list.
    // output:
    //     x1: The address of the last node of the linked list.

    SUBI SP, SP, #32		// allocate stack frame
    STUR FP, [SP, #0]		// save old frame pointer
    ADDI FP, SP, #24		// set new fp
    STUR LR, [FP, #-16]		// save the return address

    LDUR X3, [X0, #8]		// Load head->next

    SUBIS XZR, X0, #0
    B.EQ returnHead
    SUBIS XZR, X3, #0
    B.EQ returnHead

    LDUR X0, [X0, #8]
    BL GetLastNode
    B doneLastNode

    returnHead:
    ADDI X1, X0, #0

    doneLastNode:
    LDUR LR, [FP, #-16]		// load the old return address
    LDUR FP, [FP, #-24]		// load the old frame pointer
    ADDI SP, SP, #32		// deallocate stack

    br lr


////////////////////////
//                    //
//    GetNodeWithVal  //
//                    //
////////////////////////
GetNodeWithVal:
    // input:
    //     x0: The address of the node (corresponding to cur) of the input list.
    //     x1: The value (corresponding to val) of the node it’s looking for.
    // output:
    //     x2: The address of (pointer to) the node with the given value(x1).

    SUBI SP, SP, #32		// allocate stack frame
    STUR FP, [SP, #0]		// save old frame pointer
    ADDI FP, SP, #24		// set new fp
    STUR LR, [FP, #-16]		// save the return address

    ADDI X2, X0, #0	        // Copy address to return register incase it is the right one
    SUBIS XZR, X2, #0
    B.EQ exitloopnode

    LDUR X3, [X0, #8]		// Load address at node
    LDUR X4, [X0, #0]		// Value at node
    ADD  X0, XZR, X3     	// Go to next address	
    SUBS XZR, X1, X4		// Check if it matches the value 
    B.eq exitloopnode

    // NOTE USE BL WHEN DOING RECURSION

    BL GetNodeWithVal     	// If it does not, recurse again

    exitloopnode:

    LDUR LR, [FP, #-16]		// load the old return address
    LDUR FP, [SP, #0]		// load the old frame pointer
    ADDI SP, SP, #32		// deallocate stack

    br lr

    
////////////////////////
//                    //
//     Partition      //
//                    //
////////////////////////

// x5 -> last
// x4 -> pivot
// x3 -> cur
Partition:
    // input:
    //     x0: The address of the first node (corresponding to first) of the linked list.
    //     x1: The value (corresponding to lastVal) of the last node of the linked list.
    // output:
    //     x2: The address of the first node on the left of the node with the given last node value.

    SUBI SP, SP, #56 		// allocate stack frame
    STUR FP, [SP, #0]		// save old frame pointer
    ADDI FP, SP, #48		// set new fp
    STUR LR, [FP, #-40]		// save the return address

    ADDI X4, X0, #0
    ADDI X3, X0, #0

    // SAVE ALL REGISTERS THAT ARE NOT PARAMETERS INTO THE STACK BEFORE EVERY BL

    STUR X0, [FP, #-24]
    STUR X1, [FP, #-16]
    STUR X3, [FP, #-8]
    STUR X4, [FP, #0]

    BL GetNodeWithVal
    ADDI X5, X2, #0

    LDUR X0, [FP, #-24]
    LDUR X1, [FP, #-16]
    LDUR X3, [FP, #-8]
    LDUR X4, [FP, #0]

    while:
    SUBIS XZR, X3, #0
    B.EQ exitloop

    SUBS XZR, X3, X5
    B.EQ exitloop

    // in if statement

    LDUR X6, [X3, #0] 		// cur -> data
    LDUR X7, [X5, #0] 		// last -> data

    SUBS XZR, X6, X7
    B.GE exitif

    ADDI X4, X0, #0	        // pivot = first

    STUR X1, [FP, #-24] 
    STUR X4, [FP, #-16]
    STUR X5, [FP, #-8]

    ADDI X1, X3, #0
    BL SwapNodeValue
    ADDI X3, X1, #0

    LDUR X1, [FP, #-24]
    LDUR X4, [FP, #-16]
    LDUR X5, [FP, #-8]

    LDUR X0, [X0, #8]

    exitif:
    LDUR X3, [X3, #8]

    B while

    exitloop:

    STUR X1, [FP, #-24] 
    STUR X3, [FP, #-16]
    STUR X4, [FP, #-8]
    STUR X2, [FP, #0]

    ADDI X1, X5, #0 
    BL SwapNodeValue
    ADDI X5, X1, #0

    LDUR X1, [FP, #-24]
    LDUR X3, [FP, #-16]
    LDUR X4, [FP, #-8] 
    LDUR X2, [FP, #0]

    ADDI X2, X4, #0

    LDUR LR, [FP, #-40]	    // load the old return address
    LDUR FP, [FP, #-48]	    // load the old frame pointer
    ADDI SP, SP, #56        // deallocate stack

    br lr
    

////////////////////////
//                    //
//      QuickSort     //
//                    //
////////////////////////

// x3 -> pivot
QuickSort:
    // input:
    //     x0: The address of the first node (corresponding to first) of the list.
    //     x1: The address of the last node (corresponding to last) of the list.
    // output:
    //     x2: The address of the first node of the list.

    SUBI SP, SP, #72        // allocate stack frame
    STUR FP, [SP, #0]       // save old frame pointer
    ADDI FP, SP, #64        // set new fp
    STUR LR, [FP, #-56]     // save the return address


    // if(first == last)
    SUBS XZR, X1, X0
    B.EQ exitsort

    // save registers before branching
    STUR X0, [FP, #-48]
    STUR X1, [FP, #-40]

    LDUR X1, [X1, #0]
    BL Partition
    ADDI X3, X2, #0

    LDUR X0, [FP, #-48]
    LDUR X1, [FP, #-40]

    // if(pivot != NULL && pivot->next != NULL)
    SUBIS XZR, X3, #0
    B.EQ skiprecursion1
    LDUR X4, [X3, #8]
    SUBIS XZR, X4, #0
    B.EQ skiprecursion1


    STUR X0, [FP, #-48]
    STUR X3, [FP, #-32]

    LDUR X0, [X3, #8]
    // X1 is already last
    BL QuickSort

    LDUR X0, [FP, #-48]
    LDUR X3, [FP, #-32]

    skiprecursion1:

     // if(pivot != NULL && first != pivot)
    SUBIS XZR, X3, #0
    B.EQ exitsort
    SUBS XZR, X0, X3
    B.EQ exitsort

    STUR X0, [FP, #-48]

    // X0 is already first
    ADDI X1, X3, #0
    BL QuickSort

    LDUR X0, [FP, #-48]

    exitsort:

    // return first
    ADDI X2, X0, #0
    
    // dealocate stack
    LDUR LR, [FP, #-56]     // load the old return address
    LDUR FP, [SP, #0]       // load the old frame pointer
    ADDI SP, SP, #72        // deallocate stack

    br lr 

////////////////////////
//                    //
//  QuickSortWrapper  //
//                    //
////////////////////////

QuickSortWrapper:
    // input:
    //     x0: The address of the first node (corresponding to first) of the list.
    // output:
    //     x1: The address of the first node of the list.

    SUBI SP, SP, #32		// allocate stack frame
    STUR FP, [SP, #0]		// save old frame pointer
    ADDI FP, SP, #24		// set new fp
    STUR LR, [FP, #-16]		// save the return address

    
    STUR X0, [FP, #-8]
    BL GetLastNode
    LDUR X0, [FP, #-8]

    // X0 is already the first
    // X1 is already the last
    BL QuickSort
    ADDI X1, X2, #0

    // Deallocate stack
    LDUR LR, [FP, #-16]		// load the old return address
    LDUR FP, [SP, #0]		// load the old frame pointer
    ADDI SP, SP, #32		// deallocate stack

    br lr 
    
////////////////////////
//                    //
//     printList      //
//                    //
////////////////////////
printList:
    // x0: node address
    addi x3, xzr, #45
    addi x4, xzr, #62
    addi x5, xzr, #88
    addi x6, xzr, #10
printList_loop:
    subis xzr, x0, #0
    b.eq printList_loopEnd
    ldur x1, [x0, #0]
    putint x1
    ldur x0, [x0, #8]
    putchar x3
    putchar x4
    b printList_loop
printList_loopEnd:    
    putchar x5
    putchar x6
    br lr
