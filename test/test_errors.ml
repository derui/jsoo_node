open Mocha_of_ocaml
module J = Jsoo_node

let suite () =
  "NodeJS error utility" >::: [
    "can make a system error" >:: (fun () ->
        let e = J.Errors.System_error.(make ~code:(ENOENT) "message") in
        let open Infix in
        assert_eq e##.message (Js.string "message")
        <|> assert_eq e##.code (Js.string "ENOENT")
        <|> assert_neq e##.message (Js.string "")
      )
  ]
