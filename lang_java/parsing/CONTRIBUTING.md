# External Java Parsers

We currently have WIP for incorporating tree-sitter-java grammar into pfff. 

### Writing OCaml

To compile OCaml code

```
$ ocamlc -o <executable> <filename>.ml
$ ./<executable>
```

### Running

You can run the following commands to output a JSON of the AST parsed from a `.java` file by tree-sitter.

```
$ npm install tree-sitter
$ npm install tree-sitter-java
$ git clone https://github.com/tree-sitter/tree-sitter-java/
$ cd tree-sitter-java && npm install 
$ cd ..
$ node tree-sitter-parser.js <path/to/java/file>
```

You can run the following commands to output a JSON of the AST parsed from a `.java` file by Babelfish (this is not yet complete). You must have Docker already installed.

```
$ pip3 install bblfsh
$ docker run --privileged --rm -it -p 9432:9432 -v bblfsh_cache:/var/lib/bblfshd --name bblfshd bblfsh/bblfshd
$ docker exec -it bblfshd bblfshctl driver install python bblfsh/python-driver
$ python bblfsh-parser.py <path/to/java/file>
```

The following command allows you to run tree-sitter-java across a repository and outputs the number of `.java` files that fails parsing.

```
bash tree-sitter-parser <FILES_TO_SEARCH>
```

The following command allows you to run tree-sitter-java across a repository and generate a corpus of JSON files from the `.java` files parsed.

```
bash json-generate <FILES_TO_SEARCH>
```

### Todo

- Include support for language selection

### Sources

- [Babelfish Python Client](https://github.com/bblfsh/python-client)
- [tree-sitter](https://github.com/tree-sitter/tree-sitter)
- [tree-sitter-java](https://github.com/tree-sitter/tree-sitter-java/)