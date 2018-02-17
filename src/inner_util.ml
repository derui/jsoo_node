(** require module as commonjs style. *)
let require module_ : 'a Js.t =
  let require = Js.Unsafe.pure_js_expr "require" in
  let module_ = Js.string module_ in
  Js.Unsafe.(fun_call require [|inject module_|])
