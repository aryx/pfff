
(* generated by ocamltarzan with: camlp4o -o /tmp/yyy.ml -I pa/ pa_type_conv.cmo pa_vof.cmo  pr_o.cmo /tmp/xxx.ml  *)

open Ast_js

let rec vof_tok _v = 
 (* Parse_info.vof_info v *)
 Ocaml.VUnit

and vof_wrap _of_a (v1, v2) =
  let v1 = _of_a v1 
  and _v2 = vof_tok v2 in 
  (* Ocaml.VTuple [ v1; v2 ] *)
  v1
  
let vof_name v = vof_wrap Ocaml.vof_string v

let vof_resolved_name = function
  | Local -> Ocaml.VSum (("Local", []))
  | Param -> Ocaml.VSum (("Param", []))
  | NotResolved -> Ocaml.VSum (("NotResolved", []))
  | Global v1 -> 
      let v1 = Ocaml.vof_string v1 in
      Ocaml.VSum (("Global", [ v1 ]))
  
let vof_special =
  function
  | Null -> Ocaml.VSum (("Null", []))
  | Undefined -> Ocaml.VSum (("Undefined", []))
  | This -> Ocaml.VSum (("This", []))
  | Super -> Ocaml.VSum (("Super", []))
  | Require -> Ocaml.VSum (("Require", []))
  | Exports -> Ocaml.VSum (("Exports", []))
  | Module -> Ocaml.VSum (("Module", []))
  | New -> Ocaml.VSum (("New", []))
  | NewTarget -> Ocaml.VSum (("NewTarget", []))
  | Eval -> Ocaml.VSum (("Eval", []))
  | Seq -> Ocaml.VSum (("Seq", []))
  | Typeof -> Ocaml.VSum (("Typeof", []))
  | Instanceof -> Ocaml.VSum (("Instanceof", []))
  | In -> Ocaml.VSum (("In", []))
  | Delete -> Ocaml.VSum (("Delete", []))
  | Void -> Ocaml.VSum (("Void", []))
  | Spread -> Ocaml.VSum (("Spread", []))
  | Yield -> Ocaml.VSum (("Yield", []))
  | YieldStar -> Ocaml.VSum (("YieldStar", []))
  | Await -> Ocaml.VSum (("Await", []))
  | Encaps v1 ->
      let v1 = Ocaml.vof_option vof_name v1
      in Ocaml.VSum (("Encaps", [ v1 ]))
  | Not -> Ocaml.VSum (("Not", []))
  | And -> Ocaml.VSum (("And", []))
  | Or -> Ocaml.VSum (("Or", []))
  | Xor -> Ocaml.VSum (("Xor", []))
  | BitNot -> Ocaml.VSum (("BitNot", []))
  | BitAnd -> Ocaml.VSum (("BitAnd", []))
  | BitOr -> Ocaml.VSum (("BitOr", []))
  | BitXor -> Ocaml.VSum (("BitXor", []))
  | Lsr -> Ocaml.VSum (("Lsr", []))
  | Asr -> Ocaml.VSum (("Asr", []))
  | Lsl -> Ocaml.VSum (("Lsl", []))
  | Equal -> Ocaml.VSum (("Equal", []))
  | PhysEqual -> Ocaml.VSum (("PhysEqual", []))
  | Lower -> Ocaml.VSum (("Lower", []))
  | Greater -> Ocaml.VSum (("Greater", []))
  | Plus -> Ocaml.VSum (("Plus", []))
  | Minus -> Ocaml.VSum (("Minus", []))
  | Mul -> Ocaml.VSum (("Mul", []))
  | Div -> Ocaml.VSum (("Div", []))
  | Mod -> Ocaml.VSum (("Mod", []))
  | Expo -> Ocaml.VSum (("Expo", []))
  | Incr v1 -> let v1 = Ocaml.vof_bool v1 in Ocaml.VSum (("Incr", [ v1 ]))
  | Decr v1 -> let v1 = Ocaml.vof_bool v1 in Ocaml.VSum (("Decr", [ v1 ]))
  
let vof_label v = vof_wrap Ocaml.vof_string v
  
let vof_filename v = vof_wrap Ocaml.vof_string v
  
let rec vof_property_name =
  function
  | PN v1 -> let v1 = vof_name v1 in Ocaml.VSum (("PN", [ v1 ]))
  | PN_Computed v1 ->
      let v1 = vof_expr v1 in Ocaml.VSum (("PN_Computed", [ v1 ]))
