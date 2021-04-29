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
MyID		DWORD	1120181414

.code
start:
		MOV		EAX, 1120181414			; 直接寻址
		MOV		ESI, offset MyClass		; 直接寻址
		MOV		EBX, [ESI]				; 寄存器间接寻址
		MOV		ECX, EBX				; 寄存器寻址
		invoke	printf, offset szFmtStr, ECX, offset MyName, EAX
		ret
end		start