open Js

class type writeable = object
  inherit Events.event_emitter
  method cork: unit meth
  method _end: unit meth
  method setDefaultEncoding: js_string t -> unit meth
  method uncork: unit meth
  method write: js_string t -> unit meth
  method write_encoding: js_string t -> js_string t -> unit meth
end

class type readable = object
  inherit Events.event_emitter

  method isPaused: bool t meth
  method pause: unit t meth
  method pipe: writeable t -> readable t meth
  method setDefaultEncoding: js_string t -> unit meth
  method unpipe: writeable t -> unit meth
end