and vof_expr =
  function
  | Arr v1 ->
     let v1 = Ocaml.vof_list vof_expr v1 in Ocaml.VSum (("Arr", [v1]))
  | Bool v1 ->
      let v1 = vof_wrap Ocaml.vof_bool v1 in Ocaml.VSum (("Bool", [ v1 ]))
  | Num v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1 in Ocaml.VSum (("Num", [ v1 ]))
  | String v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1
      in Ocaml.VSum (("String", [ v1 ]))
  | Regexp v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1
      in Ocaml.VSum (("Regexp", [ v1 ]))
  | Id (v1, v2) -> 
      let v1 = vof_name v1 in 
      let v2 = Ocaml.vof_ref vof_resolved_name v2 in
      Ocaml.VSum (("Id", [ v1; v2 ]))
  | IdSpecial v1 ->
      let v1 = vof_wrap vof_special v1 in Ocaml.VSum (("IdSpecial", [ v1 ]))
  | Nop -> Ocaml.VSum (("Nop", []))
  | Assign ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("Assign", [ v1; v2 ]))
  | ArrAccess ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("ArrAccess", [ v1; v2 ]))
  | Obj v1 -> let v1 = vof_obj_ v1 in Ocaml.VSum (("Obj", [ v1 ]))
  | Class v1 -> let v1 = vof_class_ v1 in Ocaml.VSum (("Class", [ v1 ]))
  | ObjAccess ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_property_name v2
      in Ocaml.VSum (("ObjAccess", [ v1; v2 ]))
  | Fun ((v1, v2)) ->
      let v1 = vof_fun_ v1
      and v2 = Ocaml.vof_option vof_name v2
      in Ocaml.VSum (("Fun", [ v1; v2 ]))
  | Apply ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = Ocaml.vof_list vof_expr v2
      in Ocaml.VSum (("Apply", [ v1; v2 ]))
  | Conditional ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_expr v2
      and v3 = vof_expr v3
      in Ocaml.VSum (("Conditional", [ v1; v2; v3 ]))
and vof_stmt =
  function
  | VarDecl v1 -> let v1 = vof_var v1 in Ocaml.VSum (("VarDecl", [ v1 ]))
  | Block v1 ->
      let v1 = Ocaml.vof_list vof_stmt v1 in Ocaml.VSum (("Block", [ v1 ]))
  | ExprStmt v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("ExprStmt", [ v1 ]))
  | If ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_stmt v2
      and v3 = vof_stmt v3
      in Ocaml.VSum (("If", [ v1; v2; v3 ]))
  | Do ((v1, v2)) ->
      let v1 = vof_stmt v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("Do", [ v1; v2 ]))
  | While ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_stmt v2
      in Ocaml.VSum (("While", [ v1; v2 ]))
  | For ((v1, v2)) ->
      let v1 = vof_for_header v1
      and v2 = vof_stmt v2
      in Ocaml.VSum (("For", [ v1; v2 ]))
  | Switch ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = Ocaml.vof_list vof_case v2
      in Ocaml.VSum (("Switch", [ v1; v2 ]))
  | Continue v1 ->
      let v1 = Ocaml.vof_option vof_label v1
      in Ocaml.VSum (("Continue", [ v1 ]))
  | Break v1 ->
      let v1 = Ocaml.vof_option vof_label v1
      in Ocaml.VSum (("Break", [ v1 ]))
  | Return v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("Return", [ v1 ]))
  | Label ((v1, v2)) ->
      let v1 = vof_label v1
      and v2 = vof_stmt v2
      in Ocaml.VSum (("Label", [ v1; v2 ]))
  | Throw v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("Throw", [ v1 ]))
  | Try ((v1, v2, v3)) ->
      let v1 = vof_stmt v1
      and v2 =
        Ocaml.vof_option
          (fun (v1, v2) ->
             let v1 = vof_wrap Ocaml.vof_string v1
             and v2 = vof_stmt v2
             in Ocaml.VTuple [ v1; v2 ])
          v2
      and v3 = Ocaml.vof_option vof_stmt v3
      in Ocaml.VSum (("Try", [ v1; v2; v3 ]))
and vof_for_header =
  function
  | ForClassic ((v1, v2, v3)) ->
      let v1 = Ocaml.vof_either (Ocaml.vof_list vof_var) vof_expr v1
      and v2 = vof_expr v2
      and v3 = vof_expr v3
      in Ocaml.VSum (("ForClassic", [ v1; v2; v3 ]))
  | ForIn ((v1, v2)) ->
      let v1 = Ocaml.vof_either vof_var vof_expr v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("ForIn", [ v1; v2 ]))
  | ForOf ((v1, v2)) ->
      let v1 = Ocaml.vof_either vof_var vof_expr v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("ForOf", [ v1; v2 ]))
