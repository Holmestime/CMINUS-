%{
#include<stdio.h>
#include<stdlib.h>
#include"gramtree.h"
#include"gramtree.tab.h"
extern int flag;
%}
%option yylineno


D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			([Ee][+-]?{D}+)
P           ([Pp][+-]?{D}+)
O_16        (0|1|2|3|4|5|6|7|8|9|a|b|c|d|e|f|A|B|C|D|E|F)      
FS			(f|F)
INT         [1-9]+[0-9]*|0
ID          {L}({L}|{D})*
FLOAT_A     {D}+{E}{FS}?
FLOAT_B     {D}*"."{D}+{E}?{FS}?
FLOAT_C     {D}+"."{D}*{E}?{FS}?
SEMI ;
COMMA ,
ASSIGNOP =
RELOP >|<|>=|<=|==|!=
PLUS \+
MINUS -
STAR \*
DIV \/
AND &&
OR \|\|
DOT \.
NOT !
LP \(
RP \)
LB \[
RB \]
LC \{
RC \}
SPACE [ \t\r]*
EOL \n
COM_ONE "//".*
COM_TWO [/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]
COM_ERR [/][*]
WRONG16 0x{O_16}*[g-zG-Z]
NUM_16 0x{O_16}{O_16}* 
WRONG8  0(0|1|2|3|4|5|6|7)*[89{L}]
NUM_8 0(0|1|2|3|4|5|6|7)(0|1|2|3|4|5|6|7)*
TYPE int|float
STRUCT struct
RETURN return
IF if
ELSE else
WHILE while
AERROR .

%%
int|float   {yylval.a=newtree("TYPE",0,yylineno);return TYPE;}
struct      {yylval.a=newtree("STRUCT",0,yylineno);return STRUCT;}

{RETURN}    {yylval.a=newtree("RETURN",0,yylineno); return RETURN;}
{IF}        {yylval.a=newtree("IF",0,yylineno);return IF;}
{ELSE}      {yylval.a=newtree("ELSE",0,yylineno); return ELSE;}
{WHILE}     {yylval.a=newtree("WHILE",0,yylineno); return WHILE;}
{NUM_8}     {yylval.a=newtree("INT",0,yylineno); return INT;}
{WRONG8}    {flag = 1; printf("Error type A at line %d: Mystirious octal num \n",yylineno);exit(0);}
{NUM_16}    {yylval.a=newtree("INT",0,yylineno); return INT;}
{WRONG16}   {flag = 1; printf("Error type A at line %d: Mystirious hex num \n",yylineno);exit(0);}
{INT}       {yylval.a=newtree("INT",0,yylineno); return INT;}
{FLOAT_A}   {yylval.a=newtree("FLOAT",0,yylineno); return FLOAT;}
{FLOAT_B}   {yylval.a=newtree("FLOAT",0,yylineno); return FLOAT;}
{FLOAT_C}   {yylval.a=newtree("FLOAT",0,yylineno); return FLOAT;}
{ID}        {yylval.a=newtree("ID",0,yylineno); return ID;}
{SEMI}      {yylval.a=newtree("SEMI",0,yylineno); return SEMI;}
{COMMA}     {yylval.a=newtree("COMMA",0,yylineno); return COMMA;}
{ASSIGNOP}  {yylval.a=newtree("ASSIGNOP",0,yylineno); return ASSIGNOP;}
{RELOP}     {yylval.a=newtree("RELOP",0,yylineno); return RELOP;}
{PLUS}      {yylval.a=newtree("PLUS",0,yylineno); return PLUS;}
{MINUS}     {yylval.a=newtree("MINUS",0,yylineno); return MINUS;}
{STAR}      {yylval.a=newtree("STAR",0,yylineno); return STAR;}
{DIV}       {yylval.a=newtree("DIV",0,yylineno); return DIV;}
{AND}       {yylval.a=newtree("AND",0,yylineno); return AND;}
{OR}        {yylval.a=newtree("OR",0,yylineno); return OR;}
{DOT}       {yylval.a=newtree("DOT",0,yylineno); return DOT;}
{NOT}       {yylval.a=newtree("NOT",0,yylineno); return NOT;}
{LP}        {yylval.a=newtree("LP",0,yylineno); return LP;}
{RP}        {yylval.a=newtree("RP",0,yylineno); return RP;}
{LB}        {yylval.a=newtree("LB",0,yylineno); return LB;}
{RB}        {yylval.a=newtree("RB",0,yylineno); return RB;}
{LC}        {yylval.a=newtree("LC",0,yylineno); return LC;}
{RC}        {yylval.a=newtree("RC",0,yylineno); return RC;}
{SPACE}     { /* DO NOTHING */ }
{EOL}       { /* DO NOTHING */ }
{COM_ONE}   { /* DO NOTHING */ }
{COM_TWO}   { /* DO NOTHING */ }
{COM_ERR}   {flag = 1; printf("Error type B at line %d: Unterminated comment\n",yylineno); exit(0);}
{AERROR}    {flag = 1; printf("Error type A at line %d: Mystirious charachter '%s'\n",yylineno,yytext);}

%%

int yywrap()
{
    return 1;
}