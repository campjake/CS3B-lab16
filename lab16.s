// Style Sheet
// Programmer   : Jacob Campbell
// Lab #        : 16
// Purpose      : IO Read
// Date         : 4/6/2023

	.EQU	O_RDONLY,		0		// READ ONLY
	.EQU	O_WRONLY,		1		// WRITE ONLY
	.EQU	O_CREAT,		0100	// Create file
	.EQU	RW, 	02		// READ/WRITE
	.EQU	T_RW,	01002	// Truncate READ/WRITE
	.EQU	C_W,	0101	// Create file if it dne
	.EQU	READ, 	63		// read
	.EQU	CLOSE,	57		// Close the file
// FILE PERMISSIONS
//	OWNER	GROUP	OTHER
//	RWE		RWE		RWE
	.EQU	RW__, 0600
	.EQU	AT_FDCWD, -100 	// LOCAL DIRECTORY

	.data
szFile:		.asciz	"output.txt"
iStrLen:	.byte	37			// Cat in the hat.\nGreen eggs and ham."
fileBuf:	.skip	512			// File buffer	
iFD:		.quad	0			// ?
szEOF:		.asciz	"Reached the End of File"
szErr:		.asciz	"FILE READ ERROR\n"
chLF:		.byte	0xA			// Line feed

	.global _start
	.text
_start:
// Open the file (same as lab15)
	MOV		X0, #AT_FDCWD	// *X0 = local directory, File Descriptor will be returned
	MOV		X8, #56			// OPENAT
	LDR		X1,=szFile		// Pointer to C-String: Use File Name

	MOV		X2, #O_RDONLY	// Read only
	MOV		X3, RW__		// Permission
	SVC 	0				// Service Call 0 (iosetup)

// Load file input to buffer with read() syscall
	MOV	X8, #READ			// *X8 = READ (63)
	LDR	X1,=fileBuf			// *X1 = fileBuf
	LDR	X2,=iStrLen			// *X1 = 37
	LDR	X2, [X2]			// X1 = 37
	svc 0					// Service Call 0 (iosetup)

	MOV	X8, #CLOSE			// Close the file
	SVC	0					// Service call 0 (iosetup)

// Output to the terminal
	MOV	X0, X1				// X0 = fileBuf
	BL	putstring			// Print contents to terminal
	LDR	X0,=chLF			// Load LF
	BL	putch				// Print LF

// Call kernel to end program
	MOV	X0, #0				// Return code 0 (iosetup)
	MOV	X8, #93				// Service command 93 (exit)
	SVC	0					// Service code 0 (iosetup)
	.end					// End of program
