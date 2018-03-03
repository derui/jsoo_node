(** Bindings for nodejs's path module.
    This library would not provide raw bindings such as [path##join ...]. Provide only OCaml friendly
    interface instead.
*)
open Path_intf

include S

(** POSIX specific implementations *)
val posix: (module S)

(** win32 specific implementations *)
val win32: (module S)

module Make(Path:Instance) : S
