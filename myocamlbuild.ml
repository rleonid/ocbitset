open Ocamlbuild_plugin

let () =
  let additional_rules = function
    | After_rules ->

      (* Rules to build the library, generate stubs *)
      rule "cstubs: src/lib/x_bindings.ml -> x_stubs.c, x_stubs.ml"
        ~prods:["src/lib/%_stubs.c"; "src/lib/%_generated.ml"]
        ~deps: ["src/lib_gen/%_bindgen.byte"]
        (fun env build ->
          Cmd (A(env "src/lib_gen/%_bindgen.byte")));
      copy_rule "cstubs: src/lib_gen/x_bindings.ml -> src/lib/x_bindings.ml"
        "src/lib_gen/%_bindings.ml" "src/lib/%_bindings.ml";

      (* Add cbitset sources. *)
      dep ["c"; "compile"]
          [ "src/lib/cbitset/src/bitset.c"
          ; "src/lib/cbitset/include/bitset.h" 
          ; "src/lib/cbitset/include/portability.h" 
          ];

      (* How to compile C *)
      flag ["compile";"c"]
        (S [ (* necessary for OCamlbuild versions < 0.9 ie the 4.02.3 *)
             A"-I"; A"src/lib"
           ; A"-I"; A"src/lib/cbitset/include"
           ; A"-ccopt"; A"-fPIC"
           ; A"-ccopt"; A"-std=c99"
           ; A"-ccopt"; A"-O3"
           ; A"-ccopt"; A"-march=native"
           (*; A"-ccopt"; A"-Wall" *)
           (*; A"-ccopt"; A"-Wextra"*)
           ; A"-ccopt"; A"-Wshadow"
           (*; A"-ccopt"; A"-Wunused-parameter"*)

           ; A"-package"; A"ctypes,ctypes.foreign,ctypes.stubs"]);

      (* Set linking commands. *)
      flag ["native"; "library"; "link"; "ocaml"; "use_cbitset_stubs" ]
        (S [ A"-cclib"; A"-lcbitset_stubs"; ]);
      flag ["byte";   "library"; "link"; "ocaml"; "use_cbitset_stubs" ]
        (S [ A"-cclib"; A"-lcbitset_stubs"; A"-dllib"; A"-lcbitset_stubs"; ]);

        (*
      (* For test.byte *)
      flag ["byte"; "program"; "link"; "ocaml"; "use_cbitset_stubs" ]
        (S [ A"-custom"; A"-ccopt"; A"-Lsrc/lib"; A"-cclib"; A"-lcbitset_stubs" ]);

      (* For test.native *)
      flag ["native"; "program"; "link"; "ocaml"; "use_cbitset_stubs" ]
        (S [             A"-ccopt"; A"-Lsrc/lib"; A"-cclib"; A"-lcbitset_stubs" ]);
        *)

    | Before_hygiene  -> ()
    | After_hygiene   -> ()
    | Before_options  -> ()
    | After_options   -> ()
    | Before_rules    -> ()
  in
  dispatch additional_rules
