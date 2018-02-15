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

class type t = object
  method statSync: js_string Js.t -> stat Js.t meth
  method lstatSync: js_string Js.t -> stat Js.t meth
  method readlinkSync: js_string Js.t -> js_string Js.t meth
  method readdirSync: js_string Js.t -> js_string Js.t js_array Js.t meth
  method readFileSync: js_string Js.t -> js_string Js.t Js.t meth
end

let t : unit -> t Js.t = fun () -> Inner_util.require "fs"
