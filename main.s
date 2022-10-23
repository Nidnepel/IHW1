	.file	"main.c"
	.text
	.section	.rodata
.LC0:
	.string	"%d"
.LC1:
	.string	"%d "
	.text
	.globl	main
	.type	main, @function

# сдвиг относительно %rbp
# -16 = b
# -24 = arr
# -28 = i в третьем цикле
# -32 = j
# -36 = i во втором цикле
# -40 = m
# -44 = i в первом цикле
# -48 = sumOfOdd
# -52 = n

main:
	pushq	%rbp
	movq	%rsp, %rbp # пролог функции
	subq	$64, %rsp # выделение места на стеке для функции main
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-52(%rbp), %rax
	movq	%rax, %rsi # кладем указатель на n в регистр %rsi
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi # кладем строку "%d" в регистр %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT # вызываем функцию scanf с аргументами %rsi и %rdi
	movl	-52(%rbp), %eax # кладем значение n в %eax
	cltq # конвертируем %eax в 8-байтный
	salq	$2, %rax # домножаем на 4 (размер int в байтах)
	movq	%rax, %rdi # кладем значение в регистр %rdi
	call	malloc@PLT # вызов функции malloc с аргументом %rdi
	movq	%rax, -24(%rbp) # arr хранится в %rbp - 24
	movl	$0, -48(%rbp) # инициализируем sumOfOdd нулем
	movl	$0, -44(%rbp) # инициализируем i нулем
	jmp	.L2
.L4:
	movl	-44(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx # %rdx = i * 4 (sizeof int)
	movq	-24(%rbp), %rax # %rax = указатель на arr
	addq	%rdx, %rax
	movq	%rax, %rsi # кладем указатель на arr[i] в регистр %rsi
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi # кладем строку "%d" в регистр %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT # вызываем функцию scanf с аргументами %rsi и %rdi
	movl	-44(%rbp), %eax # %eax = i
	andl	$1, %eax # %eax &= 1 (%eax %= 2)
	testl	%eax, %eax # проверяем (i % 2) на равенство с нулем
	jne	.L3
	movl	-44(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax # %rax = &arr[i]
	movl	(%rax), %eax # %eax = arr[i]
	addl	%eax, -48(%rbp) # sumOfOdd += arr[i]
.L3:
	addl	$1, -44(%rbp) # ++i
.L2:
	movl	-52(%rbp), %eax
	cmpl	%eax, -44(%rbp) # сравниваем i и n
	jl	.L4 # если i < n, то продолжаем цикл
	movl	$0, -40(%rbp) # m = 0
	movl	$0, -36(%rbp) # i = 0
	jmp	.L5
.L7:
	movl	-36(%rbp), %eax # %eax = i
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax # %rax = &arr[i]
	movl	(%rax), %eax # %eax = arr[i]
	cmpl	%eax, -48(%rbp) # сравниваем arr[i] и sumOfOdd
	jle	.L6 # если arr[i] >= sumOfOdd, то не надо увеличивать m
	addl	$1, -40(%rbp) # ++m
.L6:
	addl	$1, -36(%rbp) # ++i
.L5:
	movl	-52(%rbp), %eax
	cmpl	%eax, -36(%rbp) # сравниваем i и n
	jl	.L7 # если i < n, то продолжаем цикл
	movl	-40(%rbp), %eax # %rax = m
	cltq
	salq	$2, %rax # %rax *= 4 (sizeof int)
	movq	%rax, %rdi
	call	malloc@PLT # вызов функции malloc с аргументом %rdi
	movq	%rax, -16(%rbp)
	movl	$0, -32(%rbp) # j = 0
	movl	$0, -28(%rbp) # i = 0
	jmp	.L8
.L10:
	movl	-28(%rbp), %eax # %rax = i
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax # %rax = &arr[i]
	movl	(%rax), %eax # %eax = arr[i]
	cmpl	%eax, -48(%rbp) # сравниваем arr[i] и sumOfOdd
	jle	.L9 # если arr[i] >= sumOfOdd, то не надо обновлять массив b
	movl	-28(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax # %rax = &arr[i]
	movl	-32(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,4), %rcx
	movq	-16(%rbp), %rdx
	addq	%rcx, %rdx # %rdx = &b[j]
	movl	(%rax), %eax # %eax = arr[i]
	movl	%eax, (%rdx) # b[j] = arr[i]
	movl	-32(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	movq	-16(%rbp), %rax
	addq	%rdx, %rax # %rax = &b[j]
	movl	(%rax), %eax # %eax = b[j]
	movl	%eax, %esi # %esi = b[j]
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi # кладем строку " %d" в регистр %rdi
	movl	$0, %eax
	call	printf@PLT # вызываем функцию printf с аргументами %rsi и %rdi
	addl	$1, -32(%rbp) # ++j
.L9:
	addl	$1, -28(%rbp) # ++i
.L8:
	movl	-52(%rbp), %eax
	cmpl	%eax, -28(%rbp) # сравниваем i и n
	jl	.L10 # если i < n, то продолжаем цикл
	movq	-16(%rbp), %rax
	movq	%rax, %rdi # %rdi = b
	call	free@PLT # вызываем функцию free с аргументом %rdi
	movq	-24(%rbp), %rax
	movq	%rax, %rdi # %rdi = arr
	call	free@PLT # вызываем функцию free с аргументом %rdi
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L12
	call	__stack_chk_fail@PLT
.L12:
	leave # эпилог функции
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
	.section	.note.GNU-stack,"",@progbits
