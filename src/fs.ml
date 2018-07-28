(** Bindings for nodejs's fs module. *)
open Js
module T = Fs_types

let fs : unit -> Module_types.fs Js.t = fun () -> Inner_util.require "fs"

module Make(Fs:Fs_intf.Instance) : Fs_intf.S = struct

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

  let exn_to_error = function
    | Js.Error e ->
      let err : Errors.System_error.t Js.t = Js.Unsafe.coerce e in `JsooSystemError err
    | e -> failwith (Printf.sprintf "Unknown exception: %s" @@ Printexc.to_string e)

  let wrap_error f =
    try
      Ok (f ())
    with e -> Pervasives.Error (exn_to_error e)

  let lstatSync path =
    let fs = Fs.instance in
    wrap_error (fun () -> fs##lstatSync (Js.string path))

  let readFileSync path = let fs = Fs.instance in
    wrap_error @@ fun () ->
    let buffer = fs##readFileSync (Js.string path) in
    Js.to_string buffer##toString

  let readdirSync path =
    let fs = Fs.instance in
    wrap_error @@ fun () -> fs##readdirSync (Js.string path) |> Js.to_array |> Array.map Js.to_string

  let readlinkSync path =
    let fs = Fs.instance in
    wrap_error @@ fun () -> fs##readlinkSync (Js.string path) |> Js.to_string

  let statSync path =
    let fs = Fs.instance in
    wrap_error (fun () -> fs##statSync (Js.string path))

  let writeFileSync path data =
    let fs = Fs.instance in
    wrap_error @@ fun () -> fs##writeFileSync (Js.string path) (Js.string data)

  let mkdirSync path = let fs = Fs.instance in wrap_error @@ fun () -> fs##mkdirSync (Js.string path)
  let rmdirSync path = let fs = Fs.instance in wrap_error @@ fun () -> fs##rmdirSync (Js.string path)
  let unlinkSync path = let fs = Fs.instance in wrap_error @@ fun () -> fs##unlinkSync (Js.string path)
  let existsSync path = let fs = Fs.instance in fs##existsSync (Js.string path) |> Js.to_bool
  let renameSync oldpath newpath =
    let fs = Fs.instance in
    wrap_error @@ fun () -> fs##renameSync (Js.string oldpath) (Js.string newpath)
  let chmodSync path permission =
    let fs = Fs.instance in
    wrap_error @@ fun () -> fs##chmodSync (Js.string path) permission

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
    let (>|=) v f = match v with
      | Ok v -> Ok (f v)
      | Error _ as v -> v
    and (>>=) v f = match v with
      | Ok v -> f v
      | Error _ as v -> v
    in
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
    let fs = Fs.instance in
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
    let error_handler err = Lwt.wakeup waker (Pervasives.Error (exn_to_error err)) in
    r##on error_channel (wrap_callback error_handler);
    w##on error_channel (wrap_callback error_handler);
    w##on close_channel (wrap_callback @@ fun _ -> Lwt.wakeup waker (Ok ()));

    r##pipe w |> ignore;

    wait

end

include Make(struct
    let instance = fs ()
  end)
