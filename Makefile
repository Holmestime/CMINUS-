default:gramtree.y gramtree.l gramtree.h
	bison -d  gramtree.y
	flex  gramtree.l
	gcc gramtree.tab.c lex.yy.c gramtree.c -o mytask

debug: gramtree.y gramtree.l gramtree.h
	bison --debug  gramtree.y
	flex -t gramtree.l
	gcc -DDEBUG gramtree.tab.c lex.yy.c gramtree.c -o mytask

test:
	./mytask test.c


