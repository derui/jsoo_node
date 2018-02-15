(** Bindings for nodejs's path module.
    This library would not provide raw bindings such as [path##join ...]. Provide only OCaml friendly
    interface instead.
*)

val join: string list -> string
val resolve: string list -> string
val sep: string
