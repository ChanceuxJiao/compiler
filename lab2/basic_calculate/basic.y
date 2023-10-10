%{
// 简单表达式计算
// basic：将所有的词法分析功能均放在yylex函数内实现
// 为+、-.*、\、(、)每个运算符及整数分别定义一个单词类别
// 在yylex内实现代码，能识别这些单词，并将单词类别返回给词法分析程序

#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#ifndef YYSTYPE
// 定义 YYSTYPE 为 double，意味着yacc产生的值是双精度浮点数
#define YYSTYPE double
#endif
extern YYSTYPE yylval; 
int yylex(); // 自行定义yylex函数
extern int yyparse(); 
FILE* yyin;
void yyerror(const char* s);
%}

// token 声明词法符号
%token ADD
%token MINUS
%token MUL
%token DIV
%token UMINUS
%token LEFT_PAREN
%token RIGHT_PAREN
%token NUMBER

// 优先级和结合性
%left ADD MINUS
%left MUL DIV
%right UMINUS
%left LEFT_PAREN RIGHT_PAREN

%%

// rules：如何解析算术表达式
// 算术表达式之间用换行符分隔
lines   :       lines expr '\n' { printf("%f\n", $2); }
        |       lines '\n'
        |
        ;
// 完善表达式规则
// $$代表产生式左部的属性值，$i代表产生式右部第i个文法符号的属性值
expr    :       expr ADD expr   { $$ = $1 + $3; }
        |       expr MINUS expr   { $$ = $1 - $3; }
        |       expr MUL expr   { $$ = $1 * $3; }
        |       expr DIV expr   { $$ = $1 / $3; }
                // 提升优先级，优先级将会覆盖在普通方式下推断出来的该规则的优先级。
        |       MINUS expr %prec UMINUS   {$$ = - $2;} 
        |       LEFT_PAREN expr RIGHT_PAREN { $$ = $2; }
        |       NUMBER  {$$ = $1;}
        ;

%%

//词法分析


int yylex()
{
    int t;
    while(1){
        t = getchar();
        if(isdigit(t)){
            yylval = t-'0';
            return NUMBER;
        }
        else if(t=='+'){
            return ADD;
        }
        else if(t=='-'){
            return MINUS;
        }
        else if(t=='*'){
            return MUL;
        }
        else if(t=='/'){
            return DIV;
        }
        else if(t=='('){
            return LEFT_PAREN;
        }
        else if(t==')'){
            return RIGHT_PAREN;
        }
        else{
            return t;
        }
    }
}

int main(void)
{
    yyin=stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}
void yyerror(const char* s){
    fprintf(stderr,"Parse error: %s\n",s);
    exit(1);
}

