
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
