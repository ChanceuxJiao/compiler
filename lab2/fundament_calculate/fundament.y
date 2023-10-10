%{
// 简单表达式计算
// basic：将所有的词法分析功能均放在yylex函数内实现
// 为+、-.*、\、(、)每个运算符及整数分别定义一个单词类别
// 在yylex内实现代码，能识别这些单词，并将单词类别返回给词法分析程序
// 可识别并忽略空格、制表符、回车等空白符
// 能识别多位十进制整数
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
%token LEFT_PAREN
%token RIGHT_PAREN
%token NUMBER

// 优先级和结合性
%left ADD MINUS
%left MUL DIV
%right UMINUS
%left LEFTPAR RIGHTPAR

%%

// rules：如何解析算术表达式
// 算术表达式之间用分号分隔
lines   :       lines expr ';' { printf("%f\n", $2); }
        |       lines ';'
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

// programs section

int yylex()
{
    int t;
    while(1){
        t = getchar();
        if(t==' '||t=='\t'||t=='\n'){
            // do nothing
        }
        else if(isdigit(t)){
            yylval = 0;
            while(isdigit(t)){
                // 词法单元的值存储在 yylval 中
                yylval = yylval * 10 + t - '0'; 
                t = getchar();
            }
            // 将刚刚读取的字符 t 推回标准输入流 stdin，以便它可以在后续的解析中被重新使用
            ungetc(t,stdin);
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
