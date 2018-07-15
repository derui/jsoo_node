(** Bindings for nodejs's path module *)
let path : unit -> Module_types.path Js.t = fun () -> Inner_util.require "path"

module Make(Path:Path_intf.Instance) : Path_intf.S = struct
  let call_path_func name args =
    let path = Path.instance in
    Js.Unsafe.fun_call (Js.Unsafe.get path name) args

  let join paths =
    let paths = Array.of_list paths |> Array.map Js.string |> Array.map Js.Unsafe.inject in
    call_path_func "join" paths |> Js.to_string

  let resolve paths =
    let paths = Array.of_list paths |> Array.map Js.string |> Array.map Js.Unsafe.inject in
    call_path_func "resolve" paths |> Js.to_string

  let sep = let path = Path.instance in Js.to_string path##.sep

  let dirname str = let path = Path.instance in Js.to_string @@ path##dirname (Js.string str)
  let basename ?ext name =
    let ext = Js.Optdef.option ext in
    let ext = Js.Optdef.map ext Js.string in
    let path = Path.instance in
    Js.to_string @@ path##basename (Js.string name) ext

  let extname str = let path = Path.instance in Js.to_string @@ path##extname (Js.string str)
end

include Make(struct
    let instance = path ()
  end)

let posix = (module Make(struct
    let instance = let p = path () in Js.Unsafe.get p "posix"
  end) : Path_intf.S)

let win32 = (module Make(struct
    let instance = let p = path () in Js.Unsafe.get p "win32"
  end): Path_intf.S)
