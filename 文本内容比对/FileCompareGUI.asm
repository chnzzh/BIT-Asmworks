; 文本内容比对/ Zheng Zhihan / Filename:FileCompareGUI.asm
.386
.model flat,stdcall
option casemap:none

include windows.inc
include user32.inc
include kernel32.inc

includelib user32.lib
includelib kernel32.lib
includelib msvcrt.lib

fopen	proto c:dword,:dword
fgets	proto c:dword,:dword,:dword
fclose  proto c:dword
strcat  proto c:dword,:dword
_itoa	proto c:dword,:dword,:dword
MessageBoxA proto :DWORD, :DWORD, :DWORD, :DWORD 

WinMain proto :DWORD,:DWORD,:DWORD,:DWORD

.data

BUF_SIZE equ 1024

ClassName db "文本比对",0        ; the name of our window class
AppName db "文本比对 byZZH",0        ; the name of our window

filepath1	db	1024 dup(0)
filepath2	db	1024 dup(0)

mode	db	'rb', 0
cline	dd	0
clinestr    dd  10 dup(0)
flag_match db	0

szText db "请输入需要比较的文件路径！",0


titleAlert	db	"警告", 0
nofileinfo	db	"文件不存在", 0
nomatchhead db  0ah, "行数：", 0
msgOut db 1024 dup(0)
noerrinfo db	"恭喜，文本比对相同!", 0
notetitle db    "提示", 0

showButton db "开始检查",0
button db 'button',0
edit db 'edit',0
showEdit1 db '1.txt',0
showEdit2 db '2.txt',0

.data?
hInstance HINSTANCE ?        ; Instance handle of our program
CommandLine LPSTR ?

fp1	dd	?
fp2	dd	?
buf1	db	1024 dup(?)
buf2	db	1024 dup(?)

.code
start:
	invoke GetModuleHandle, NULL
    mov    hInstance,eax
    invoke GetCommandLine
    mov CommandLine,eax
    invoke WinMain, hInstance,NULL,CommandLine, SW_SHOWDEFAULT
    invoke ExitProcess,eax

WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD
	local wc:WNDCLASSEX
	local msg:MSG
	LOCAL hwnd:HWND

	mov   wc.cbSize,SIZEOF WNDCLASSEX
    mov   wc.style, CS_HREDRAW or CS_VREDRAW
    mov   wc.lpfnWndProc, OFFSET WndProc
    mov   wc.cbClsExtra,NULL
    mov   wc.cbWndExtra,NULL
    push  hInstance
    pop   wc.hInstance
    mov   wc.hbrBackground,COLOR_WINDOW+1
    mov   wc.lpszMenuName,NULL
    mov   wc.lpszClassName,OFFSET ClassName
    invoke LoadIcon,NULL,IDI_APPLICATION
    mov   wc.hIcon,eax
    mov   wc.hIconSm,eax
    invoke LoadCursor,NULL,IDC_ARROW
    mov   wc.hCursor,eax
    invoke RegisterClassEx, addr wc                       ; register our window class

	 invoke CreateWindowEx,NULL,\
                ADDR ClassName,\
                ADDR AppName,\
                WS_OVERLAPPEDWINDOW,\
                100,100,550,200,\
                NULL,\
                NULL,\
                hInst,\
                NULL
	
	mov   hwnd,eax
    invoke ShowWindow, hwnd,CmdShow               ; display our window on desktop
    invoke UpdateWindow, hwnd                                 ; refresh the client area

	.WHILE TRUE                                                         ; Enter message loop
                invoke GetMessage, ADDR msg,NULL,0,0
                .BREAK .IF (!eax)
                invoke TranslateMessage, ADDR msg
                invoke DispatchMessage, ADDR msg
   .ENDW
	mov     eax,msg.wParam
	ret
WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	local stPs:PAINTSTRUCT
	local stRect:RECT
	local hDc

    .if uMsg == WM_DESTROY
		invoke DestroyWindow,WinMain
		invoke PostQuitMessage,NULL

	.elseif uMsg == WM_PAINT
		invoke BeginPaint,hWnd,addr stPs
        mov hDc,eax
		invoke GetClientRect,hWnd,addr stRect
		invoke DrawText,hDc,addr szText,-1,addr stRect,DT_SINGLELINE
		invoke EndPaint,hWnd,addr stPs
	
	.elseif uMsg == WM_CREATE
        invoke CreateWindowEx,NULL,offset edit,offset showEdit1,WS_CHILD or WS_VISIBLE,50,50,300,30,hWnd,2,hInstance,NULL
		invoke CreateWindowEx,NULL,offset edit,offset showEdit2,WS_CHILD or WS_VISIBLE,50,100,300,30,hWnd,3,hInstance,NULL
		invoke CreateWindowEx,NULL,offset button,offset showButton,WS_CHILD or WS_VISIBLE,400,50,100,60,hWnd,1,hInstance,NULL
	.elseif uMsg == WM_COMMAND
		.if wParam == 1
			invoke GetDlgItemText, hWnd, 2,offset filepath1, 1024
			invoke GetDlgItemText, hWnd, 3,offset filepath2, 1024
			
            mov cline, 0
            xor	ax, ax
            cld
            mov	edi, offset msgOut
            mov ecx, BUF_SIZE
            rep stosb

			; 读取filename
            invoke	fopen, offset filepath1, offset mode
            .if eax==0
				invoke MessageBoxA,hWnd,offset nofileinfo,offset titleAlert, MB_OK
				ret
			.endif
			mov fp1, eax

            invoke	fopen, offset filepath2, offset mode
            .if eax==0
				invoke MessageBoxA,hWnd,offset nofileinfo,offset titleAlert, MB_OK
				ret
			.endif
			mov fp2, eax
			
		l1:
            mov	eax, cline
            inc eax
            mov	cline, eax
            ; buf清零
            xor	ax, ax
            cld
            mov	edi, offset buf1
            mov ecx, BUF_SIZE
            rep stosb
            mov ecx, BUF_SIZE
            mov	edi, offset buf2
            rep stosb

            ; 使用fp将文件读到buf中，使用fgets按行读取
            invoke	fgets, offset buf1, BUF_SIZE, fp1
            push	eax
            invoke	fgets, offset buf2, BUF_SIZE, fp2
            push	eax

			; 比较buf内容
            mov ecx, BUF_SIZE
            mov	esi, offset buf1
            mov	edi, offset buf2
            repe cmpsb
            jz l2
            invoke	strcat, offset msgOut, offset nomatchhead
            invoke  _itoa, cline, offset clinestr, 10
            invoke	strcat, offset msgOut, offset clinestr
            mov	flag_match, 1
            
        l2:	
            pop eax
            pop	ebx
            cmp	eax, ebx
            jnz	l1
            cmp	eax, 0
            jnz	l1

        e:
            .if flag_match == 1
                invoke MessageBoxA,hWnd,offset msgOut,offset notetitle, MB_OK
            .else
                invoke MessageBoxA,hWnd,offset noerrinfo,offset notetitle, MB_OK
            .endif
            invoke	fclose, fp1
            invoke	fclose, fp2
            xor eax, eax
            ret
		.endif
	.else
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam
		ret
	.endif

	xor eax,eax
	ret
WndProc endp

end start