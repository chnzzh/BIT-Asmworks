;PROG01 / CUI / Filename:Lab1_CUI.asm
.386
.model	flat, stdcall
option	casemap:none

includelib	msvcrt.lib
printf	PROTO	C:ptr sbyte,:VARARG

.data
szFmtStr	BYTE	"Class:%08d Name:%s ID:%d",0ah, 0
MyClass		DWORD	07111806
MyName		BYTE	"郑之涵", 0
MyID		DWORD	112018, 1120181414

.code
start:
		MOV		EAX, offset MyName				; 直接寻址
		
		MOV		ESI, offset MyClass
		MOV		EBX, [ESI]						; 寄存器间接寻址

		MOV		EDX, offset MyID
		MOV		ESI, 4
		MOV		ECX, [EDX][ESI]					; 基址变址寻址

		invoke	printf, offset szFmtStr, EBX, EAX, ECX
		ret
end		start