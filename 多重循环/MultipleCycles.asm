; 多重循环/ Zheng Zhihan / Filename:MultipleCycles.asm
.386
.model flat, stdcall
option casemap:none

includelib msvcrt.lib

printf	proto	C:dword, :VARARG

.data
	     pfstr  byte	'%2d/', 0
	     pfstr2 byte	0ah,0

.code
MAIN PROC
	     LOCAL  Var_i	:DWORD
	     LOCAL  Var_j	:DWORD
	     LOCAL  Var_k	:DWORD
	     LOCAL  Var_l	:DWORD

	; 第一层循环
	     MOV    Var_i, 0
	     JMP    C1
	S1:  
	     MOV    EAX, Var_i
	     INC    EAX
	     MOV    Var_i, EAX
	C1:  
	     CMP    Var_i, 10
	     JGE    E

	; 第二层循环
	     MOV    Var_j, 0
	     JMP    C2
	S2:  
	     MOV    EAX, Var_j
	     INC    EAX
	     MOV    Var_j, EAX
	C2:  
	     CMP    Var_j, 10
	     JGE    E1

	; 第三层循环
	     MOV    Var_k, 0
	     JMP    C3
	S3:  
	     MOV    EAX, Var_k
	     INC    EAX
	     MOV    Var_k, EAX
	C3:  
	     CMP    Var_k, 10
	     JGE    E2

	; 第四层循环
	     MOV    Var_l, 0
	     JMP    C4
	S4:  
	     MOV    EAX, Var_l
	     INC    EAX
	     MOV    Var_l, EAX
	C4:  
	     CMP    Var_l, 10
	     JGE    E3

	; 循环最内层
	     MOV    EAX, Var_i
	     IMUL   EAX, Var_j
	     ADD    EAX, Var_k
	     SUB    EAX, Var_l

	     invoke printf, offset pfstr, EAX

	E4:  
	     JMP    S4
	E3:  
	     invoke printf, offset pfstr2
	     JMP    S3
	E2:  
	     invoke printf, offset pfstr2
	     JMP    S2
	E1:  
	     invoke printf, offset pfstr2
	     JMP    S1

	E:   
	     XOR    EAX, EAX
	     RET
MAIN	ENDP
end	MAIN
