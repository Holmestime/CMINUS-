#include<stdio.h>
#include<stdlib.h>
#include<stdarg.h>
#include<string.h>
#include"gramtree.h"

struct node* newtree(char* name,int num,...)
{
    va_list valist;
    struct node *parent = (struct node*)malloc(sizeof(struct node));
    struct node *temp = (struct node*)malloc(sizeof(struct node));
    if(!parent)
    {
        yyerror("out of space");
        exit(0);
    }
    parent->name = name;
    va_start(valist,num);

    if(num>0)
    {
        temp = va_arg(valist,struct node*);
        parent->left = temp;
        parent->line = temp->line;
        if(num>=2)
        {
            for(int i=0;i<num-1;++i)
            {
                temp->right = va_arg(valist,struct node*);
                temp = temp->right;
            }
        }
    }
    else
    {
        int t = va_arg(valist,int);
        parent->line = t;
        if((!strcmp(parent->name,"ID")) || (!strcmp(parent->name,"TYPE")))
        {
            char *t = (char*)malloc(sizeof(char*)*40);
            strcpy(t,yytext);
            parent->idtype = t;
        }
        else if(!strcmp(parent->name,"INT"))
        {
            parent->intval = match(yytext);
        }
        else if(!strcmp(parent->name,"FLOAT"))
        {
            parent->flval = (float)atof(yytext);
        }
        else
        {
            
        }
    }
    return parent;
}

void travel(struct node* now,int level)
{
    if(flag)
        return;
    if(now != NULL)
    {
        for(int i = 0; i < level; ++i)
        {
            printf("  ");
        }
        if(now->line != -1)
        {
            printf("%s",now->name);
            //ID & TYPE
            if((!strcmp(now->name,"ID")) || (!strcmp(now->name,"TYPE")))
            {
                printf(": %s",now->idtype);
            }
            //INT
            else if(!strcmp(now->name,"INT"))
            {
                printf(": %d",now->intval);
            }
            //FLOAT
            else if(!strcmp(now->name,"FLOAT"))
            {
                printf(": %f",now->flval);
            }
            //NUM
            else
            {
                printf(" (%d)",now->line);
            }
        }
        printf("\n");
        travel(now->left,level+1);
        travel(now->right,level);
    }
}

int match(char *num)
{
    char *ptr;
    if(strlen(num) > 2 && num[0] == '0' && (num[1] == 'x' || num[1] == 'X'))
    {
        return (int)strtol(num,&ptr,16);
    }
    else if(strlen(num) > 1 && num[0] == '0')
    {
        return (int)strtol(num,&ptr,8);
    }
    else
    {
        return atoi(num);
    }  
}

void yyerror(char *s,...)
{
    va_list ap;
    va_start(ap,s);
    //fprintf(stderr,"Error type B at line %d: Unexpected %s ",yylineno,yytext);
    //vfprintf(stderr,s,ap);
    //fprintf(stderr,"\n");
}

int main(int argc,char **args)
{
#ifdef DEBUG
    yydebug = 1;
#endif
    extern FILE *yyin;
	if(argc > 1 && (yyin = fopen(args[1], "r")) == NULL) {
		fprintf(stderr, "can not open %s\n", args[1]);
		exit(1);
	}
	if(yyparse()) {
		exit(-1);
	}
	
    return 0;
}



