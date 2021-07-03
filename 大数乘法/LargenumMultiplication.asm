; 大数乘法/ Zheng Zhihan / Filename:LargenumMultiplication.asm
.386
.model flat, stdcall
option casemap:none

includelib msvcrt.lib

scanf	proto	C:dword, :VARARG
printf	proto	C:dword, :VARARG

.data
	     sfstr  byte	'%s%s', 0
	     pfstr  byte	'%d', 0
	     pfstr2 byte	0ah,0

	     num1   byte	300 dup(?)
	     num2   byte	300 dup(?)
	     ans    byte	600 dup(0)
	len1 dd     ?
	len2 dd     ?

.code
	start:

	      invoke scanf, offset sfstr, offset num1, offset num2


	; 第一步，读出num的长度并记录在len，同时将ASCII码转换为数字
	      MOV    ESI, offset num1
	      MOV    EAX, 0
	      MOV    DX, 299
	L1:   
	      MOV    BL, [ESI+EAX]
	      CMP    BL, 0
	      JZ     L2
	      SUB    BL, '0'
	      MOV    [ESI+EAX], BL
	      INC    EAX
	      LOOP   L1
	L2:   
	      MOV    len1, EAX

	      MOV    ESI, offset num2
	      mov    EAX, 0
	      MOV    DX, 299
	L3:   
	      MOV    BL, [ESI+EAX]
	      CMP    BL, 0
	      JZ     L4
	      SUB    BL, '0'
	      MOV    [ESI+EAX], BL
	      INC    EAX
	      LOOP   L3
	L4:   
	      MOV    len2, EAX


	; 第二步，模拟手算法计算
	      MOV    ESI, len2
	M1:   

	      MOV    EBX, len2
	      SUB    EBX, ESI
	      DEC    ESI

	; 此时乘数为 num2[ESI], 第EBX次循环
	;PUSH EBX
	;invoke	printf, offset pfstr, EBX


	      MOV    EDI, len1
	S2:   
	      MOV    AL, num1[EDI-1]
	      MUL    num2[ESI]

	      MOV    ECX, len1
	      SUB    ECX, EDI

	S4:   
	      ADD    AL, ans[EBX+ECX]
	      MOV    ans[EBX+ECX], AL
	; 结果除以十

	      CMP    AL, 10
	      JB     S3
	      MOV    DL, 10
	; 由于除法是十六位，因此要先保存AH
	      PUSH   AX
	      XOR    AH,AH
	      IDIV   DL
	      POP    DX
	      MOV    DH, AH

	      MOV    ans[EBX+ECX], AH

	      CMP    AL, 0
	      JZ     S3

	; 需要进位
	      INC    ECX
	      JMP    S4

	S3:   
	; 如果不需要进位

	      DEC    EDI
	      CMP    EDI, 0
	      JNZ    S2

	      CMP    ESI, 0
	      JNZ    M1


	; 第三步，输出结果
	      MOV    ECX, 600

	E1:   
	      CMP    ans[ECX-1], 0
	      JNZ    E3
	      LOOP   E1

	E3:   
	      push   ECX
	      invoke printf, offset pfstr, ans[ECX-1]
	      POP    ECX
	      LOOP   E3

ret
end start
