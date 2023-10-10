%{
// 中缀表达式到后缀表达式的转换
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#include<string.h>
#ifndef YYSTYPE
#define YYSTYPE char*
#endif
extern YYSTYPE yylval; 
char numStr[100];
char idStr[100];
int yylex(); 
extern int yyparse(); 
FILE* yyin;
void yyerror(const char* s);

%}

// token 声明词法符号
%token ADD
%token MINUS
%token UMINUS
%token MUL
%token DIV
%token LEFT_PAREN
%token RIGHT_PAREN
%token NUMBER
%token IDENTITY

// 优先级和结合性
%left ADD MINUS
%left MUL DIV
%right UMINUS
%left LEFTPAR RIGHTPAR
%%



lines   :       lines expr ';' { printf("%s\n", $2); }   // 输出字符串
        |       lines ';'
        |
        ;
// 完善表达式规则
// $$代表产生式左部的属性值，$i代表产生式右部第i个文法符号的属性值

expr  :    expr ADD expr  { $$ = (char*)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$,$3); strcat($$,"+ "); }
      |    expr MINUS expr  { $$ = (char*)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$,$3); strcat($$,"- "); }
      |    expr MUL expr  { $$ = (char*)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$,$3); strcat($$,"* "); }
      |    expr DIV expr  { $$ = (char*)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$,$3); strcat($$,"/ "); }
      |    LEFT_PAREN expr RIGHT_PAREN   { $$ = $2; }
      |    MINUS  expr %prec UMINUS  { $$ = (char*)malloc(50*sizeof(char)); strcpy($$,"-"); strcat($$,$2); }
      |    NUMBER         { $$ = (char*)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$," "); }
      |    IDENTITY             { $$ = (char*)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$," "); }  // ID 的翻译模式执行动作就修改为将 $1 的值赋给 ID
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
            int countchar = 0;
            while(isdigit(t)){
                numStr[countchar++] = t;
                t = getchar();
            }
            numStr[countchar] = '\0';
            yylval = numStr;
            // 将刚刚读取的字符 t 推回标准输入流 stdin，以便它可以在后续的解析中被重新使用
            ungetc(t,stdin);
            return NUMBER;
        }
        else if ((isalpha(t))||(t == '_')){
            int countchar = 0;
            while((isalpha(t))||(t == '_')||isdigit(t)){
                idStr[countchar++] = t;
                t = getchar();
            }  
            idStr[countchar] = '\0';
            yylval = idStr;
            ungetc(t,stdin);
            return IDENTITY;

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
    yyin = stdin;
    do{
        yyparse();
    } while(!feof(yyin));
    return 0;
}
void yyerror(const char* s){
    fprintf(stderr, "Parse error: %s\n", s);
    exit(1);
}
