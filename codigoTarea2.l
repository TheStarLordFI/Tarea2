%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
void error(char *s);
%}

%option yylineno
%option noyywrap
%s COMENTARIO
%x COMENTARIO2
letra [a-zA-Z]
digito [0-9]
id "#"({letra}|{digito})+
reservadas "@"(if|else|while)
opArm "/"|"+"|"-"|"*"|"%"
relacional (">"|"<")("=")?|"=="|"!="
asign "="
pip "||"
logico "&&"|{pip}|not
puntuacion "{"|"}"|"("|")"|","|";"
entero ({digito})+
real {digito}*"."{digito}+|{digito}+"."{digito}*
exp [eE][+-]?{entero}
flotante ({real}{exp}?|{entero}{exp})[Ff]

%%
{id}    {printf("Encontre el Identificador: %s\n", yytext);}
{reservadas}    {printf("Encontre la Palabra Reservada: %s\n", yytext);}
{opArm}     {printf("Encontre el Operador Aritmetico: %s\n", yytext);}
{relacional}     {printf("Encontre el Operador Relacional: %s\n", yytext);}
{asign}     {printf("Encontre el Operador de Asignacion: %s\n", yytext);}
{logico}     {printf("Encontre el Operador logico: %s\n", yytext);}
{puntuacion}     {printf("Encontre el Simbolo de Puntuacion: %s\n", yytext);}
{entero}    {printf("Encontre el entero: %s\n", yytext);}
{flotante}  {printf("Encontre el flotante: %s\n", yytext);}
<INITIAL>[ \t\n\r] {/* Se ignora los espacios en blanco*/}
<INITIAL>"/*" { BEGIN(COMENTARIO);}
<COMENTARIO>"*/" { printf("\n");
					BEGIN(INITIAL);}
<INITIAL>.  {error(yytext);}
%%

void error(char *s){
    printf("Error léxico: %s\n",s);
}

int main(int argc, char **argv){
    FILE *f;
    if(argc<2){
        printf("Falta archivo\n");
        exit(-1);
    }
    f = fopen(argv[1],"r");
    if(!f){
        printf("No se puede abrir el archivo\n");
        exit(-1);
    }
    yyin = f;
    yylex();
    return 0;
}
