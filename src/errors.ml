(** this module defines bindings for errors of nodejs. *)

module System_error = struct
  class type t = object
    inherit Js.error
    method errno: int Js.prop
    method code: Js.js_string Js.t Js.prop
    method syscall: Js.js_string Js.t Js.prop
    method path: Js.js_string Js.t Js.optdef Js.prop
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

  let string_of_code e =
    let str = match e with
      | ENOENT -> "ENOENT"
      | EISDIR -> "EISDIR"
      | EEXIST -> "EEXIST"
      | ENOTDIR -> "ENOTDIR"
      | ENOTEMPTY -> "ENOTEMPTY"
      | EACCS -> "EACCS"
      | Not_mapped c -> c
    in
    Js.string str

  let make ?(errno=0)
      ?(code=Not_mapped "")
      ?(syscall="")
      ?path
      ?(name="")
      ?stack
      message =
    let v : t Js.t = Js.Unsafe.coerce @@ new%js Js.error_constr (Js.string message) in
    v##.message := Js.string message;
    v##.name := Js.string name;
    v##.stack := Js.Optdef.(map (option stack) Js.string);
    v##.errno := errno;
    v##.code := string_of_code code;
    v##.syscall := Js.string syscall;
    v##.path := Js.Optdef.(map (option path) Js.string);
    v

end

type t = [
  | `JsooSystemError of System_error.t Js.t
]
