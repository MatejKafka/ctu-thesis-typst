# ctu-thesis-typst

Typst template for an IT thesis at the Czech Technical University in Prague. Originally from FEE, might need some tweaking to meet the guidelines of other faculties.

To use the template, just clone the repository locally or upload it to a new project in the Typst web app, copy `example.typ`, adjust the metadata block at the top and then start writing  your thesis below.

In the web app, everything should automatically work. For local compilation, you must set a path to the font directory used for the title page when compiling:

```sh
typst compile --font-path ./template/res/fonts ./example.typ
```

If you don't, the title page will be mostly blank, except for the CTU logo.

## Example

To view the output of the template, see [example.pdf](./example.pdf), which is compiled from `example.typ` using Typst v0.11.1.

For a more complex example, see my thesis, which uses this template: https://typst.app/project/rlLOElGGPtW50kb2HFsT1-

## Issues

You might be wondering what's up with the "assignment page 1" and "assignment page 2" in the output. I would prefer to insert the assignment of the thesis here, but Typst does not support embedding of other PDFs yet.

Instead, when submitting the thesis, I exported the PDF and then used `qpdf` to replace the placeholder pages with the actual assignment, which works out OK since `qpdf` correctly preserves metadata such as the outline (unlike most other free PDF tools):

```sh
qpdf typst-export.pdf --pages . 1 assignment.pdf 1-z . 5 . 7-z -- out.pdf
```

