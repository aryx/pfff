%{
(* Yoann Padioleau
 *
 * Copyright (C) 2010 Facebook
 * Copyright (C) 2011-2015 Tomohiro Matsuyama
 * Copyright (C) 2019 Yoann Padioleau
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation, with the
 * special exception on linking described in file license.txt.
 * 
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file
 * license.txt for more details.
 *)

(* This file contains a grammar for Python (2 and 3).
 *
 * original src: 
 *  https://github.com/m2ym/ocaml-pythonlib/blob/master/src/python2_parser.mly
 * old src: 
 *  - http://inst.eecs.berkeley.edu/~cs164/sp10/python-grammar.html
 *  - http://docs.python.org/release/2.5.2/ref/grammar.txt
 *)
open Common
open Ast_python

let singleton e = Left e
and tuple e = Right [e]
and cons e = function
  | Left e' -> Right (e::[e'])
  | Right l -> Right (e::l)
and tuple_expr = function
  | Left e -> e
  | Right l -> Tuple (l, Load)
and to_list = function
  | Left e -> [e]
  | Right l -> l

let rec set_expr_ctx ctx = function
  | Attribute (value, attr, _) ->
      Attribute (value, attr, ctx)
  | Subscript (value, slice, _) ->
      Subscript (value, slice, ctx)
  | Name (id, _) ->
      Name (id, ctx)
  | List (elts, _) ->
      List (List.map (set_expr_ctx ctx) elts, ctx)
  | Tuple (elts, _) ->
      Tuple (List.map (set_expr_ctx ctx) elts, ctx)
  | e -> e

let expr_store = set_expr_ctx Store
and expr_del = set_expr_ctx Del

let tuple_expr_store l =
  let e = tuple_expr l in
    match context_of_expr e with
    | Some Param -> e
    | _ -> expr_store e

%}

/*(*************************************************************************)*/
/*(*1 Tokens *)*/
/*(*************************************************************************)*/
%token <Ast_python.tok> TUnknown  /*(* unrecognized token *)*/
%token <Ast_python.tok> EOF

/*(*-----------------------------------------*)*/
/*(*2 The space/comment tokens *)*/
/*(*-----------------------------------------*)*/
/*(* coupling: Token_helpers.is_comment *)*/
%token <Ast_python.tok> TCommentSpace TComment

/*(*-----------------------------------------*)*/
/*(*2 The normal tokens *)*/
/*(*-----------------------------------------*)*/

/*(* tokens with "values" *)*/
%token <string * Ast_python.tok>   NAME
%token <int * Ast_python.tok>      INT LONGINT
%token <float * Ast_python.tok>    FLOAT
%token <string * Ast_python.tok>   IMAG
%token <string * Ast_python.tok>   STR

/*(*-----------------------------------------*)*/
/*(*2 Keyword tokens *)*/
/*(*-----------------------------------------*)*/
%token <Ast_python.tok> 
 IF ELIF ELSE
 WHILE FOR
 RETURN CONTINUE BREAK PASS
 DEF LAMBDA CLASS GLOBAL
 TRY FINALLY EXCEPT RAISE
 AND NOT OR
 PRINT EXEC ASSERT
 IMPORT FROM AS
 DEL IN IS WITH YIELD

/*(*-----------------------------------------*)*/
/*(*2 Punctuation tokens *)*/
/*(*-----------------------------------------*)*/
 
/*(* syntax *)*/
%token <Ast_python.tok> 
 LPAREN         /* ( */ RPAREN         /* ) */
 LBRACK         /* [ */ RBRACK         /* ] */
 LBRACE         /* { */ RBRACE         /* } */
 COLON          /* : */
 SEMICOL        /* ; */
 DOT            /* . */
 COMMA          /* , */
 BACKQUOTE      /* ` */
 AT             /* @ */

/*(* operators *)*/
%token <Ast_python.tok> 
  ADD            /* + */  SUB            /* - */
  MULT           /* * */  DIV            /* / */
  MOD            /* % */
  POW            /* ** */  FDIV           /* // */
  BITOR          /* | */  BITAND         /* & */  BITXOR         /* ^ */
  BITNOT         /* ~ */  LSHIFT         /* << */  RSHIFT         /* >> */

