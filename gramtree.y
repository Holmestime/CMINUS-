%{
#include<stdio.h>
#include"gramtree.h"
int yylex();
void yyerror(char* msg,...);
int flag = 0;
%}
%union{
    struct node* a;
    double d;
}

/*declare tokens*/


%token <a> INT FLOAT
%token <a> TYPE STRUCT RETURN IF ELSE WHILE ID SPACE SEMI COMMA ASSIGNOP RELOP PLUS
			MINUS STAR DIV AND OR DOT NOT LP RP LB RB LC RC AERROR
%token <a> EOL

%type <a> Program ExtDefList ExtDef Specifier ExtDecList FunDec CompSt VarDec DecList
%type <a> StructSpecifier OptTag DefList Tag VarList ParamDec StmtList Stmt
%type <a> Exp Def Dec Args


/*priority*/
%right ASSIGNOP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT 
%left LP RP LB RB DOT

%%

Program:ExtDefList 					{$$=newtree("Program",1,$1); travel($$,0);}
    ;
ExtDefList: ExtDef ExtDefList 		{$$=newtree("ExtDefList",2,$1,$2);}
	| {$$=newtree("ExtDefList",0,-1);}
	;
ExtDef:Specifier ExtDecList SEMI    {$$=newtree("ExtDef",3,$1,$2,$3);}
	| Specifier ExtDecList error 	{flag = 1;fprintf(stderr,"Error type B at line %d: Missing ';'\n",yylineno);}
	| Specifier SEMI				{$$=newtree("ExtDef",2,$1,$2);}
	| Specifier error 				{flag = 1;fprintf(stderr,"Error type B at line %d: Missing ';'\n",yylineno);}
	| Specifier FunDec CompSt		{$$=newtree("ExtDef",3,$1,$2,$3);}
	;

ExtDecList:VarDec 					{$$=newtree("ExtDecList",1,$1);}
	| VarDec COMMA ExtDecList 		{$$=newtree("ExtDecList",3,$1,$2,$3);}
	;

/*specifiers*/
Specifier:TYPE 						{$$=newtree("Specifier",1,$1);}
	| StructSpecifier 				{$$=newtree("Specifier",1,$1);}
	;

StructSpecifier:STRUCT OptTag LC DefList RC 	{$$=newtree("StructSpecifier",5,$1,$2,$3,$4,$5);}
	| STRUCT Tag 					{$$=newtree("StructSpecifier",2,$1,$2);}
	;

OptTag:ID 							{$$=newtree("OptTag",1,$1);}
	| 								{$$=newtree("OptTag",0,-1);}
	;

Tag:ID 								{$$=newtree("Tag",1,$1);}
	;

/*Declarators*/
VarDec: ID 							{$$=newtree("VarDec",1,$1);}
	| VarDec LB INT RB 				{$$=newtree("VarDec",4,$1,$2,$3,$4);}
	;
FunDec:ID LP VarList RP 			{$$=newtree("FunDec",4,$1,$2,$3,$4);}
	| ID LP RP 						{$$=newtree("FunDec",3,$1,$2,$3);}
	;
VarList:ParamDec COMMA VarList 		{$$=newtree("VarList",3,$1,$2,$3);}
	| ParamDec 						{$$=newtree("VarList",1,$1);}
	;
ParamDec:Specifier VarDec 			{$$=newtree("ParamDec",2,$1,$2);}
    ;

/*Statement*/
CompSt: LC DefList StmtList RC 		{$$=newtree("CompSt",4,$1,$2,$3,$4);}
	;

StmtList:Stmt StmtList				{$$=newtree("StmtList",2,$1,$2);}
	| 								{$$=newtree("StmtList",0,-1);}
	;

Stmt:Exp SEMI 						{$$=newtree("Stmt",2,$1,$2);}
	| Exp error 					{flag = 1;fprintf(stderr,"Error type B at line %d: Missing ';'\n",yylineno);}
	| CompSt 						{$$=newtree("Stmt",1,$1);}
	| RETURN Exp SEMI 				{$$=newtree("Stmt",3,$1,$2,$3);}
	| RETURN Exp error  			{flag = 1;fprintf(stderr,"Error type B at line %d: Missing ';'\n",yylineno);}
	| IF LP Exp RP Stmt 			{$$=newtree("Stmt",5,$1,$2,$3,$4,$5);}
	| IF LP Exp RP Stmt ELSE Stmt 	{$$=newtree("Stmt",7,$1,$2,$3,$4,$5,$6,$7);}
	| WHILE LP Exp RP Stmt 			{$$=newtree("Stmt",5,$1,$2,$3,$4,$5);}
    ;

/*Local Definitions*/
DefList:Def DefList					{$$=newtree("DefList",2,$1,$2);}
	| 								{$$=newtree("DefList",0,-1);}
	;
Def: Specifier DecList error		{flag = 1;fprintf(stderr,"Error type B at line %d: Missing ';'\n",yylineno);}
	| Specifier DecList SEMI 		{$$=newtree("Def",3,$1,$2,$3);}
	;
DecList: Dec 						{$$=newtree("DecList",1,$1);}
	| Dec COMMA DecList 			{$$=newtree("DecList",3,$1,$2,$3);}
	;
Dec:VarDec 							{$$=newtree("Dec",1,$1);}
	| VarDec ASSIGNOP Exp 			{$$=newtree("Dec",3,$1,$2,$3);}
	;

/*Expressions*/
Exp:Exp ASSIGNOP Exp				{$$=newtree("Exp",3,$1,$2,$3);}
    | Exp AND Exp					{$$=newtree("Exp",3,$1,$2,$3);}
    | Exp OR Exp					{$$=newtree("Exp",3,$1,$2,$3);}
    | Exp RELOP Exp					{$$=newtree("Exp",3,$1,$2,$3);}
    | Exp PLUS Exp					{$$=newtree("Exp",3,$1,$2,$3);}
    | Exp MINUS Exp					{$$=newtree("Exp",3,$1,$2,$3);}
    | Exp STAR Exp					{$$=newtree("Exp",3,$1,$2,$3);}
    | Exp DIV Exp					{$$=newtree("Exp",3,$1,$2,$3);}
    | LP Exp RP						{$$=newtree("Exp",3,$1,$2,$3);}
    | MINUS Exp 					{$$=newtree("Exp",2,$1,$2);}
    | NOT Exp 						{$$=newtree("Exp",2,$1,$2);}
    | ID LP Args RP 				{$$=newtree("Exp",4,$1,$2,$3,$4);}
    | ID LP RP 						{$$=newtree("Exp",3,$1,$2,$3);}
	| Exp LB Exp error RB			{flag = 1;fprintf(stderr,"Error type B at line %d: Missing ']'\n",yylineno);}
    | Exp LB Exp RB 				{$$=newtree("Exp",4,$1,$2,$3,$4);}
    | Exp DOT ID 					{$$=newtree("Exp",3,$1,$2,$3);}
    | ID 							{$$=newtree("Exp",1,$1);}
    | INT 							{$$=newtree("Exp",1,$1);}
	| FLOAT error 					{flag = 1;fprintf(stderr,"Error type A at line %d: Unterminated float\n",yylineno); return 0;}
    | FLOAT							{$$=newtree("Exp",1,$1);}
    ;

Args:Exp COMMA Args 				{$$=newtree("Args",3,$1,$2,$3);}
    | Exp 							{$$=newtree("Args",1,$1);}
    ;
%%

