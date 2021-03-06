(* generated by ocamltarzan with: camlp4o -o /tmp/yyy.ml -I pa/ pa_type_conv.cmo pa_tof.cmo  pr_o.cmo /tmp/xxx.ml  *)

let tof_wrap =
  Ocaml.add_new_type "wrap" (Ocaml.Tuple [ Ocaml.Poly "a"; Ocaml.Var "tok" ])
and tof_tok = Ocaml.add_new_type "tok" (Ocaml.TTODO "")
  
let tof_name =
  Ocaml.add_new_type "name" (Ocaml.Apply (("wrap", Ocaml.String)))
  
let tof_qualified_name = Ocaml.add_new_type "qualified_name" Ocaml.String
  
let tof_resolved_name =
  Ocaml.add_new_type "resolved_name"
    (Ocaml.Sum
       [ ("Local", []); ("Param", []);
         ("Global", [ Ocaml.Var "qualified_name" ]); ("NotResolved", []) ])
  
let tof_special =
  Ocaml.add_new_type "special"
    (Ocaml.Sum
       [ ("Null", []); ("Undefined", []); ("This", []); ("Super", []);
         ("Exports", []); ("Module", []); ("New", []); ("NewTarget", []);
         ("Eval", []); ("Require", []); ("Seq", []); ("Void", []);
         ("Typeof", []); ("Instanceof", []); ("In", []); ("Delete", []);
         ("Spread", []); ("Yield", []); ("YieldStar", []); ("Await", []);
         ("Encaps", [ Ocaml.Option (Ocaml.Var "name") ]); ("UseStrict", []);
         ("And", []); ("Or", []); ("Not", []); ("Xor", []); ("BitNot", []);
         ("BitAnd", []); ("BitOr", []); ("BitXor", []); ("Lsr", []);
         ("Asr", []); ("Lsl", []); ("Equal", []); ("PhysEqual", []);
         ("Lower", []); ("Greater", []); ("Plus", []); ("Minus", []);
         ("Mul", []); ("Div", []); ("Mod", []); ("Expo", []);
         ("Incr", [ Ocaml.Bool ]); ("Decr", [ Ocaml.Bool ]) ])
  
let tof_label =
  Ocaml.add_new_type "label" (Ocaml.Apply (("wrap", Ocaml.String)))
  
let tof_filename =
  Ocaml.add_new_type "filename" (Ocaml.Apply (("wrap", Ocaml.String)))
  
let tof_property_prop =
  Ocaml.add_new_type "property_prop"
    (Ocaml.Sum
       [ ("Static", []); ("Public", []); ("Private", []); ("Protected", []) ])
and tof_property =
  Ocaml.add_new_type "property"
    (Ocaml.Sum
       [ ("Field",
          [ Ocaml.Var "property_name";
            Ocaml.List (Ocaml.Var "property_prop"); Ocaml.Var "expr" ]);
         ("FieldSpread", [ Ocaml.Var "expr" ]) ])
and tof_class_ =
  Ocaml.add_new_type "class_"
    (Ocaml.Dict
       [ ("c_extends", `RO, (Ocaml.Option (Ocaml.Var "expr")));
         ("c_body", `RO, (Ocaml.List (Ocaml.Var "property"))) ])
and tof_obj_ = Ocaml.add_new_type "obj_" (Ocaml.List (Ocaml.Var "property"))
and tof_fun_prop =
  Ocaml.add_new_type "fun_prop"
    (Ocaml.Sum [ ("Get", []); ("Set", []); ("Generator", []); ("Async", []) ])
and tof_parameter =
  Ocaml.add_new_type "parameter"
    (Ocaml.Dict
       [ ("p_name", `RO, (Ocaml.Var "name"));
         ("p_default", `RO, (Ocaml.Option (Ocaml.Var "expr")));
         ("p_dots", `RO, Ocaml.Bool) ])
and tof_fun_ =
  Ocaml.add_new_type "fun_"
    (Ocaml.Dict
       [ ("f_props", `RO, (Ocaml.List (Ocaml.Var "fun_prop")));
         ("f_params", `RO, (Ocaml.List (Ocaml.Var "parameter")));
         ("f_body", `RO, (Ocaml.Var "stmt")) ])
and tof_var_kind =
  Ocaml.add_new_type "var_kind"
    (Ocaml.Sum [ ("Var", []); ("Let", []); ("Const", []) ])
and tof_var =
  Ocaml.add_new_type "var"
    (Ocaml.Dict
       [ ("v_name", `RO, (Ocaml.Var "name"));
         ("v_kind", `RO, (Ocaml.Var "var_kind"));
         ("v_init", `RO, (Ocaml.Var "expr"));
         ("v_resolved", `RO,
          (Ocaml.Apply (("ref", (Ocaml.Var "resolved_name"))))) ])
and tof_var_or_expr = Ocaml.add_new_type "var_or_expr" (Ocaml.TTODO "")
and tof_vars_or_expr = Ocaml.add_new_type "vars_or_expr" (Ocaml.TTODO "")
and tof_case =
  Ocaml.add_new_type "case"
    (Ocaml.Sum
       [ ("Case", [ Ocaml.Var "expr"; Ocaml.Var "stmt" ]);
         ("Default", [ Ocaml.Var "stmt" ]) ])
