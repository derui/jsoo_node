(** Bindings for nodejs's path module *)

class type t = object
  method sep: Js.js_string Js.t Js.readonly_prop
end

let t : unit -> t Js.t = fun () -> Inner_util.require "path"

let call_path_func name args =
  let path = t () in
  Js.Unsafe.fun_call (Js.Unsafe.get path name) args

let join paths =
  let paths = Array.of_list paths |> Array.map Js.string |> Array.map Js.Unsafe.inject in
  call_path_func "join" paths |> Js.to_string

let resolve paths =
  let paths = Array.of_list paths |> Array.map Js.string |> Array.map Js.Unsafe.inject in
  call_path_func "resolve" paths |> Js.to_string

let sep = let path = t () in Js.to_string path##.sep
