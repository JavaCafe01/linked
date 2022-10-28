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

    // You can modify main function to test your own test cases.
	// The folloiwng prints unsorted list, call sort function, and print the sorted list again.
    lda x0, list1      // display original list
    bl printList

	addi x0, xzr, #10  // \n new line
	putchar x0

    lda x0, list1
    bl QuickSortWrapper  // return sorted list in x1
    add x0, x1, XZR
    bl printList         // entirely sorted

	stop


////////////////////////
//                    //
//   SwapNodeValue    //
//                    //
////////////////////////
SwapNodeValue:
	// input:
    	//   x0: The address of (pointer to) one node (corresponding to n1) on the linked list.
      //   x1: The address of (pointer to) another node (corresponding to n2) on the linked list.
    
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
	STUR LR, [FP, #-16]	// save the return address
	
	
	LDUR X1, [X0, #8]		// Load address at node
	STUR X1, [X0, #8]		// Set it as the return value
	CBNZ X1, GetLastNode

	LDUR LR, [FP, #-16]	// load the old return address
	LDUR FP, [FP, #-24]	// load the old frame pointer
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
	
    // INSERT YOUR CODE HERE
	br lr

    
////////////////////////
//                    //
//     Partition      //
//                    //
////////////////////////
Partition:
	// input:
	//     x0: The address of the first node (corresponding to first) of the linked list.
	//     x1: The value (corresponding to lastVal) of the last node of the linked list.
 	// output:
	//     x2: The address of the first node on the left of the node with the given last node value.

	// INSERT YOUR CODE HERE
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

	// INSERT YOUR CODE HERE
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
	
    // INSERT YOUR CODE HERE
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