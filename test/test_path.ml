open Mocha_of_ocaml
module J = Jsoo_node

let suite () =
  "NodeJS path module" >::: [
    "should be able to use resolve" >:: (fun () ->
        let v = J.Path.resolve ["."; ".git"; "objects"] in
        let expected = String.concat J.Path.sep ["\\.git";"objects$"] in
        let regexp = new%js Js.regExp Js.(string expected) in
        assert_ok @@ Js.to_bool @@ regexp##test (Js.string v)
      );
    "should be able to use join" >:: (fun () ->
        let v = J.Path.join ["."; ".git"; "objects"] in
        let expected = String.concat J.Path.sep [".git";"objects"] in
        assert_eq Js.(string v) Js.(string expected)
      );
  ]
