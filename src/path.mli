(** Bindings for nodejs's path module *)
class type t = object
  method join : Js.js_string Js.t Js.js_array Js.t -> Js.js_string Js.t Js.meth
  method resolve : Js.js_string Js.t Js.js_array Js.t -> Js.js_string Js.t Js.meth
  method sep: Js.js_string Js.t Js.readonly_prop
end

(** return path module. *)
val t : unit -> t Js.t