%token <Ast_python.tok> 
  EQ             /* = */
  ADDEQ          /* += */ SUBEQ          /* -= */
  MULTEQ         /* *= */ DIVEQ          /* /= */
  MODEQ          /* %= */
  POWEQ          /* **= */ FDIVEQ         /* //= */
  ANDEQ          /* &= */ OREQ           /* |= */ XOREQ          /* ^= */
  LSHEQ          /* <<= */ RSHEQ          /* >>= */

  EQUAL          /* == */ NOTEQ          /* !=, <> */
  LT             /* < */ GT             /* > */
  LEQ            /* <= */ GEQ            /* >= */

/*(*-----------------------------------------*)*/
/*(*2 Extra tokens: *)*/
/*(*-----------------------------------------*)*/

/* layout */
%token INDENT DEDENT 
%token NEWLINE

/*(*************************************************************************)*/
/*(*1 Priorities *)*/
/*(*************************************************************************)*/

/*(*************************************************************************)*/
/*(*1 Rules type declaration *)*/
/*(*************************************************************************)*/

%start main
%type <Ast_python.program> main

%%

/*(*************************************************************************)*/
/*(*1 Toplevel *)*/
/*(*************************************************************************)*/

main: file_input { $1 }

file_input:
  | nl_stmt_list EOF
      { Module ($1) }

/*(*************************************************************************)*/
/*(*1 Namespace *)*/
/*(*************************************************************************)*/

/*(*----------------------------*)*/
/*(*2 import *)*/
/*(*----------------------------*)*/

import_stmt:
  | import_name { $1 }
  | import_from { $1 }

import_name:
  | IMPORT dotted_as_names { Import ($2) }

import_from:
  | FROM name_and_level IMPORT MULT
      { ImportFrom (fst $2, ["*", None], snd $2) }
  | FROM name_and_level IMPORT LPAREN import_as_names RPAREN
      { ImportFrom (fst $2, $5, snd $2) }
  | FROM name_and_level IMPORT import_as_names
      { ImportFrom (fst $2, $4, snd $2) }

name_and_level:
  | dotted_name { $1, Some 0 }
  | dot_level dotted_name { $2, Some $1 }
  | DOT dot_level { "", Some (1 + $2) }

dot_level:
  | { 0 }
  | DOT dot_level { 1 + $2 }

import_as_name:
  | name { $1, None }
  | name AS name { $1, Some $3 }

dotted_as_name:
  | dotted_name { $1, None }
  | dotted_name AS name { $1, Some $3 }

import_as_names:
  | import_as_name { [$1] }
  | import_as_name COMMA { [$1] }
  | import_as_name COMMA import_as_names { $1::$3 }

dotted_as_names:
  | dotted_as_name { [$1] }
  | dotted_as_name COMMA dotted_as_names { $1::$3 }

dotted_name:
  | name { $1 }
  | name DOT dotted_name { $1 ^ "." ^ $3 }

/*(*----------------------------*)*/
/*(*2 export *)*/
/*(*----------------------------*)*/

/*(*************************************************************************)*/
/*(*1 Variable declaration *)*/
/*(*************************************************************************)*/

/*(*************************************************************************)*/
/*(*1 Function definition *)*/
/*(*************************************************************************)*/

funcdef:
  | decorators DEF name parameters COLON suite
      { FunctionDef ($3, $4, $6, $1) }

/*(*----------------------------*)*/
/*(*2 parameters *)*/
/*(*----------------------------*)*/

parameters:
  | LPAREN varargslist RPAREN { $2 }

varargslist:
  | { [], None, None, [] }
  | fpdef { [$1], None, None, [] }
  | fpdef COMMA varargslist
      { match $3 with
        | args, varargs, kwargs, defaults  ->
            $1::args, varargs, kwargs, defaults }
  | fpdef EQ test
      {
        (* TODO check default arguments come after
           variable arguments with semantic analysis. *)
        [$1], None, None, [$3] }
  | fpdef EQ test COMMA varargslist
      { match $5 with
        | args, varargs, kwargs, defaults  ->
            $1::args, varargs, kwargs, $3::defaults }
  | fpvarargs
      { [], fst $1, snd $1, [] }

fpdef:
  | NAME { Name (fst $1, Param) }
  | LPAREN fplist RPAREN { tuple_expr_store $2 }

fplist:
  | fpdef { singleton $1 }
  | fpdef COMMA { tuple $1 }
  | fpdef COMMA fplist { cons $1 $3 }

fpvarargs:
  | MULT name { Some $2, None }
  | MULT name COMMA fpkwargs { Some $2, $4 }
  | fpkwargs { None, $1 }

fpkwargs:
  | POW name { Some $2 }

/*(*************************************************************************)*/
/*(*1 Class definition *)*/
/*(*************************************************************************)*/

