open Mocha_of_ocaml
module J = Jsoo_node

let suite () =
  "NodeJS fs module" >::: [
    "should be able to use lstatSync" >:: (fun () ->
        let v = J.Fs.lstatSync "package.json" in
        assert_ok @@ Js.to_bool v##isFile
      );
    "should be able to use statSync" >:: (fun () ->
        let v = J.Fs.lstatSync "package.json" in
        assert_ok @@ Js.to_bool v##isFile
      );
    "should be able to use readFileSync" >:: (fun () ->
        let v = J.Fs.lstatSync "package.json" in
        let contents = J.Fs.readFileSync "package.json" in
        assert_eq Js.(int_of_float @@ float_of_number v##.size) String.(length contents)
      );
    "should be able to use readdirSync" >:: (fun () ->
        let v = J.Fs.readdirSync "src" in
        let list = Array.to_list v in
        assert_ok @@ List.mem "fs.ml" list
      );
    "should be able to copy a src to other" >:- (fun () ->
        let dir = J.Path.resolve [".";"tmp"] in
        Lwt.finalize (fun () ->

            let src = J.Path.join [dir;"copy_src.txt"]
            and dest = J.Path.join [dir;"copy_dest.txt"] in
            J.Fs.mkdirSync dir;
            J.Fs.writeFileSync src "data" ;
            let open Lwt.Infix in
            J.Fs.copyFile ~src ~dest () >>= fun ret ->
            let open Infix in
            let data = J.Fs.readFileSync dest |> Js.string in
            Lwt.return @@ (assert_ok (ret = Ok ()) <|> assert_eq Js.(string "data") data)
          )
          (fun () -> Lwt.return @@ J.Fs.removeSync dir)
      )
  ]
