(** require module as commonjs style. *)
let require module_ : 'a Js.t =
  Js.Unsafe.pure_js_expr @@ "require('" ^ module_ ^ "')"
