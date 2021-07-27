;PROG02 / GUI / Filename:Lab1_GUI.asm
.386
.model	flat, stdcall
option	casemap:none
MessageBoxA	PROTO :dword, :dword, :dword, :dword
MessageBox	equ <MessageBoxA>
includelib	user32.lib
NULL	equ		0
MB_OK	equ		0
.stack	4096

.data
szTitle	BYTE	"Hello!",0
szMsg	BYTE	"Class:07111806 Name:郑之涵 ID:1120181414", 0

.code
start:
		MOV		AL, szTitle
		invoke	MessageBox,
				NULL,
				offset szMsg,
				offset	szTitle,
				MB_OK

		ret
end		start