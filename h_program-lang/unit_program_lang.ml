open Common

open OUnit

open Dependencies_matrix_code
module E = Database_code
module G = Graph_code
module DM = Dependencies_matrix_code

(*****************************************************************************)
(* Helpers *)
(*****************************************************************************)

(*****************************************************************************)
(* Unit tests *)
(*****************************************************************************)

let unittest =
  "program_lang" >::: [
    "dm" >::: (
      let dm = {
          matrix = [|
            [| 0; 0; 0; 0|];
            [| 0; 0; 0; 0|];
            [| 0; 0; 0; 0|];
            [| 0; 0; 0; 0|];
          |];
          name_to_i = Common.hash_of_list [
            ("foo.ml", E.File), 0;
            ("a/x.ml", E.File), 1;
            ("a/y.ml", E.File), 2;
            ("bar.ml", E.File), 3;
          ];
          i_to_name = [|
            ("foo.ml", E.File);
            ("a/x.ml", E.File);
            ("a/y.ml", E.File);
            ("bar.ml", E.File);
           |];
          config = 
            Node ((".", E.Dir), [
              Node (("foo.ml", E.File), []);
              Node (("a", E.Dir), [
                Node (("a/x.ml", E.File), []);
                Node (("a/y.ml", E.File), []);
              ]);
              Node (("bar.ml", E.File), []);
            ]);
        } in
      [

        "dead columns" >:: (fun () ->

          ()
        );
        "internal helpers" >:: (fun () ->
          let arr = DM.parents_of_indexes dm in
          assert_equal arr
            [| [(".", E.Dir)];
               [(".", E.Dir); ("a", E.Dir); ];
               [(".", E.Dir); ("a", E.Dir); ];
               [(".", E.Dir)];
            |];
          assert_equal 
            (DM.distance_entity 0 1 arr) 1;
          assert_equal 
            (DM.distance_entity 1 2 arr) 0;
        );
      ]
    )
  ]
