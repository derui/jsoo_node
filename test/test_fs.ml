open Mocha_of_ocaml
module J = Jsoo_node

let suite () =
  "NodeJS fs module" >::: [
    "should be able to use lstatSync" >:: (fun () ->
        let v = J.Fs.lstatSync "package.json" in
        match v with
        | Ok v -> assert_ok @@ Js.to_bool v##isFile
        | _ -> assert_fail "Error occured"
      );
    "should be able to use statSync" >:: (fun () ->
        let v = J.Fs.lstatSync "package.json" in
        match v with
        | Ok v -> assert_ok @@ Js.to_bool v##isFile
        | _ -> assert_fail "Error occured"
      );
    "should be able to use readFileSync" >:: (fun () ->
        let v = J.Fs.lstatSync "package.json" in
        let contents = J.Fs.readFileSync "package.json" in
        match v, contents with
        | Ok v, Ok contents -> assert_eq Js.(int_of_float @@ float_of_number v##.size) String.(length contents)
        | _ -> assert_fail "Error occured"
      );
    "should be able to use readdirSync" >:: (fun () ->
        let v = J.Fs.readdirSync "src" in
        match v with
        | Ok v -> begin
            let list = Array.to_list v in
            assert_ok @@ List.mem "fs.ml" list
          end
        | _ -> assert_fail "Error  occured"
      );

    before_each (fun () ->
        let dir = J.Path.resolve [".";"tmp"] in
        let src = J.Path.join [dir;"copy_src.txt"] in
        J.Fs.mkdirSync dir |> ignore;
        J.Fs.writeFileSync src "data" |> ignore;
      );
    after_each (fun () -> J.Fs.remove_sync @@ J.Path.resolve [".";"tmp"] |> ignore);

    "can remove whole directory structure" >:: (fun () ->
        let dir = J.Path.resolve [".";"tmp"] in

        J.Fs.remove_sync dir |> ignore;

        assert_not_ok J.Fs.(existsSync dir)
      );
    "should be able to copy a src to other" >:- (fun () ->
        let dir = J.Path.resolve [".";"tmp"] in
        let src = J.Path.join [dir;"copy_src.txt"]
        and dest = J.Path.join [dir;"copy_dest.txt"] in
        let open Lwt.Infix in
        J.Fs.copy_file ~src ~dest () >>= fun ret ->
        let open Infix in
        let data = J.Fs.readFileSync dest in
        match data with
        | Ok data -> let data = Js.string data in
          Lwt.return @@ (assert_ok (ret = Ok ()) <|> assert_eq Js.(string "data") data)
        | _ -> Lwt.return @@ assert_fail "Error occured"
      )
  ]
