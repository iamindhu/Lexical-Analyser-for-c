%option noyywrap

%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	int line_no  = 1;
	void return_print(char *token_type);
	void yyerror();
  int key = 0;
  int aop = 0;
  int ide = 0;
  int constants = 0;
  int osymbols = 0;
  int n = 0;

%}

%x COMMENT

alphabet [a-zA-Z]
digit [0-9]
alphabet_number {alphabet}|{digit}
all_characters [ -~]

identifier {alphabet}+{alphabet_number}*
invalid_identifier {digit}+{alphabet_number}*
integer_constant [0-9]+
float_constant "0"|{digit}*"."{digit}+
character_constant (\'{all_characters}\')|(\'\\[nftrbv]\')
string \"{all_characters}*\"


%%

"//".*		{
             FILE *fptr;
             fptr = fopen("output.txt", "a");
             fprintf(fptr,"comment at line %d \n", line_no);
             }
"/*"    { FILE *fptr;
          fptr = fopen("output.txt", "a");
          fprintf(fptr,"comment at line %d \n", line_no);
          BEGIN(COMMENT); }

<COMMENT>"*/" { BEGIN(INITIAL); }
<COMMENT>[^*\n]+
<COMMENT>"*"
<COMMENT>"\n" { line_no += 1; }
"#".*   { FILE *fptr;
          fptr = fopen("output.txt", "a");
          fprintf(fptr,"PREPROCESSOR DIRECTIVE at line %d \n", line_no);
           }

"char" {return_print("keyword_char"); key++;}
"int" {return_print("keyword_int"); key++;}
"float" {return_print("keyword_float"); key++;}
"double" {return_print("keyword_double"); key++;}
"if" {return_print("keyword_if");key++;}
"else" {return_print("keyword_else");key++;}
"for" {return_print("keyword_for");key++;}
"while" {return_print("keyword_while");key++;}
"continue" {return_print("keyword_continue");key++;}
"break" {return_print("keyword_break");key++;}
"void" {return_print("keyword_void");key++;}
"switch" {return_print("keyword_switch");key++;}
"case" {return_print("keyword_case");key++;}
"goto" {return_print("keyword_goto");key++;}
"return" {return_print("keyword_return");key++;}

"+" {return_print("arithmetic_operator_add");aop++;}
"-" {return_print("arithmetic_operator_subtract");aop++;}
"*" {return_print("arithmetic_operator_multiply");aop++;}
"/" {return_print("arithmetic_operator_divide");aop++;}
"++" {return_print("arithmetic_operator_increment");aop++;}
"--" {return_print("arithmetic_operator_decrement");aop++;}

"==" {return_print("relational_operator_equal");aop++;}
"!=" {return_print("relational_operator_not_equal");aop++;}
">" {return_print("relational_operator_greater_than");aop++;}
"<" {return_print("relational_operator_less_than");aop++;}
">=" {return_print("relational_operator_greater_than_or_equal");aop++;}
"<=" {return_print("relational_operator_less_than_or_equal");aop++;}

"&&" {return_print("logical_operator_and");aop++;}
"||" {return_print("logical_operator_or");aop++;}
"!" {return_print("logical_operator_not");aop++;}

"|" {return_print("bitwise_operator_or");aop++;}
"&" {return_print("bitwise_operator_and");aop++;}
"^" {return_print("bitwise_operator_xor");aop++;}
"<<" {return_print("bitwise_operator_binary_left_shift");aop++;}
">>" {return_print("bitwise_operator_binary_right_shift");aop++;}
"~" {return_print("bitwise_operator_binary_one's_complement");aop++;}

"=" {return_print("assignment_operator_equal");aop++;}
"+=" {return_print("assignment_operator_add_and_equal");aop++;}
"-=" {return_print("assignment_operator_subtract_and_equal");aop++;}
"/=" {return_print("assignment_operator_divide_and_equal");aop++;}
"%=" {return_print("assignment_operator_modulus_and_equal");aop++;}

"(" {return_print("left_parantheses");osymbols++;}
")" {return_print("right_parantheses");osymbols++;}
"[" {return_print("left_square_bracket");osymbols++;}
"]" {return_print("right_square_bracket");osymbols++;}
"{" {return_print("left_flower_bracket");osymbols++;}
"}" {return_print("right_flower_bracket");osymbols++;}
";" {return_print("semicolon");osymbols++;}
"," {return_print(",");osymbols++;}

{identifier} {return_print("identifier");ide++;}
{integer_constant} {return_print("integer_constant");constants++;}
{invalid_identifier} {return_print("INVALID IDENTIFIER!");}
{float_constant} {return_print("float_constant");constants++;}
{character_constant} {return_print("character_constant");constants++;}
{string} {return_print("string");constants++;}

"\n" {line_no = line_no + 1;}

[ \t\f\r]+

. {yyerror("UNRECOGNISED TOKEN!");}

%%

void return_print(char *token_type){
   FILE *fptr;
   fptr = fopen("output.txt", "a");
   fprintf(fptr,"yytext: %s \t token: %s \t line_no: %d\n", yytext, token_type, line_no);
}

void yyerror(char *message){
    FILE *fptr;
    fptr = fopen("output.txt", "a");
	  fprintf(fptr,"Error: \"%s\" in line %d. token=%s\n", message, line_no, yytext);

}

void total(){
FILE *p;
   p = fopen("output.txt", "a");
   n = n + key + ide + aop + osymbols + constants;
   fprintf(p,"\n Total no. of Keywords = %d\n", key);
   fprintf(p,"\n Total no. of Identifiers = %d\n", ide);
   fprintf(p,"\n Total no. of Operators = %d\n", aop);
   fprintf(p,"\n Total no. of Separators = %d\n", osymbols);
   fprintf(p,"\n Total no. of Constants = %d\n", constants);
   fprintf(p,"\n Total no. of Tokens = %d\n", n);
   fprintf(p,"-----------------------------------------------------\n\n");
   fclose(p);
}

int main(int argc, char *argv[]){
   FILE *fptr;
   fptr = fopen("output.txt", "w");
   fclose(fptr);
   yyin = fopen(argv[1], "r");
   yylex();
   fclose(yyin);
   total();
   return 0;
}
