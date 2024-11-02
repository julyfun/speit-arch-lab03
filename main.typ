#set page(paper: "us-letter")
#set heading(numbering: "1.1.")
#set figure(numbering: "1")

#show strong: set text(weight: 900)  // Songti SC 700 不够粗
#show heading: set text(weight: 900)

#set text(
  font: ("New Computer Modern", "FZKai-Z03S")
)

#import "@preview/codelst:2.0.0": sourcecode
#show raw.where(block: true): it => {
  set text(size: 10pt)
  sourcecode(it)
}

// 这是注释
#figure(image("sjtu.png", width: 50%), numbering: none) \ \ \

#align(center, text(17pt)[
  计算机体系结构 Lab03 \ \
  #table(
      columns: 2,
      stroke: none,
      rows: (2.5em),
      // align: (x, y) =>
      //   if x == 0 { right } else { left },
      align: (right, left),
      [Name:], [Junjie Fang (Florian)],
      [Student ID:], [521260910018],
      [Date:], [#datetime.today().display()],
    )
])

#pagebreak()

#set page(header: align(right)[
  DB Lab1 Report - Junjie FANG
], numbering: "1")

#show outline.entry.where(
  level: 1
): it => {
  v(12pt, weak: true)
  strong(it)
}

// [lib]
#import "@preview/tablem:0.1.0": tablem

#let three-line-table = tablem.with(
  render: (columns: auto, ..args) => {
    table(
      columns: columns,
      stroke: none,
      align: center + horizon,
      table.hline(y: 0),
      table.hline(y: 1, stroke: .5pt),
      table.hline(y: 4, stroke: .5pt),
      table.hline(y: 7, stroke: .5pt),
      ..args,
      table.hline(),
    )
  }
)

#outline(indent: 1.5em)

#set text(12pt)
#show heading.where(level: 1): it => {
  it.body
}
#set list(indent: 0.8em)

// [正文]

= Ex1 Action

== 实验目的

- 熟悉 RISC-V 汇编语言的基本语法和指令.
- 熟悉 RISC-V 汇编语言的数据段和代码段的定义.
- 熟悉 RISC-V 汇编语言的函数调用和参数传递.

== 实验步骤

- *1.1:* 查找代码段和数据段的定义.
- *1.2:* 运行程序，输出结果.
- *1.3:* 查找 `n` 的存储位置，其在内存中的某一个位置。
- *1.4:* 修改程序，输出第 13 个斐波那契数.

== 实验分析

- 官方文档中有关 RISC-V 汇编语言的基本语法和指令的定义.
- `la t3, n` 指令将 `n` 的地址存储到 `t3` 寄存器中，从而可在模拟器中查看 `n` 的存储位置.

#figure(image("image.png"))

== 问题回答

- *1.1*
  - `.data` 数据段，存储全局变量和静态变量，常量字符串等.
  - `.word` 用于初始化数据段中的变量或常量.
  - `.text` 代码段，存储程序的指令.
- *1.2:* 运行程序，输出 `34`。这是第 9 个斐波那契数.
- *1.3:* n 存储于 `0x10000010`.
- *1.4:* 想求出第 13 个斐波那契数，在执行完 `lw t3, 0(t3)` 后将 `t3` 存储的值修改为 `13` 即可. 输出了 `233`.

#figure(image("image copy.png"))

= Ex2 Action

== 实验目的

- 继续熟悉 RISC-V 汇编语言的基本语法和指令.
- 循环结构的实现.
- 指针操作的实现.

== 实验步骤

- *2.1:* 查找 `k` 的存储位置，其在内存中的某一个位置.
- *2.2:* `add s0, s0, t2 # s0(:sum) += t2` 可以看出 `s0` 寄存器存储 `sum`.
- *2.3:* `s1` 寄存器存储 `source`, `s2` 寄存器存储 `dest`.
- *2.4:* 想要实现循环，需要标签 `loop` 和 `exit`，跳转条件为 `beq t2, x0, exit`.
- *2.5:* 指针操作，通过 `add` 指令计算出数组的地址，再通过 `lw` 和 `sw` 指令读写数组元素.

#figure(image("image copy 3.png", height: 30%))

== 问题回答

- *2.1*: `t0` 寄存器存储 `k`.
- *2.2*: `s0` 寄存器存储 `sum`.
- *2.3*: `s1` 寄存器存储 `source`, `s2` 寄存器存储 `dest`.
- *2.4*: `loop` 标签开始到 `exit` 标签结束前，都是 C 语言循环部分.

#figure(image("image copy 2.png", height: 40%))

- *2.5*: 关于指针操作，汇编中使用一个寄存器存储数组的首地址，另一个寄存器存储数组的索引，通过 `add` 指令计算出数组的地址，再通过 `lw` 和 `sw` 指令读写数组元素.

= Ex3 Action

== 实验目的

- 用 RISC-V 汇编语言实现循环阶乘函数.

== 实验步骤

- 设置初值 `a1 = 1`, `t0 = 1`.
- 循环变量 `t0` 与 `n` 比较，若相等则退出循环.
- 循环体内 `a1 *= t0`, `t0++`.

#figure(image("image copy 4.png"))

== 问题回答

```risc-v
factorial:
    addi a1, x0, 1 # a1 = 1
    addi t0, x0, 1 # t0 = 1
loop:
    mul a1, a1, t0
    beq t0, a0, exit # if t0 == n exit
    addi t0, t0, 1
    jal x0, loop
exit:
    add a0, a1, x0
    jr ra
```

=== Testing

#figure(image("image copy 5.png"))

= Ex4 Action

== 实验目的

- RISC-V 调用函数时对寄存器有使用规范。

