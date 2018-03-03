(** Interfaces for nodejs's path module.
    This library would not provide raw bindings such as [path##join ...]. Provide only OCaml friendly
    interface instead.
*)

module type Instance = sig
  val instance : Module_types.path Js.t
end

module type S = sig
  (** shallow direct bindings for path. *)
  val join: string list -> string
  val resolve: string list -> string
  val sep: string
  val dirname: string -> string
  val basename: ?ext:string -> string -> string
  val extname: string -> string
end
