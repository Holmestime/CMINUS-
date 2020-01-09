# 项目说明

这是一个识别CMINUS的COMPILER,使用flex + bison进行词法分析和语法分析构造

# 系统环境

- 操作系统 ubuntu18.04
- Bison版本 bison (GNU Bison) 3.0.4
- flex版本 flex 2.6.4
- gcc版本 gcc version 7.4.0 (Ubuntu 7.4.0-1ubuntu1~18.04.1)
- make版本 GNU Make 4.1 Built for x86_64-pc-linux-gnu
- dot版本 dot - graphviz version 2.40.1 (20161225.0304)

# 文件说明

命令的执行均在"./"路径下执行
测试文件均在"./test/"下
示例图均在"./picture"下
文件名需要注意的是例如num_wrongx.c代表的是以num_wrong为前缀的所有文件中的一个，避免繁琐而以此表示，实际中对应的是截图中相应的文件名


# 词法分析的图形化

- 生成dot文件 
  `bison --graph --report=all gramtree.y`
- 图形化生成pdf
  `dot gramtree.dot -Tpdf -o result.pdf`

# 编译

在此文件所在路径"./"下执行以下命令以生成mytask
不带调试方式 make
带调试方式 make debug
实例截图

# 功能

## 必做内容

能够识别词法错误和语法错误，部分结合语义进一步判断的错误目前以Type B中的";"缺失情况进行汇报

* 样例1
  所需文件 example1.c
  指令 ./mytask ./test/example1.c
  示例截图 example1.png
* 样例2
  所需文件 example2.c
  指令 ./mytask ./test/example2.c
  示例截图 example2.png
* 样例3
  所需文件 example3.c
  指令 ./mytask ./test/example3.c
  示例截图 example3.png

## 拓展部分

* 要求1.1
  - 能够正确识别八进制和十六进制并进行相关判断，不同进制的数统一按照一个TYPE进行建树，在数值的赋值前通过对不同进制进行识别并转成十进制。加入相应的词法规则的判断即可完成此项要求。
  - 所需文件 num_wrongx.c
  - 指令 ./mytask ./test/num_wrongx.c
  - 示例截图 num_wrong1.png num_wrong2.png
* 要求1.2
  - 所需文件 floatx.c
  - 指令 ./mytask ./test/floatx.c
  - 示例截图 float_test.c float_wrong.c
  - 能够正常识别浮点数及错误的报告。这里通过正常规则识别浮点数，额外建立规则来识别错误的浮点表现形式，即错误通过一种标识匹配进行识别
* 要求1.3
  - 所需文件 comment_test.c
  - 指令 ./mytask ./test/comment_test.c
  - 示例截图 comment_test.png
  - 能够正常识别//和/*/*/的注释，并能对缺少注释的标识符进行报告。这里一旦检测到"unterminated comment"就不再进行以后的程序检测，并立即终止程序运行。



# 参考文献

> [flex&bison编写语法分析器](https://blog.csdn.net/qq_24421591/article/details/50045933)
>
> [ANSI C Yacc grammar](http://www.quut.com/c/ANSI-C-grammar-y-2011.html)
>
> [ANSI C grammar, Lex specification](http://www.quut.com/c/ANSI-C-grammar-l-2011.html)