== 实验步骤

- 修改寄存器处理，保证调用函数的开头和结尾都有保存和恢复寄存器的操作.
- 通过 CC Checker 检查代码段中的函数调用是否符合规范.

== 实验分析

- 一个函数的开头应有保存寄存器的操作，结尾应有恢复寄存器的操作.
- 如果函数内部调用了其他函数，则需要保存 `ra` 寄存器的值.
- 若函数内部调用的函数未在 `.globl` 中声明，则不会被 CC Checker 检查.

== 问题回答

- *4.1:* 因为这些标签内没有将 `s0 - s11` 这种寄存器的值存到栈上和加载它们.
- *4.2:* calling convention 对循环标签不适用，因为循环标签内已经处理了循环跳转，与函数的栈型访问不同.
- *4.3:* `inc_arr` 调用了 `helper_fn`，其改变了 `ra`，所以 `inc_arr` 中需要保存 `ra` 的值.
- *4.4:* `.globl simple_fn naive_pow inc_arr` 其中没有将 `helper_fn` 加入其中，其不会被 CC Checker 检查。

== Testing

#figure(image("image copy 6.png"))

= Ex5 Action

== 实验目的

-  用汇编语言实现回调函数，理解函数指针在 RISC-V 中的用法.

== 实验步骤

- 实现 `map` 函数，将一个函数应用到链表的每个元素上.
- 函数指针以 `a1` 寄存器传入 `map` 函数，即第二个参数.
- `map` 函数将函数指针保存到 `s1` 寄存器中，以备递归调用，保证调用时函数指针不变.

== 实验分析

- 为什么用 `a0` 存储当前节点的值，而不是其他寄存器？
  - 因为 `a0` 是传递给 `square` 函数的参数.
- 为何不使用 label 调用函数？
  - 要调用的函数是可变的，作为参数传递给 `map` 函数，更灵活. 如果用 label 调用函数，会限制函数的选择.
- 为什么用 `a1` 存储函数指针，而不是 `a0`？
  - `a0` 存储当前节点的值，`a1` 存储函数指针，保证递归调用时函数指针不变.

== 问题回答

```
    # load the value of the current node into a0
    # THINK: why a0?
    ### YOUR CODE HERE ###
    lw a0, 0(s0)
    # ANS: Because a0 will be the argument for square function

    ...

    # Call the function in question on that value. DO NOT use a label (be prepared to answer why).
    # What function? Recall the parameters of "map"
    ### YOUR CODE HERE ###
    jalr ra, s1, 0
    # ANS: We don't use a label because the function is passed as an argument to the map function.

    ...

    # Put the address of the function back into a1 to prepare for the recursion
    # THINK: why a1? What about a0?
    ### YOUR CODE HERE ###
    addi a1, s1, 0
    # ANS: a1 is used to store the address of the function while a0 is used to store the value of the current node.
```

== Testing

#figure(image("image copy 7.png"))

完整代码:

```assembly
.globl map

.text
main:
    jal ra, create_default_list
    add s0, a0, x0  # s0 = a0 is head of node list

    add a0, s0, x0
    jal ra, print_list

    jal ra, print_newline

    add a0, s0, x0  # load the address of the first node into a0

    la a1, square

    jal ra, map

    add a0, s0, x0
    jal ra, print_list

    jal ra, print_newline

    addi a0, x0, 10
    ecall #Terminate the program

map:
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw ra, 8(sp)

map_loop:
    beq a0, x0, done    # If we were given a null pointer (address 0), we're done.

    add s0, a0, x0  # Save address of this node in s0
    add s1, a1, x0  # Save address of function in s1, safely (a1 maybe modifiedby func call)


    lw a0, 0(s0)

    jalr ra, s1, 0
    
    sw a0, 0(s0)

    lw a0, 4(s0)

    addi a1, s1, 0

    jal x0, map_loop

done:
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12

    jr ra # Return to caller

square:
    mul a0 ,a0, a0
    jr ra

create_default_list:
    addi sp, sp, -12
    sw  ra, 0(sp)
    sw  s0, 4(sp)
    sw  s1, 8(sp)
    li  s0, 0       # pointer to the last node we handled
    li  s1, 0       # number of nodes handled
loop:   #do...
    li  a0, 8 # a0 = 8
    jal ra, malloc      # get memory for the next node
    sw  s1, 0(a0)   # node->value {0(a0)} = i
    sw  s0, 4(a0)   # node->next = last
    add s0, a0, x0  # last = node
    addi    s1, s1, 1   # i++
    addi t0, x0, 10
    bne s1, t0, loop    # ... while i!= 10
    lw  ra, 0(sp)
    lw  s0, 4(sp)
    lw  s1, 8(sp)
    addi sp, sp, 12
    jr ra

print_list:
    bne a0, x0, printMeAndRecurse
    jr ra       # nothing to print
printMeAndRecurse:
    add t0, a0, x0  # t0 gets current node address
    lw  a1, 0(t0)   # a1 gets value in current node
    addi a0, x0, 1      # prepare for print integer ecall
    ecall
    addi    a1, x0, ' '     # a0 gets address of string containing space
    addi    a0, x0, 11      # prepare for print string syscall
    ecall # 模拟器提供
    lw  a0, 4(t0)   # a0 gets address of next node
    jal x0, print_list  # recurse. We don't have to use jal because we already have where we want to return to in ra

print_newline:
    addi    a1, x0, '\n' # Load in ascii code for newline
    addi    a0, x0, 11
    ecall
    jr  ra

malloc:
    addi    a1, a0, 0
    addi    a0, x0 9
    ecall
    jr  ra
```
