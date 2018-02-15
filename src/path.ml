(** Bindings for nodejs's path module *)

class type t = object
  method resolve: Js.js_string Js.t Js.js_array Js.t -> Js.js_string Js.t Js.meth
  method join: Js.js_string Js.t Js.js_array Js.t -> Js.js_string Js.t Js.meth
  method sep: Js.js_string Js.t Js.readonly_prop
end

let t : unit -> t Js.t = fun () ->
  let original = Inner_util.require "path" in
  object%js
    method resolve = fun v ->
      let v = Js.to_array v |> Array.map Js.Unsafe.inject in
      Js.Unsafe.fun_call (Js.Unsafe.get original "resolve") v

    method join = fun v ->
      let v = Js.to_array v |> Array.map Js.Unsafe.inject in
      Js.Unsafe.fun_call (Js.Unsafe.get original "join") v

    val sep = original##.sep
  end