and tof_for_header =
  Ocaml.add_new_type "for_header"
    (Ocaml.Sum
       [ ("ForClassic",
          [ Ocaml.Var "vars_or_expr"; Ocaml.Var "expr"; Ocaml.Var "expr" ]);
         ("ForIn", [ Ocaml.Var "var_or_expr"; Ocaml.Var "expr" ]);
         ("ForOf", [ Ocaml.Var "var_or_expr"; Ocaml.Var "expr" ]) ])
and tof_catch =
  Ocaml.add_new_type "catch"
    (Ocaml.Tuple [ Ocaml.Var "name"; Ocaml.Var "stmt" ])
and tof_stmt =
  Ocaml.add_new_type "stmt"
    (Ocaml.Sum
       [ ("VarDecl", [ Ocaml.Var "var" ]);
         ("Block", [ Ocaml.List (Ocaml.Var "stmt") ]);
         ("ExprStmt", [ Ocaml.Var "expr" ]);
         ("If", [ Ocaml.Var "expr"; Ocaml.Var "stmt"; Ocaml.Var "stmt" ]);
         ("Do", [ Ocaml.Var "stmt"; Ocaml.Var "expr" ]);
         ("While", [ Ocaml.Var "expr"; Ocaml.Var "stmt" ]);
         ("For", [ Ocaml.Var "for_header"; Ocaml.Var "stmt" ]);
         ("Switch", [ Ocaml.Var "expr"; Ocaml.List (Ocaml.Var "case") ]);
         ("Continue", [ Ocaml.Option (Ocaml.Var "label") ]);
         ("Break", [ Ocaml.Option (Ocaml.Var "label") ]);
         ("Return", [ Ocaml.Var "expr" ]);
         ("Label", [ Ocaml.Var "label"; Ocaml.Var "stmt" ]);
         ("Throw", [ Ocaml.Var "expr" ]);
         ("Try",
          [ Ocaml.Var "stmt"; Ocaml.Option (Ocaml.Var "catch");
            Ocaml.Option (Ocaml.Var "stmt") ]) ])
and tof_expr =
  Ocaml.add_new_type "expr"
    (Ocaml.Sum
       [ ("Bool", [ Ocaml.Apply (("wrap", Ocaml.Bool)) ]);
         ("Num", [ Ocaml.Apply (("wrap", Ocaml.String)) ]);
         ("String", [ Ocaml.Apply (("wrap", Ocaml.String)) ]);
         ("Regexp", [ Ocaml.Apply (("wrap", Ocaml.String)) ]);
         ("Id",
          [ Ocaml.Var "name";
            Ocaml.Apply (("ref", (Ocaml.Var "resolved_name"))) ]);
         ("IdSpecial", [ Ocaml.Apply (("wrap", (Ocaml.Var "special"))) ]);
         ("Nop", []); ("Assign", [ Ocaml.Var "expr"; Ocaml.Var "expr" ]);
         ("Obj", [ Ocaml.Var "obj_" ]); ("Class", [ Ocaml.Var "class_" ]);
         ("ObjAccess", [ Ocaml.Var "expr"; Ocaml.Var "property_name" ]);
         ("Arr", [ Ocaml.List (Ocaml.Var "expr") ]);
         ("ArrAccess", [ Ocaml.Var "expr"; Ocaml.Var "expr" ]);
         ("Fun", [ Ocaml.Var "fun_"; Ocaml.Option (Ocaml.Var "name") ]);
         ("Apply", [ Ocaml.Var "expr"; Ocaml.List (Ocaml.Var "expr") ]);
         ("Conditional",
          [ Ocaml.Var "expr"; Ocaml.Var "expr"; Ocaml.Var "expr" ]) ])
and tof_property_name =
  Ocaml.add_new_type "property_name"
    (Ocaml.Sum
       [ ("PN", [ Ocaml.Var "name" ]); ("PN_Computed", [ Ocaml.Var "expr" ]) ])
  
let tof_toplevel =
  Ocaml.add_new_type "toplevel"
    (Ocaml.Sum
       [ ("V", [ Ocaml.Var "var" ]);
         ("S", [ Ocaml.Var "tok"; Ocaml.Var "stmt" ]);
         ("Import",
          [ Ocaml.Var "name"; Ocaml.Var "name"; Ocaml.Var "filename" ]);
         ("Export", [ Ocaml.Var "name" ]) ])
  
let tof_program =
  Ocaml.add_new_type "program" (Ocaml.List (Ocaml.Var "toplevel"))
  
let tof_any =
  Ocaml.add_new_type "any"
    (Ocaml.Sum
       [ ("Expr", [ Ocaml.Var "expr" ]); ("Stmt", [ Ocaml.Var "stmt" ]);
         ("Top", [ Ocaml.Var "toplevel" ]);
         ("Program", [ Ocaml.Var "program" ]) ])
  
