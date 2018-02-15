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
  ]
