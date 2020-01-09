extern int yylineno;
extern char * yytext;
extern int yyparse();
extern int flag;
#ifdef DEBUG
extern int yydebug;
#endif

void yyerror(char *msg,...);

struct node
{
    //line num
    int line;
    char *name;
    struct node *left;
    struct node *right;
    //store data
    union
    {
        char *idtype;
        int intval;
        float flval;
    };
};

//establish new tree
struct node *newtree(char *name,int num,...);

//Search the grammer tree
void travel(struct node* now,int level);

//match oct dec hex
int match(char * num);