classdef:
  | decorators CLASS name COLON suite { ClassDef ($3, [], $5, $1) }
  | decorators CLASS name LPAREN RPAREN COLON suite { ClassDef ($3, [], $7, $1) }
  | decorators CLASS name LPAREN testlist RPAREN COLON suite { ClassDef ($3, to_list $5, $8, $1) }

/*(*----------------------------*)*/
/*(*2 Class elements *)*/
/*(*----------------------------*)*/

/*(*----------------------------*)*/
/*(*2 Method definition *)*/
/*(*----------------------------*)*/

/*(*************************************************************************)*/
/*(*1 Type declaration *)*/
/*(*************************************************************************)*/

/*(*************************************************************************)*/
/*(*1 Types *)*/
/*(*************************************************************************)*/

/*(*************************************************************************)*/
/*(*1 Annotations *)*/
/*(*************************************************************************)*/

decorator:
  | AT decorator_expr NEWLINE { $2 }

decorator_name:
  | atom_name { $1 }
  | atom_name DOT NAME { Attribute ($1, fst $3, Load) }

decorator_expr:
  | decorator_name { $1 }
  | decorator_name LPAREN RPAREN { Call ($1, [], [], None, None) }
  | decorator_name LPAREN arglist RPAREN
      { match $3 with
        | args, keywords, starargs, kwargs ->
            Call ($1, args, keywords, starargs, kwargs) }

decorators:
  | { [] }
  | decorator decorators { $1::$2 }

/*(*************************************************************************)*/
/*(*1 Statement *)*/
/*(*************************************************************************)*/

stmt:
  | simple_stmt { $1 }
  | compound_stmt { [$1] }

stmt_list:
  | { [] }
  | stmt stmt_list { $1 @ $2 }

nl_stmt_list:
  | { [] }
  | NEWLINE nl_stmt_list { $2 }
  | stmt nl_stmt_list { $1 @ $2 }

simple_stmt:
  | small_stmt NEWLINE { [$1] }
  | small_stmt SEMICOL NEWLINE { [$1] }
  | small_stmt SEMICOL simple_stmt { $1::$3 }

small_stmt:
  | expr_stmt   { $1 }
  | print_stmt  { $1 }
  | del_stmt    { $1 }
  | pass_stmt   { $1 }
  | flow_stmt   { $1 }
  | import_stmt { $1 }
  | global_stmt { $1 }
  | exec_stmt   { $1 }
  | assert_stmt { $1 }

expr_stmt:
  | expr_stmt_lhs EQ expr_stmt_rhs_list { Assign ($1::(fst $3), snd $3) }
  | expr_stmt_lhs augassign expr_stmt_rhs { AugAssign ($1, fst $2, $3) }
  | testlist_expr { ExprStmt ($1) }
      
expr_stmt_lhs:
  | testlist { tuple_expr_store $1 }

expr_stmt_rhs:
  | yield_expr { $1 }
  | testlist_expr { $1 }

expr_stmt_rhs_list:
  | expr_stmt_rhs { [], $1 }
  | expr_stmt_lhs EQ expr_stmt_rhs_list { $1::(fst $3), snd $3 }

augassign:
  | ADDEQ   { Add, $1 }
  | SUBEQ   { Sub, $1 }
  | MULTEQ  { Mult, $1 }
  | DIVEQ   { Div, $1 }
  | POWEQ   { Pow, $1 }
  | MODEQ   { Mod, $1 }
  | LSHEQ   { LShift, $1 }
  | RSHEQ   { RShift, $1 }
  | OREQ    { BitOr, $1 }
  | XOREQ   { BitXor, $1 }
  | ANDEQ   { BitAnd, $1 }
  | FDIVEQ  { FloorDiv, $1 }

print_stmt:
  | PRINT
      { (* TODO "from __future__ import print_function" *)
        Print (None, [], true) }
  | PRINT test print_testlist { Print (None, $2::(fst $3), snd $3) }
  | PRINT RSHIFT test { Print (Some $3, [], true) }
  | PRINT RSHIFT test COMMA test print_testlist { Print (Some $3, $5::(fst $6), snd $6) }

print_testlist:
  | { [], true }
  | COMMA test COMMA { [$2], false }
  | COMMA test print_testlist { $2::(fst $3), snd $3 }

del_stmt:
  | DEL exprlist { Delete (List.map expr_del (to_list $2)) }

pass_stmt:
  | PASS { Pass }

