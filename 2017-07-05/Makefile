default: scanner parser

	javac *.java

scanner:
	jflex scanner.jflex
	
parser:
	java java_cup.Main -expect 0 -parser parser parser.cup
	
clean:

	rm -fr parser.java scanner.java Lexer.java sym.java
	rm -vfr *.class
	rm -vfr *.*~
	
init:
	mkdir source build
	
run:
	java Main exam_20170705.txt

new: default run
