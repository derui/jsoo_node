module Fs = Fs
module Path = Path

let fs = Fs.t
let path = Path.t

let __dirname : Js.js_string Js.t = Js.Unsafe.variable "__dirname"
