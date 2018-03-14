(** this module defines bindings for errors of nodejs. *)

module System_error = struct
  class type t = object
    inherit Js.error
    method errno: int Js.readonly_prop
    method code: Js.js_string Js.t Js.readonly_prop
    method syscall: Js.js_string Js.t Js.readonly_prop
    method path: Js.js_string Js.t Js.optdef Js.readonly_prop
  end

  type code =
    | ENOENT
    | EISDIR
    | EEXIST
    | ENOTDIR
    | ENOTEMPTY
    | EACCS
    | Not_mapped of string

  (** Get the code variant from error *)
  let to_code e = match Js.to_string e##.code with
    | "ENOENT" -> ENOENT
    | "EISDIR" -> EISDIR
    | "EEXIST" -> EEXIST
    | "ENOTDIR" -> ENOTDIR
    | "ENOTEMPTY" -> ENOTEMPTY
    | "EACCS" -> EACCS
    | _ as c -> Not_mapped c

end

type t = [
  | `JsooSystemError of System_error.t Js.t
]
