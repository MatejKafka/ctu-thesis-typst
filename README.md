# ctu-thesis-typst

Typst template for an IT thesis at the Czech Technical University in Prague.

To use the template, just clone the repository locally or upload it to a new project in the Typst web app, copy `example.typ`, adjust the metadata block at the top and then start writing  your thesis below.

In the web app, everything should automatically work. For local compilation, you must set a path to the font directory used for the title page when compiling:

```sh
typst compile --font-path ./template/res/fonts ./example.typ
```

If you don't, the title page will be mostly blank, except for the CTU logo.

## Example

To view the output of the template, see [example.pdf](./example.pdf), which is compiled from `example.typ` using Typst v0.11.1.