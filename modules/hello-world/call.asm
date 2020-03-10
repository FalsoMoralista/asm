%include "linux64.inc"

global main
	MODULE_INIT_IGNORE_MODVERSIONS equ 1
	MODULE_INIT_IGNORE_VERMAGIC equ 2
	S_IRWXU equ 00700 ; owner permission mode
	section .text
main:	mov rax, SYS_OPEN
	mov rdi, filename
	mov rsi, O_RDONLY
	mov rdx, S_IRWXU
	syscall

	mov rdi, rax ; rax contains the file descriptor resulting from sys_open call
	mov rax, SYS_FINIT_MODULE
	mov rsi, args ; mod params
	mov rdx, MODULE_INIT_IGNORE_MODVERSIONS ;flags
	syscall

	mov rax, 60
	xor rdi, rdi
	syscall

	section .data
filename: db "hello.ko",0
args: db "",0
