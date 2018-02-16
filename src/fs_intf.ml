module type Instance = sig
  val instance : Fs_types.t Js.t
end

module type S = sig

  (** Convert stat class to plain javascript object *)
  val stat_to_obj : Fs_types.stat Js.t -> Fs_types.stat_obj Js.t

  (**
     shallow direct bindings of fs.
     All bindings would not throw any exception, but user should handling result.
  *)
  val lstatSync : string -> (Fs_types.stat Js.t, exn) result
  val readFileSync : string -> (string, exn) result
  val readdirSync : string -> (string array, exn) result
  val readlinkSync : string -> (string, exn) result
  val statSync : string -> (Fs_types.stat Js.t, exn) result
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
end
