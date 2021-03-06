# NodeJs Bindings for js\_of\_ocaml #
This library provides small bindings for NodeJS to use with js\_of\_ocaml.

## Requirements ##

* js\_of\_ocaml
* js\_of\_ocaml-ppx

## Installation ##
1. Clone this repository
1. Add jsoo_node as pinned project

   ```shell
   $ cd path_to_jsoo_node
   $ opam pin -k git add jsoo_node .
   $ opam install jsoo_node
   ```

1. Add reactjscaml to your project's dependency.

   If you already use opam, add ``depends`` follows.

   ```
   "jsoo_node"
   ```

## Development ##

### Install ###

1. clone this repository
2. clone ``mocha_of_ocaml``
3. execute command

    ```shell
    npm install
    ```

### Build ###

```
jbuilder build
```

### Test ###

```
jbuilder runtest
```

## License ##
MIT
