(** require module as commonjs style. *)
let require module_ : 'a Js.t = Js.Unsafe.js_expr ("require('" ^ module_ ^ "')")
