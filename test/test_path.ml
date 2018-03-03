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
    "should be able to call basename" >:: (fun () ->
        let v = J.Path.join ["test"; "file"; "basename.txt"] in
        let v = J.Path.basename v in
        assert_eq Js.(string v) Js.(string "basename.txt")
      );
    "should be able to call basename with ext" >:: (fun () ->
        let v = J.Path.join ["test"; "file"; "basename.txt"] in
        let v = J.Path.basename ~ext:".txt" v in
        assert_eq Js.(string v) Js.(string "basename")
      );
    "should be able to call dirname" >:: (fun () ->
        let v = J.Path.join ["test"; "file"; "basename.txt"] in
        let v = J.Path.dirname v in
        assert_eq Js.(string v) Js.(string @@ J.Path.join ["test";"file"])
      );
    "should be able to call extname" >:: (fun () ->
        let v = J.Path.join ["test"; "file"; "basename.txt"] in
        let v = J.Path.extname v in
        assert_eq Js.(string v) Js.(string ".txt")
      );

    "can use POSIX specific implementation" >:: (fun () ->
        let module Path = (val J.Path.posix) in
        let v = Path.join ["test";"file"; "basename"] in
        assert_eq Js.(string v) Js.(string "test/file/basename")
      );

    "can use win32 specific implementation" >:: (fun () ->
        let module Path = (val J.Path.win32) in
        let v = Path.join ["test";"file"; "basename"] in
        assert_eq Js.(string v) Js.(string "test\\file\\basename")
      );
  ]