and vof_case =
  function
  | Case ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_stmt v2
      in Ocaml.VSum (("Case", [ v1; v2 ]))
  | Default v1 -> let v1 = vof_stmt v1 in Ocaml.VSum (("Default", [ v1 ]))
and vof_var { v_name = v_v_name; 
              v_kind = v_v_kind; 
              v_init = v_v_init;
              v_resolved = v_v_resolved;
             } =
  let bnds = [] in
  let arg = Ocaml.vof_ref vof_resolved_name v_v_resolved in
  let bnd = ("v_resolved", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_expr v_v_init in
  let bnd = ("v_init", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_var_kind v_v_kind in
  let bnd = ("v_kind", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_name v_v_name in
  let bnd = ("v_name", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_var_kind =
  function
  | Var -> Ocaml.VSum (("Var", []))
  | Let -> Ocaml.VSum (("Let", []))
  | Const -> Ocaml.VSum (("Const", []))
and
  vof_fun_ { f_props = v_f_props; f_params = v_f_params; f_body = v_f_body }
           =
  let bnds = [] in
  let arg = vof_stmt v_f_body in
  let bnd = ("f_body", arg) in
  let bnds = bnd :: bnds in
  let arg = Ocaml.vof_list vof_parameter v_f_params in
  let bnd = ("f_params", arg) in
  let bnds = bnd :: bnds in
  let arg = Ocaml.vof_list vof_fun_prop v_f_props in
  let bnd = ("f_props", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and
  vof_parameter {
                  p_name = v_p_name;
                  p_default = v_p_default;
                  p_dots = v_p_dots
                } =
  let bnds = [] in
  let arg = Ocaml.vof_bool v_p_dots in
  let bnd = ("p_dots", arg) in
  let bnds = bnd :: bnds in
  let arg = Ocaml.vof_option vof_expr v_p_default in
  let bnd = ("p_default", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_name v_p_name in
  let bnd = ("p_name", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_fun_prop =
  function
  | Get -> Ocaml.VSum (("Get", []))
  | Set -> Ocaml.VSum (("Set", []))
  | Generator -> Ocaml.VSum (("Generator", []))
  | Async -> Ocaml.VSum (("Async", []))
and vof_obj_ v = Ocaml.vof_list vof_property v
and vof_class_ { c_extends = v_c_extends; c_body = v_c_body } =
  let bnds = [] in
  let arg = Ocaml.vof_list vof_property v_c_body in
  let bnd = ("c_body", arg) in
  let bnds = bnd :: bnds in
  let arg = Ocaml.vof_option vof_expr v_c_extends in
  let bnd = ("c_extends", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_property =
  function
  | Field ((v1, v2, v3)) ->
      let v1 = vof_property_name v1
      and v2 = Ocaml.vof_list vof_property_prop v2
      and v3 = vof_expr v3
      in Ocaml.VSum (("Field", [ v1; v2; v3 ]))
  | FieldSpread v1 ->
      let v1 = vof_expr v1 in Ocaml.VSum (("FieldSpread", [ v1 ]))
and vof_property_prop =
  function
  | Static -> Ocaml.VSum (("Static", []))
  | Public -> Ocaml.VSum (("Public", []))
  | Private -> Ocaml.VSum (("Private", []))
  | Protected -> Ocaml.VSum (("Protected", []))
  
let vof_toplevel =
  function
  | S (v1, v2) -> 
     let v1 = vof_tok v1 in let v2 = vof_stmt v2 in
     Ocaml.VSum (("S", [ v1; v2 ]))
  | V v1 ->
     let v1 = vof_var v1 in
     Ocaml.VSum (("V", [v1]))
  | Import ((v1, v2, v3)) ->
      let v1 = vof_name v1
      and v2 = vof_name v2
      and v3 = vof_filename v3
      in Ocaml.VSum (("Import", [ v1; v2; v3 ]))
  | Export ((v1)) ->
      let v1 = vof_name v1
      in Ocaml.VSum (("Export", [ v1 ]))
  
let vof_program v = Ocaml.vof_list vof_toplevel v
  
let vof_any =
  function
  | Expr v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("Expr", [ v1 ]))
  | Top v1 -> let v1 = vof_toplevel v1 in Ocaml.VSum (("Top", [ v1 ]))
  | Stmt v1 -> let v1 = vof_stmt v1 in Ocaml.VSum (("Stmt", [ v1 ]))
  | Program v1 -> let v1 = vof_program v1 in Ocaml.VSum (("Program", [ v1 ]))
