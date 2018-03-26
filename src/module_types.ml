open Js

(** The type of fs module *)
class type fs = object
  method statSync: js_string t -> Fs_types.stat t meth
  method lstatSync: js_string t -> Fs_types.stat t meth
  method readlinkSync: js_string t -> js_string t meth
  method readdirSync: js_string t -> js_string t js_array t meth
  method readFileSync: js_string t -> Fs_types.buffer t meth

  method writeFileSync: js_string t -> js_string t -> unit meth
  method mkdirSync: js_string t -> unit meth
  method rmdirSync: js_string t -> unit meth
  method unlinkSync: js_string t -> unit meth
  method existsSync: js_string t -> bool t meth
  method renameSync: js_string t -> js_string t -> unit meth
  method chmodSync: js_string t -> int -> unit meth

  method createReadStream: js_string t -> Fs_types.Option.create_read_stream t optdef -> Stream.readable t meth
  method createWriteStream: js_string t -> Fs_types.Option.create_write_stream t optdef -> Stream.writeable t meth
end

(** The type of path module *)
class type path = object
  method sep: js_string t readonly_prop
  method join: js_string t -> js_string t meth
  method join_2: js_string t -> js_string t -> js_string t meth
  method join_3: js_string t -> js_string t -> js_string t -> js_string t meth
  method join_4: js_string t -> js_string t -> js_string t -> js_string t -> js_string t meth
  method resolve: js_string t -> js_string t meth
  method resolve_2: js_string t -> js_string t -> js_string t meth
  method resolve_3: js_string t -> js_string t -> js_string t -> js_string t meth
  method resolve_4: js_string t -> js_string t -> js_string t -> js_string t -> js_string t meth
  method basename: js_string t -> js_string t optdef -> js_string t meth
  method dirname: js_string t -> js_string t meth
  method extname: js_string t -> js_string t meth
end