flow_stmt:
  | break_stmt    { $1 }
  | continue_stmt { $1 }
  | return_stmt   { $1 }
  | raise_stmt    { $1 }
  | yield_stmt    { $1 }

break_stmt:
  | BREAK { Break  }

continue_stmt:
  | CONTINUE { Continue }

return_stmt:
  | RETURN { Return (None) }
  | RETURN testlist { Return (Some (tuple_expr $2)) }

yield_stmt:
  | yield_expr { ExprStmt ($1) }

raise_stmt:
  | RAISE { Raise (None, None, None) }
  | RAISE test { Raise (Some $2, None, None) }
  | RAISE test COMMA test { Raise (Some $2, Some $4, None) }
  | RAISE test COMMA test COMMA test { Raise (Some $2, Some $4, Some $6) }

global_stmt:
  | GLOBAL name_list { Global ($2) }

name_list:
  | name { [$1] }
  | name COMMA name_list { $1::$3 }

exec_stmt:
  | EXEC expr { Exec ($2, None, None) }
  | EXEC expr IN test { Exec ($2, Some $4, None) }
  | EXEC expr IN test COMMA test { Exec ($2, Some $4, Some $6) }

assert_stmt:
  | ASSERT test { Assert ($2, None) }
  | ASSERT test COMMA test { Assert ($2, Some $4) }

compound_stmt:
  | if_stmt     { $1 }
  | while_stmt  { $1 }
  | for_stmt    { $1 }
  | try_stmt    { $1 }
  | with_stmt   { $1 }
  | funcdef     { $1 }
  | classdef    { $1 }

if_stmt:
  | IF test COLON suite elif_stmt_list { If ($2, $4, $5) }

elif_stmt_list:
  | { [] }
  | ELIF test COLON suite elif_stmt_list { [If ($2, $4, $5)] }
  | ELSE COLON suite { $3 }

while_stmt:
  | WHILE test COLON suite { While ($2, $4, []) }
  | WHILE test COLON suite ELSE COLON suite { While ($2, $4, $7) }

for_stmt:
  | FOR exprlist IN testlist COLON suite
      { For (tuple_expr_store $2, tuple_expr $4, $6, []) }
  | FOR exprlist IN testlist COLON suite ELSE COLON suite
      { For (tuple_expr_store $2, tuple_expr $4, $6, $9) }

try_stmt:
  | TRY COLON suite excepthandler_list
      { TryExcept ($3, $4, []) }
  | TRY COLON suite excepthandler_list ELSE COLON suite
      { TryExcept ($3, $4, $7) }
  | TRY COLON suite excepthandler_list ELSE COLON suite FINALLY COLON suite
      { TryFinally ([TryExcept ($3, $4, $7)], $10) }
  | TRY COLON suite excepthandler_list FINALLY COLON suite
      { TryFinally ([TryExcept ($3, $4, [])], $7) }
  | TRY COLON suite FINALLY COLON suite
      { TryFinally ($3, $6) }

excepthandler:
  | EXCEPT COLON suite { ExceptHandler (None, None, $3) }
  | EXCEPT test COLON suite { ExceptHandler (Some $2, None, $4) }
  | EXCEPT test AS test COLON suite { ExceptHandler (Some $2, Some $4, $6) }
  | EXCEPT test COMMA test COLON suite { ExceptHandler (Some $2, Some (expr_store $4), $6) }

excepthandler_list:
  | excepthandler { [$1] }
  | excepthandler excepthandler_list { $1::$2 }

with_stmt:
  | WITH test COLON suite { With ($2, None, $4) }
  | WITH test AS expr COLON suite { With ($2, Some $4, $6) }

suite:
  | simple_stmt { $1 }
  | NEWLINE INDENT stmt_list DEDENT { $3 }

/*(*----------------------------*)*/
/*(*2 auxillary statements *)*/
/*(*----------------------------*)*/

/*(*************************************************************************)*/
/*(*1 Expressions *)*/
/*(*************************************************************************)*/

expr:
  | xor_expr { $1 }
  | expr BITOR xor_expr{ BinOp ($1, BitOr, $3) }

xor_expr:
  | and_expr { $1 }
  | xor_expr BITXOR and_expr { BinOp ($1, BitXor, $3) }

and_expr:
  | shift_expr { $1 }
  | shift_expr BITAND and_expr { BinOp ($1, BitAnd, $3) }

shift_expr:
  | arith_expr { $1 }
  | shift_expr LSHIFT arith_expr { BinOp ($1, LShift, $3) }
  | shift_expr RSHIFT arith_expr { BinOp ($1, RShift, $3) }

