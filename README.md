﻿# asm
王爽汇编


## 第7章
### and和or
如果想要某一位变为0,利用0与其进行与运算  
如果想要某一位变为1,利用1与其进行或运算  
1111 and 1011 => 1011  
0000 or 0100  => 0100  

### 大小写转换的问题
* 将大写+20h可转换为小写, 将小写-20h可转换为大写
* 利用and或or运算,更改第五位(索引从0开始), 要获得大写改为0, 要获得小写则改为1

### 内存寻址
* [bx+idata]
* 

## 第8章
### 关于偏移地址的表示
* 在8086CPU中，能够用于偏移地址的寄存器只有 bx, si, di, bp  
* 在表示偏移地址的组合中，只有bx和si, bx和di, bp和si, bp和di这四种组合  
* 如果使用了bp而又没有显式的给出段地址,那么段地址就是ss, 如  
	mov ax, [bp]		<=>		mov ax, ss:[bp]  
	mov ax, [bp+idata]	<=>		mov ax, ss:[bp+idata]  

### 寻址方式总结
* 直接寻址
* 寄存器间接寻址
* 寄存器相对寻址
* 基址变址寻址
* 相对基址变址寻址

### 处理的数据的长度是多少
* 如果使用到具体寄存器，则操作数据的大小等同于寄存器
* 没有寄存器的情况下可使用X ptr表示，X可为word，byte
* 其他，如push操作数据的大小只能是word

mov word ptr ds:[0], 1  
mov byte ptr ds:[0], 1  



### div
```asm
; div reg / div [...]
div ax
div byte ptr ds:[0]
```
div是一个除法指令，除法指令执行我们需要知道的信息有
* 除数的大小(8/16位)
* 被除数的最大值
* 被除数在哪
* 商被保存在哪
* 余数被保存在哪
* 被除数比除数大一倍， 若除数是8位，被除数则为16位

| 除数的大小  |   被除数      | 商 | 余数 |
|-------------|---------------|----|------|
|    8位      |     AX        | AL |  AH  |
|   16位      | DX(高),AX(低) | AX |  DX  |


> 使用div计算的时候需要注意,不能让商溢出, 8位除数商最大值为255, 16位除数商最大值65535
> 对应的被除数最大值为65279(FEFF 8位), 4294901759(FFFE FFFF 16位)


程序示例  
除数为8位: 8_div_8.asm
除数为16位: 8_div_16.asm

```asm
div byte ptr [0]
(al) = (ax) / ((ds)*16 + 0)的商
(ah) = (ax) / ((ds)*16 + 0)的余数

div word ptr [0]
(ax) = (ds)*10000h + (ax) / ((ds) * 16 + 0)的商
(dx) = (ds)*10000h + (ax) / ((ds) * 16 + 0)的余数
```

### db,dw和dd
db: 定义字节数据, 每个占一个字节  
dw: 定义字数据,   每个占两个字节  
dd: 定义双字数据, 每个占四个字节  	

### dup
配合db,dw,dd使用,定义连续n个相同的数据
```asm
db 重复次数 dup (重复的字节型数据)
dw 重复次数 dup (重复的字型数据)
dd 重复次数 dup (重复的双字型数据)
```

## 第9章
###本章总结
* 只要是段内转移,并不包含真实地址,只是通过偏移量跳转
* 所有的有条件转移指令都是短转移,对IP的修改范围-128~127
* 所有的循环指令都是短转移, 对IP的修改范围为-128~127
* 位移距离使用补码表示

### 转移指令汇总
* jmp
* jcxz
* loop

### 几个名词记录
```
# 短转移
不包含目的地地址, 只是获得转移的位移,只修改IP, 范围-128~127

```
### 转移指令
可以修改IP或同时修改CS和IP的指令统称为转移指令
8086CPU的转移指令分为以下几类
* 无条件转移(如jmp)
* 条件转移
* 循环 (loop)
* 过程
* 中断

### offset
offset的作用是获取标号的偏移地址  
```asm
start: mov ax, offset s ; 获取标号s的偏移地址,送入ax
end: mov ax, offset end ; 获取标号end的偏移地址,送入ax
```

### 回顾指令执行步骤
1. 从CS:IP指向的单元读取指令到指令缓冲器
2. IP = IP+指令的长度
3. 执行指令, 回到第一步重复这个过程

### jmp指令
修改CS:IP或IP使程序跳转都某处开始执行代码

#### 转移位移的计算方法
位移 = 标号位置 - jmp指令的下一条指令的位置


```asm
; 几条转移指令
jmp 标号
jmp short 标号 		; 8位位移 (范围-128~127)
jmp near ptr 标号 	; 此处的位移是16位 (范围-32768~32767)
jmp far ptr 标号	; 实现段间转移, (不存在转移范围只能是 -32768~32767的问题)
jmp 寄存器			; IP = 寄存器的值
jmp word ptr 内存单元地址  ; 段内转移
jmp dword ptr 内存单元地址 ; 段间转移, 高位存储段地址, 低位存储偏移地址
jcxz 标号 			; jmp if cx is zero的缩写(我猜),用C表示就是 if (0==cx) jmp short 标号

```


### 使用汇编显示字符
在内存地址中B8000~BFFFF,共32kib的空间为80x25(列x行)彩色字符模式的显示缓冲区,在这里写入数据将会显示出来  
每个字符占2个字节,分别是字符的ASCII码(低位), 字符的属性(高位)  

字符的属性有: 前景色,背景色,闪烁,高亮, (闪烁的效果必须在DOS全屏的方式才能看到?)
|闪烁| 背景 | 高亮 |  前景  |
|----|------|------|--------|
| BL | R G  B | I | R  G  B |
| 7 | 6  5  4 | 3 | 2  1  0 |


# 关于寄存器的大小问题
一个寄存器通常是16位,如: al(8),ah(8) => ax(16)  
al, ah的存值范围 0-255	=> 1个字节	=> 8个二进制数  
ax的存值范围 0-65535	=> 2个字节	=> 16个二进制数  

用16进制表示则是  
al的范围是0-ff  
ax的范围是0-ffff  

