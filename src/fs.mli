(** Bindings for nodejs's fs module. *)

class type stat = object
  method atime : Js.date Js.t Js.readonly_prop
  method birthtime : Js.date Js.t Js.readonly_prop
  method blksize : Js.number Js.t Js.readonly_prop
  method blocks : Js.number Js.t Js.readonly_prop
  method ctime : Js.date Js.t Js.readonly_prop
  method dev : Js.number Js.t Js.readonly_prop
  method gid : Js.number Js.t Js.readonly_prop
  method ino : Js.number Js.t Js.readonly_prop
  method isBlockDevice : bool Js.t Js.meth
  method isDirectory : bool Js.t Js.meth
  method isFile : bool Js.t Js.meth
  method isSymbolicLink : bool Js.t Js.meth
  method mode : Js.number Js.t Js.readonly_prop
  method mtime : Js.date Js.t Js.readonly_prop
  method rdev : Js.number Js.t Js.readonly_prop
  method size : Js.number Js.t Js.readonly_prop
  method uid : Js.number Js.t Js.readonly_prop
  method unlink : Js.number Js.t Js.readonly_prop
end

class type stat_obj = object
  method atime : float Js.readonly_prop
  method birthtime : float Js.readonly_prop
  method blksize : Js.number Js.t Js.readonly_prop
  method blocks : Js.number Js.t Js.readonly_prop
  method ctime : float Js.readonly_prop
  method dev : Js.number Js.t Js.readonly_prop
  method gid : Js.number Js.t Js.readonly_prop
  method ino : Js.number Js.t Js.readonly_prop
  method isBlockDevice : bool Js.t Js.readonly_prop
  method isDirectory : bool Js.t Js.readonly_prop
  method isFile : bool Js.t Js.readonly_prop
  method isSymbolicLink : bool Js.t Js.readonly_prop
  method mode : Js.number Js.t Js.readonly_prop
  method mtime : float Js.readonly_prop
  method rdev : Js.number Js.t Js.readonly_prop
  method size : Js.number Js.t Js.readonly_prop
  method uid : Js.number Js.t Js.readonly_prop
  method unlink : Js.number Js.t Js.readonly_prop
end

(** Convert stat class to plain javascript object *)
val stat_to_obj : stat Js.t -> stat_obj Js.t

(** The type for nodejs's fs module *)
class type t = object
  method lstatSync : Js.js_string Js.t -> stat Js.t Js.meth
  method readFileSync : Js.js_string Js.t -> Js.js_string Js.t Js.t Js.meth
  method readdirSync : Js.js_string Js.t -> Js.js_string Js.t Js.js_array Js.t Js.meth
  method readlinkSync : Js.js_string Js.t -> Js.js_string Js.t Js.meth
  method statSync : Js.js_string Js.t -> stat Js.t Js.meth
end

(** return fs module *)
val t : unit -> t Js.t
