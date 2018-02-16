(** Bindings for nodejs's fs module. *)
open Js

(* FFI for fs and original-fs module *)
class type stat = object
  method dev: number t readonly_prop
  method ino: number t readonly_prop
  method mode: number t readonly_prop
  method unlink: number t readonly_prop
  method uid: number t readonly_prop
  method gid: number t readonly_prop
  method rdev: number t readonly_prop
  method size: number t readonly_prop
  method blksize: number t readonly_prop
  method blocks: number t readonly_prop
  method atime: date t readonly_prop
  method mtime: date t readonly_prop
  method ctime: date t readonly_prop
  method birthtime: date t readonly_prop
  method isDirectory: bool t meth
  method isFile: bool t meth
  method isBlockDevice: bool t meth
  method isSymbolicLink: bool t meth
end

class type stat_obj = object
  method dev: number t readonly_prop
  method ino: number t readonly_prop
  method mode: number t readonly_prop
  method unlink: number t readonly_prop
  method uid: number t readonly_prop
  method gid: number t readonly_prop
  method rdev: number t readonly_prop
  method size: number t readonly_prop
  method blksize: number t readonly_prop
  method blocks: number t readonly_prop
  method atime: float readonly_prop
  method mtime: float readonly_prop
  method ctime: float readonly_prop
  method birthtime: float readonly_prop
  method isDirectory: bool t readonly_prop
  method isFile: bool t readonly_prop
  method isBlockDevice: bool t readonly_prop
  method isSymbolicLink: bool t readonly_prop
end

(* Convert Stats class to pure json *)
let stat_to_obj t = object%js
  val dev = t##.dev
  val ino = t##.ino
  val mode = t##.mode
  val unlink = t##.unlink
  val uid = t##.uid
  val gid = t##.gid
  val rdev = t##.rdev
  val size = t##.size
  val blksize = t##.blksize
  val blocks = t##.blocks
  val atime = t##.atime##getTime
  val mtime = t##.mtime##getTime
  val ctime = t##.ctime##getTime
  val birthtime = t##.birthtime##getTime
  val isDirectory = t##isDirectory
  val isFile = t##isFile
  val isBlockDevice = t##isBlockDevice
  val isSymbolicLink = t##isSymbolicLink
end

module Option = struct
  class type create_read_stream = object
    method flags: Js.js_string Js.t Js.optdef Js.readonly_prop
    method encoding: Js.js_string Js.t Js.optdef Js.readonly_prop
    method fd: int Js.optdef Js.readonly_prop
    method mode: int Js.optdef Js.readonly_prop
    method autoClose: bool Js.t Js.optdef Js.readonly_prop
    method start: int Js.t Js.optdef Js.readonly_prop
    method _end: int Js.t Js.optdef Js.readonly_prop
  end

  class type create_write_stream = object
    method flags: Js.js_string Js.t Js.optdef Js.readonly_prop
    method encoding: Js.js_string Js.t Js.optdef Js.readonly_prop
    method fd: int Js.optdef Js.readonly_prop
    method mode: int Js.optdef Js.readonly_prop
    method autoClose: bool Js.t Js.optdef Js.readonly_prop
    method start: int Js.t Js.optdef Js.readonly_prop
  end
end

class type buffer = object
  method toString: js_string t meth
end

class type t = object
  method statSync: js_string Js.t -> stat Js.t meth
  method lstatSync: js_string Js.t -> stat Js.t meth
  method readlinkSync: js_string Js.t -> js_string Js.t meth
  method readdirSync: js_string Js.t -> js_string Js.t js_array Js.t meth
  method readFileSync: js_string Js.t -> buffer Js.t meth

  method writeFileSync: js_string Js.t -> js_string Js.t -> unit meth
  method mkdirSync: js_string Js.t -> unit meth
  method rmdirSync: js_string Js.t -> unit meth
  method unlinkSync: js_string Js.t -> unit meth
  method existsSync: js_string Js.t -> bool Js.t meth

  method createReadStream: js_string Js.t -> Option.create_read_stream Js.t optdef -> Stream.readable Js.t meth
  method createWriteStream: js_string Js.t -> Option.create_write_stream Js.t optdef -> Stream.writeable Js.t meth
end

let t : unit -> t Js.t = fun () -> Inner_util.require "fs"

let wrap_error f =
  try
    Ok (f ())
  with e -> Pervasives.Error e

let lstatSync path =
  let fs = t () in
  wrap_error (fun () -> fs##lstatSync (Js.string path))

let readFileSync path = let fs = t () in
  wrap_error @@ fun () ->
  let buffer = fs##readFileSync (Js.string path) in
  Js.to_string buffer##toString

let readdirSync path =
  let fs = t () in
  wrap_error @@ fun () -> fs##readdirSync (Js.string path) |> Js.to_array |> Array.map Js.to_string

let readlinkSync path =
  let fs = t () in
  wrap_error @@ fun () -> fs##readlinkSync (Js.string path) |> Js.to_string

let statSync path =
  let fs = t () in
  wrap_error (fun () -> fs##statSync (Js.string path))

let writeFileSync path data =
  let fs = t () in
  wrap_error @@ fun () -> fs##writeFileSync (Js.string path) (Js.string data)

let mkdirSync path = let fs = t () in wrap_error @@ fun () -> fs##mkdirSync (Js.string path)
let rmdirSync path = let fs = t () in wrap_error @@ fun () -> fs##rmdirSync (Js.string path)
let unlinkSync path = let fs = t () in wrap_error @@ fun () -> fs##unlinkSync (Js.string path)
let existsSync path = let fs = t () in fs##existsSync (Js.string path) |> Js.to_bool

let mode_to_int list =
  List.fold_left (fun v mode ->
      match mode with
      | `AllowOwnerRead -> v lor 0o400
      | `AllowOwnerWrite -> v lor 0o200
      | `AllowOwnerExec -> v lor 0o100
      | `AllowOwnerAll -> v lor 0o700
      | `AllowGroupRead -> v lor 0o40
      | `AllowGroupWrite -> v lor 0o20
      | `AllowGroupExec -> v lor 0o10
      | `AllowGroupAll -> v lor 0o70
      | `AllowOthersRead -> v lor 0o4
      | `AllowOthersWrite -> v lor 0o2
      | `AllowOthersExec -> v lor 0o1
      | `AllowOthersAll -> v lor 0o7
    ) 0 list

let remove_sync path =
  let open Inner_util.Result_infix in

  let is_directory path = statSync path >|= fun stat -> Js.to_bool stat##isDirectory in
  let rec remove path_list =
    match path_list with
    | [] -> Ok ()
    | path :: rest -> begin
        is_directory path >>= (fun is_directory ->
            if is_directory then begin
              readdirSync path
              >|= Array.map (fun p -> Path.join [path;p])
              >|= Array.to_list
              >>= remove
              >>= fun () -> rmdirSync path
            end else
              unlinkSync path
          )
        >>= fun () -> remove rest
      end
  in
  remove [Path.resolve [path]]

let copy_file ?mode ~src ~dest () =
  let mode = match mode with
    | None -> mode_to_int [`AllowOwnerRead;`AllowOwnerWrite; `AllowGroupRead;`AllowGroupWrite;`AllowOthersRead]
    | Some mode -> mode_to_int mode
  in
  let fs = t () in
  let r = fs##createReadStream Js.(string src) Js.Optdef.empty
  and w = fs##createWriteStream Js.(string dest) Js.Optdef.(
      return (object%js
        val flags = Optdef.empty
        val encoding = Optdef.empty
        val fd = Optdef.empty
        val autoClose = Optdef.empty
        val start = Optdef.empty
        val mode = Js.Optdef.return mode
      end))
  in
  let wait, waker = Lwt.wait () in
  let error_channel = Js.string "error" in
  let close_channel = Js.string "close" in
  let error_handler err = Lwt.wakeup waker (Pervasives.Error (`FsCopyError err)) in
  r##on error_channel (wrap_callback error_handler);
  w##on error_channel (wrap_callback error_handler);
  w##on close_channel (wrap_callback @@ fun _ -> Lwt.wakeup waker (Ok ()));

  r##pipe w |> ignore;

  wait
