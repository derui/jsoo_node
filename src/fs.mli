(** Bindings for nodejs's fs module.
    This library would not provide raw bindings such as [path##join ...]. Provide only OCaml friendly
    interface instead.
*)

include Fs_intf.S

module Make(Fs:Fs_intf.Instance) : Fs_intf.S
