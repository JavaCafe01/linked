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
	// stop

	lda x0, list1
	bl printList			// Print OG list

	addi x0, xzr, #10
	putchar x0				// Add new line (\n)

    lda x0, list1
    bl QuickSortWrapper 	// return sorted list in x1
    add x0, x1, XZR
    bl printList     		// entirely sorted

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
	
	LDUR X3, [X0, #8]		// Load address at node
	ADDI X1, X0, #0			// Copy address to return register incase it is the right one
	ADD  X0, XZR, X3     	// Go to next address	
	CBNZ X3, GetLastNode	// Check if it is 0 (NULL)

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
	
	ADDI X2, X0, #0			// Copy address to return register incase it is the right one
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

	ADDI X4, X0, #0			// pivot = first

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
	ADDI X1, X5, #0

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

	LDUR LR, [FP, #-40]		// load the old return address
	LDUR FP, [FP, #-48]		// load the old frame pointer
	ADDI SP, SP, #56		// deallocate stack

	br lr
    

////////////////////////
//                    //
//      QuickSort     //
//                    //
////////////////////////
QuickSort:
	// input:
	//     x0: The address of the first node (corresponding to first) of the list.
	//     x1: The address of the last node (corresponding to last) of the list.
 	// output:
	//     x2: The address of the first node of the list.

	SUBI SP, SP, #72        // allocate stack frame
    STUR FP, [SP, #0]       // save old frame pointer
    ADDI FP, SP, #64        // set new fp
    ///store registers into stack
    STUR X0, [SP, #40]      //save X0 to stack frame
    STUR X1, [SP, #32]      //save X1 to stack
    STUR X2, [SP, #24]      //save X2 to stack
    
    STUR LR, [FP, #-16]     // save the return address
    
    LDUR X0, [X0, #0]   //load value at X0
    LDUR X1, [X1, #0]   //load value at X1
    //first if statement
    SUBS XZR, X1, X0
    B.EQ exitsort
    //first partition call
    BL Partition
    ADD X3, X2, XZR //X3 take return value of partition
    STUR X3, [SP, #52]      //save pivot to stack
    //second if
    SUBS XZR, X3, XZR   //check if pivot is null
    B.EQ jumpto     //if pivot is null
    LDUR X3, [X3, #8]   //pivot not null, get next pivot value
    SUBS XZR, X3,XZR    //check if next value after pivot is null
    B.EQ jumpto
    ADD X0, X3, XZR     //make first node new pivot
    BL QuickSort    //call self
    
    jumpto:
    LDUR X3,[X3, #0]    //get original pivot
    SUBS XZR, X3, XZR   //check pivot null
    B.EQ exitsort
    SUBS XZR, X0, X3    //check if first node is pivot
    B.EQ exitsort
    ADD X1, X3, XZR     //make last node pivot
    BL QuickSort

    exitsort:
            //return first node
    LDUR LR, [FP, #-16]    // load the old return address
    LDUR X2, [SP, #24]      //load XO address
    LDUR X1, [SP, #32]      //load X1 address
    LDUR X0, [SP, #40]      //load X2 first node of list as return address
    LDUR X3, [SP, #52]      //load X3 pivot
    LDUR FP, [SP, #64]    // load the old frame pointer
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
	
    SUBI SP, SP, #72        // allocate stack frame
    STUR FP, [SP, #0]       // save old frame pointer
    ADDI FP, SP, #64        // set new fp
	
    ///store registers into stack
    STUR X0, [SP, #40]      //save X0 to stack frame
    STUR X1, [SP, #32]      //save X1 to stack
    STUR X2, [SP, #24]      //save X2 to stack
    
    BL getLastNode  //has first node as parameter
    ADD X1, X2, XZR //return first node of sorted list
    

    STUR LR, [FP, #-16]     // save the return address
    LDUR LR, [FP, #-16]    // load the old return address
    LDUR X2, [SP, #24]      //load XO address
    LDUR X1, [SP, #32]      //load X1 address
    LDUR X0, [SP, #40]      //load X2 first node of list as return address
    ADDI SP, SP, #72        // deallocate stack

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