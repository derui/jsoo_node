module type Instance = sig
  val instance : Module_types.fs Js.t
end

module type S = sig

  (** Convert stat class to plain javascript object *)
  val stat_to_obj : Fs_types.stat Js.t -> Fs_types.stat_obj Js.t

  (**
     shallow direct bindings of fs.
     All bindings would not throw any exception, but user should handling result.
  *)
  val lstatSync : string -> (Fs_types.stat Js.t, Errors.t) result
  val readFileSync : string -> (string, Errors.t) result
  val readdirSync : string -> (string array, Errors.t) result
  val readlinkSync : string -> (string, Errors.t) result
  val statSync : string -> (Fs_types.stat Js.t, Errors.t) result
  val writeFileSync: string -> string -> (unit, Errors.t) result
  val mkdirSync: string -> (unit, Errors.t) result
  val rmdirSync: string -> (unit, Errors.t) result
  val unlinkSync: string -> (unit, Errors.t) result
  val existsSync: string -> bool
  val renameSync: string -> string -> (unit, Errors.t) result

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
    -> unit -> (unit, Errors.t) result Lwt.t

  (** Remove file/directory all. *)
  val remove_sync: string -> (unit, Errors.t) result
end