arith_expr:
  | term { $1 }
  | arith_expr ADD term { BinOp ($1, Add, $3) }
  | arith_expr SUB term { BinOp ($1, Sub, $3) }

term:
  | factor { $1 }
  | factor term_op term { BinOp ($1, fst $2, $3) }

term_op:
  | MULT    { Mult, $1 }
  | DIV     { Div, $1 }
  | MOD     { Mod, $1 }
  | FDIV    { FloorDiv, $1 }

factor:
  | ADD factor { UnaryOp (UAdd, $2) }
  | SUB factor
      { (* CPython converts
             UnaryOp (op=Sub (), operand=Num (n=x))
           to
             Num (n=-x)
           if possible. *)
        match $2 with
        | Num (Int (n))        -> Num (Int (-n))
        | Num (LongInt (n))    -> Num (LongInt (-n))
        | Num (Float (n))      -> Num (Float (-.n))
        | Num (Imag (n))       -> Num (Imag ("-" ^ n))
        | _                       -> UnaryOp (USub, $2) }
  | BITNOT factor { UnaryOp (Invert, $2) }
  | power { $1 }

power:
  | atom_trailer { $1 }
  | atom_trailer POW factor { BinOp ($1, Pow, $3) }

atom_trailer:
  | atom { $1 }
  | atom_trailer LPAREN RPAREN { Call ($1, [], [], None, None) }
  | atom_trailer LPAREN arglist RPAREN
      { match $3 with
        | args, keywords, starargs, kwargs ->
            Call ($1, args, keywords, starargs, kwargs) }
  | atom_trailer LBRACK subscriptlist RBRACK
      { match $3 with
          (* TODO test* => Index (Tuple (elts)) *)
        | [s] -> Subscript ($1, s, Load)
        | l -> Subscript ($1, ExtSlice (l), Load) }
  | atom_trailer DOT NAME { Attribute ($1, fst $3, Load) }

atom:
  | atom_tuple  { $1 }
  | atom_list   { $1 }
  | atom_dict   { $1 }
  | atom_repr   { $1 }
  | atom_name   { $1 }
  | INT         { Num (Int (fst $1)) }
  | LONGINT     { Num (LongInt (fst $1)) }
  | FLOAT       { Num (Float (fst $1)) }
  | IMAG        { Num (Imag (fst $1)) }
  | string_list { Str (String.concat "" (fst $1)) }

atom_tuple:
  | LPAREN RPAREN { Tuple ([], Load) }
  | LPAREN yield_expr RPAREN { $2 }
  | LPAREN test gen_for RPAREN { GeneratorExp ($2, $3) }
  | LPAREN testlist RPAREN { tuple_expr $2 }

atom_list:
  | LBRACK RBRACK { List ([], Load) }
  | LBRACK test list_for RBRACK { ListComp ($2, $3) }
  | LBRACK testlist RBRACK { List (to_list $2, Load) }

atom_dict:
  | LBRACE RBRACE { Dict ([], []) }
  | LBRACE dictmaker RBRACE { Dict (fst $2, snd $2) }

atom_repr:
  | BACKQUOTE testlist1 BACKQUOTE { Repr (tuple_expr $2) }

atom_name:
  | NAME { Name (fst $1, Load) }

dictmaker:
  | test COLON test { [$1], [$3] }
  | test COLON test COMMA { [$1], [$3] }
  | test COLON test COMMA dictmaker { $1::(fst $5), $3::(snd $5) }

string_list:
  | STR { ([fst $1], snd $1) }
  | STR string_list { (fst $1::fst $2, snd $1) }

lambdadef:
  | LAMBDA varargslist COLON test { Lambda ($2, $4) }

subscriptlist:
  | subscript { [$1] }
  | subscript COMMA { [$1] }
  | subscript COMMA subscriptlist { $1::$3 }

subscript:
  | DOT DOT DOT { Ellipsis }
  | test { Index ($1) }
  | test_opt COLON test_opt { Slice ($1, $3, None) }
  | test_opt COLON test_opt COLON test_opt { Slice ($1, $3, $5) }

exprlist:
  | expr { singleton $1 }
  | expr COMMA { tuple $1 }
  | expr COMMA exprlist { cons $1 $3 }

testlist:
  | test { singleton $1 }
  | test COMMA { tuple $1 }
  | test COMMA testlist { cons $1 $3 }

testlist_expr:
  | testlist { tuple_expr $1 }

