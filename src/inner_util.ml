(** require module as commonjs style. *)
let require module_ : 'a Js.t =
  let require = Js.Unsafe.pure_js_expr "require" in
  let module_ = Js.string module_ in
  Js.Unsafe.(fun_call require [|inject module_|])

module Result_infix :sig

  val ( >>= ): ('a, 'e) result -> ('a -> ('b, 'e) result) -> ('b, 'e) result
  val ( >|= ): ('a, 'e) result -> ('a -> 'b) -> ('b, 'e) result
end = struct

  let bind v f = match v with
    | Ok v -> f v
    | Error _ as e -> e

  let map v f = match v with
    | Ok v -> Ok (f v)
    | Error _ as e -> e

  let (>>=) = bind
  let (>|=) = map
end
