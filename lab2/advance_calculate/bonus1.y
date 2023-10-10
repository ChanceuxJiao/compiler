%{
/****************************************************************************
bonus.y
YACC file 
Date 2023/10/3
****************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>  //导入isdigit()函数
#include <string.h> 
#define NSYMS 20        /* maximum number of symbols */
struct symtab {
        char *name;
        double value;
}symtab[NSYMS];       //记录标识符名字和数值的符号表
/*
符号表用于存储标识符的名称和值（对于变量）。当遇到一个标识符时，它会首先在符号表中查找，如果找到则返回相应的值，否则将创建一个新的符号表条目来存储该标识符的信息。
这有助于实现对变量的赋值和使用，以及在表达式中计算标识符的值。符号表在解释器中的作用是跟踪和管理标识符的信息，以便正确地解释程序中的代码。
*/
struct symtab *symlook(char *s);
char idStr[50];
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

//属性值可能具有的类型
%union {
        double  dval;
        struct symtab *symp;
}

//%token
%token ADD      
%token MUL
%token DIV
%token LEFTPAR
%token RIGHTPAR
%token <dval> NUMBER //数字对应属性值
%token MINUS
%token UMINUS
%token equal
%token <symp> ID  //标识符对应属性值

//越往后优先级越高
%right equal
%left ADD MINUS
%left MUL DIV
%right UMINUS
%left LEFTPAR RIGHTPAR

//表达式的属性值设置为数值类型
%type <dval> expr

%%
lines	:	lines expr ';'	{ printf("%f\n", $2); }
		| lines ';'
		|
		;

expr	: expr ADD expr { $$ = $1 + $3; }
		| expr MINUS expr { $$ = $1 - $3; }
		| expr MUL expr { $$ = $1 * $3; }
		| expr DIV expr { $$ = $1 / $3; }
		| LEFTPAR expr RIGHTPAR { $$ = $2; }
		| MINUS expr %prec UMINUS { $$ = -$2; }
		| NUMBER { $$ = $1; }
		| ID equal expr { $1->value=$3; $$=$3;}
		| ID {$$=$1->value;}  
		;



%%

//词法分析器.读取输入流，识别并返回词法单元或token
int yylex()
{
	int t;

	while (1)
	{
		t = getchar();
		if (t == ' ' || t == '\n' || t == '\t') { ; }
		else if (isdigit(t))//识别多位数字
		{
			yylval.dval = 0;//属性值，在此处即指对应的数值
			while (isdigit(t))
			{
				yylval.dval = yylval.dval * 10 + t - '0';
				t = getchar();
			}
			ungetc(t, stdin);
			
			return NUMBER;
		}
		else if ((t>='a'&&t<='z')||(t>='A'&&t<='Z')||(t=='_'))//识别标识符
		{
			int countchar=0;//字符数计数器
			while ((t>='a'&&t<='z')||(t>='A'&&t<='Z')||(t=='_')||(t>='0'&&t<='9'))
			{
				idStr[countchar]=t;
				t = getchar();
				countchar++;
			}
			idStr[countchar]='\0';

			char* temp = (char*)malloc (50*sizeof(char)); 
			strcpy(temp,idStr);
			yylval.symp=symlook(temp); 

			ungetc(t, stdin);
			
			return ID;
		}
		else if (t == '-')
		{
		        return MINUS;

		} 
		else if (t == '(')
		{
			
			return LEFTPAR;
		}
		else if(t == ';')
		{
			 
			return t;
		}
        else if (t == '=')
		{
			
			return equal;
		}
		else
		{
			
			if (t == '+') return ADD;
			else if (t == '*') return MUL;
			else if (t == '/') return DIV;
			else if (t == ')') return RIGHTPAR;
			else return t;
		}
	}
}


// 符号表查找程序
// 返回一个符号表的表项
struct symtab* symlook(char *s){
    char *p;
    struct symtab *sp;
	// 遍历符号表中每一个表项
    for(sp=symtab;sp<&symtab[NSYMS];sp++){
		// 如果找到了表中存在这一项，返回指向该表项的指针
        if(sp->name && !strcmp(sp->name,s))
            return sp;
		// 如果找不到这一项，那就新建一个表项，strdup函数用于拷贝字符串
        if(!sp->name){
            sp->name=strdup(s);
            return sp;
            }
        }
        yyerror("Wrong input");
        exit(1);
}



int main()
{
	yyin = stdin;
	do {
		yyparse();
	} while (!feof(yyin));
	return 0;
}
void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}

