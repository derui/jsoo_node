(** Bindings for nodejs's fs module.
    This library would not provide raw bindings such as [path##join ...]. Provide only OCaml friendly
    interface instead.
*)

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

val lstatSync : string -> stat Js.t
val readFileSync : string -> string
val readdirSync : string -> string array
val readlinkSync : string -> string
val statSync : string -> stat Js.t
val writeFileSync: string -> string -> unit
val mkdirSync: string -> unit
val rmdirSync: string -> unit
val unlinkSync: string -> unit
val removeSync: string -> unit

(** Copy src file to dest *)
val copyFile:
  ?mode:[ `AllowOwnerRead
        | `AllowOwnerWrite
        | `AllowOwnerExec
        | `AllowOwnerAll
        | `AllowGroupRead
        | `AllowGroupWrite
        | `AllowGroupExec
        | `AllowGroupAll
        | `AllowOthersRead
        | `AllowOthersWrite
        | `AllowOthersExec
        | `AllowOthersAll
        ] list
  -> src:string -> dest:string
  -> unit -> (unit, [> `FsCopyError of string]) result Lwt.t
