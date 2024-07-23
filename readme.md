# MIPS 单周期非流水 处理器
### 指令
处理器所支持的指令包括 LW， SW， ADD， SUB， AND， OR， XOR， SLT， MOVZ， BEQ， J。
* 其中仅有 LW 和 SW 是字访存指令，所有的存储器访问都通过这两条指令完成； 
* ADD、 SUB、 AND、 OR、 XOR、SLT、 MOVZ 是运算指令，他们都在处理器内部完成； 
* BEQ 是分支跳转指令，根据寄存器的内容进行相对跳转；J 是无条件转移指令。
### 处理器结构设计框图
![image](https://github.com/user-attachments/assets/b7dda4c6-2cd2-42dd-939b-127fc3cafe0a)
