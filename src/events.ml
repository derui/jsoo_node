open Js

class type event_emitter = object
  (* handle some event raised from EventEmitter *)
  method on: js_string t -> 'a  callback -> unit meth
  method once: js_string t -> 'a callback -> unit meth
  method send: js_string t -> 'a -> unit meth
  method removeAllListener: js_string t -> unit meth
  method removeAllListener_all: unit -> unit meth
end
