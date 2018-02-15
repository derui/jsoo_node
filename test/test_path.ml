open Mocha_of_ocaml
module J = Jsoo_node

let suite () =
  "NodeJS path module" >::: [
    "should be able to use resolve" >:: (fun () ->
        let path = J.path () in
        let v = path##resolve Js.(array [|Js.string "."; Js.string ".git"; Js.string "objects"|]) in
        let expected = String.concat Js.(to_string path##.sep) ["\\.git";"objects$"] in
        let regexp = new%js Js.regExp Js.(string expected) in
        assert_ok @@ Js.to_bool @@ regexp##test v
      );
    "should be able to use join" >:: (fun () ->
        let path = J.path () in
        let v = path##join Js.(array [|Js.string "."; Js.string ".git"; Js.string "objects"|]) in
        let expected = String.concat Js.(to_string path##.sep) [".git";"objects"] in
        assert_eq v Js.(string expected)
      );
  ]
