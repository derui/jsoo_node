open Mocha_of_ocaml
module J = Jsoo_node

let suite () =
  "NodeJS fs module" >::: [
    "should be able to use lstatSync" >:: (fun () ->
        let fs = J.fs () in
        let v = fs##lstatSync Js.(string "package.json") in
        assert_ok @@ Js.to_bool v##isFile
      );
    "should be able to use statSync" >:: (fun () ->
        let fs = J.fs () in
        let v = fs##lstatSync Js.(string "package.json") in
        assert_ok @@ Js.to_bool v##isFile
      );
    "should be able to use readFileSync" >:: (fun () ->
        let fs = J.fs () in
        let v = fs##lstatSync Js.(string "package.json") in
        let contents = fs##readFileSync Js.(string "package.json") in
        assert_eq Js.(int_of_float @@ float_of_number v##.size) contents##.length
      );
    "should be able to use readdirSync" >:: (fun () ->
        let fs = J.fs () in
        let v = fs##readdirSync Js.(string "src") in
        let list = Js.to_array v |> Array.map Js.to_string |> Array.to_list in
        assert_ok @@ List.mem "fs.ml" list
      );
  ]