list_for:
  | list_for1 { [$1] }
  | list_for1 list_for { $1::$2 }

list_for1:
  | FOR exprlist IN testlist_safe list_if_list { tuple_expr_store $2, tuple_expr $4, $5 }

list_if:
  | IF old_test { $2 }

list_if_list:
  | { [] }
  | list_if list_if_list { $1::$2 }

gen_for:
  | gen_for1 { [$1] }
  | gen_for1 gen_for { $1::$2 }

gen_for1:
  | FOR exprlist IN or_test gen_if_list { tuple_expr_store $2, $4, $5 }

gen_if:
  | IF old_test { $2 }

gen_if_list:
  | { [] }
  | gen_if gen_if_list { $1::$2 }

testlist1:
  | test { singleton $1 }
  | test COMMA testlist1 { cons $1 $3 }

yield_expr:
  | YIELD { Yield (None) }
  | YIELD testlist_expr { Yield (Some $2) }


testlist_safe:
  | old_test { singleton $1 }
  | old_test COMMA { tuple $1 }
  | old_test COMMA testlist_safe { cons $1 $3 }

old_test:
  | or_test { $1 }
  | old_lambdadef { $1 }

old_lambdadef:
  | LAMBDA varargslist COLON old_test { Lambda ($2, $4) }

test:
  | or_test { $1 }
  | or_test IF or_test ELSE test { IfExp ($3, $1, $5) }
  | lambdadef { $1 }

test_opt:
  | { None }
  | test { Some $1 }

or_test:
  | and_test { $1 }
  | and_test OR and_test_list { BoolOp (Or, $1::$3) }

and_test:
  | not_test { $1 }
  | not_test AND not_test_list { BoolOp (And, $1::$3) }

and_test_list:
  | and_test { [$1] }
  | and_test OR and_test_list { $1::$3 }

not_test:
  | NOT not_test { UnaryOp (Not, $2) }
  | comparison { $1 }

not_test_list:
  | not_test { [$1] }
  | not_test AND not_test_list { $1::$3 }

comparison:
  | expr { $1 }
  | expr comp_op comparison_list { Compare ($1, (fst $2)::(fst $3), snd $3) }

comparison_list:
  | expr { [], [$1] }
  | expr comp_op comparison_list { (fst $2)::(fst $3), $1::(snd $3) }

comp_op:
  | EQUAL   { Eq, $1 }
  | NOTEQ   { NotEq, $1 }
  | LT      { Lt, $1 }
  | LEQ     { LtE, $1 }
  | GT      { Gt, $1 }
  | GEQ     { GtE, $1 }
  | IS      { Is, $1 }
  | IS NOT  { IsNot, $1 }
  | IN      { In, $1 }
  | NOT IN  { NotIn, $1 }


/*(*----------------------------*)*/
/*(*2 scalar *)*/
/*(*----------------------------*)*/

/*(*----------------------------*)*/
/*(*2 array *)*/
/*(*----------------------------*)*/

/*(*----------------------------*)*/
/*(*2 function call and arguments *)*/
/*(*----------------------------*)*/

arglist:
  | argument { [$1], [], None, None }
  | argument COMMA { [$1], [], None, None }
  | argument COMMA arglist
      { match $3 with
        | args, keywords, starargs, kwargs ->
            $1::args, keywords, starargs, kwargs }
  | starargs { $1 }

argument:
  | test { $1 }
  | test gen_for { GeneratorExp ($1, $2) }

keyword:
  | test EQ test
      { match $1 with
        | Name (id, _) -> (id, $3)
        | _ -> raise Parsing.Parse_error }

starargs:
  | MULT test { [], [], Some $2, None }
  | MULT test COMMA keywords
      { match $4 with
        | args, keywords, _, kwargs ->
            args, keywords, Some $2, kwargs }
  | keywords { $1 }

keywords:
  | keyword { [], [$1], None, None }
  | keyword COMMA { [], [$1], None, None }
  | keyword COMMA keywords
      { match $3 with
        | args, keywords, starargs, kwargs ->
            args, $1::keywords, starargs, kwargs }
  | POW test { [], [], None, Some $2 }

/*(*----------------------------*)*/
/*(*2 interpolated strings *)*/
/*(*----------------------------*)*/

/*(*************************************************************************)*/
/*(*1 Entities, names *)*/
/*(*************************************************************************)*/

name:
  | NAME { fst $1 }

/*(*************************************************************************)*/
/*(*1 xxx_opt, xxx_list *)*/
/*(*************************************************************************)*/

