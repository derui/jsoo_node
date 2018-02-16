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

(**
   shallow direct bindings of fs.
   All bindings would not throw any exception, but user should handling result.
*)
val lstatSync : string -> (stat Js.t, exn) result
val readFileSync : string -> (string, exn) result
val readdirSync : string -> (string array, exn) result
val readlinkSync : string -> (string, exn) result
val statSync : string -> (stat Js.t, exn) result
val writeFileSync: string -> string -> (unit, exn) result
val mkdirSync: string -> (unit, exn) result
val rmdirSync: string -> (unit, exn) result
val unlinkSync: string -> (unit, exn) result
val existsSync: string -> bool

(**
   jsoo_node original functions
*)

(** Copy src file to dest. This operation should be atomic. *)
val copy_file:
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
  -> unit -> (unit, [> `FsCopyError of exn]) result Lwt.t

(** Remove file/directory all. *)
val remove_sync: string -> (unit, exn) result
