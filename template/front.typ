#let title-page(
  print,
  title: "",
  author: (
    name: "",
    email: "",
    url: "",
  ),
  submission-date: datetime.today(),
  bachelor: false,
  supervisor: "",
  faculty: "",
  department: "",
  study-programme: "",
  branch-of-study: "",
) = {
  // render as a separate page
  // inner margin is 8mm due to binding loss, but without
  //  the bent page extra, which is not an issue for the title page
  let inside-margin = if print {8mm} else {0mm}
  show: page.with(margin: (top: 0mm, bottom: 0mm, inside: inside-margin, outside: 0mm))

  set align(center)
  set place(center)
  set text(font: "Technika", weight: "extralight", size: 10.3pt)

  // shorthand to vertically position elements
  let b(dy, content, size: none, weight: none) = {
    set text(size: size) if size != none
    set text(weight: weight) if weight != none
    place(dy: dy, text(content))
  }

  b(33mm)[
    Czech Technical University in Prague \
    #faculty \
    #department
  ]

  b(63.5mm)[
    #image("./res/symbol_cvut_konturova_verze_cb.svg")
  ]

  b(131.5mm, size: 12.5pt)[
    #if bachelor [
      Bachelor's Thesis
    ] else [
      Master's Thesis
    ]
  ]

  b(140.7mm, size: 14.8pt, weight: "regular")[
    #title
  ]
  
  b(154.25mm, [
    #text(size: 12.5pt, style: "italic")[#author.name] \

    \
    #author.email \
    #link(author.url)
  ])

  b(210mm)[Supervisor: #supervisor]

  b(235.2mm)[Study programme: #study-programme]
  b(241.2mm)[Branch of study: #branch-of-study]
  
  b(254.3mm)[#submission-date.display("[month repr:long] [year]")]
}


#let abstract-page(
  submission-date,
  abstract-en: [],
  abstract-cz: [],
  acknowledgement: [],
  declaration: [
    I declare that the presented work was developed independently and that I have listed all sources of information used within it in accordance with the methodical instructions for observing the ethical principles in the preparation of university theses.
  ]
) = {
  // render as a separate page; add room at the bottom for TODOs and notes
  show: page.with(margin: (bottom: 0mm))
  
  set heading(outlined: false, bookmarked: false)
  // pretty hacky way to disable the implicit linebreak in my heading style
  show heading: it => {
    show pagebreak: it => {linebreak()}
    block(it)
    //block(it, above: 2pt)
  }

  // no idea why there is a margin here
  v(-30.2pt)
  [
    = Abstract
    #abstract-en
  ]
  
  [
    = Abstrakt (CZ)
    #abstract-cz
  ]

  v(6.6pt)
  //v(-6pt)
  grid(columns: (47.5%, 47.5%), gutter: 5%,
    [
      = Acknowledgement
      #set text(style: "italic")
      #acknowledgement
    ],
  
    [
      = Declaration
      #declaration
      
      In Prague, #submission-date.display("[day]. [month]. [year]")

      #v(2em)
      #repeat[.]
    ],
  )

  context {
    set text(size: 15pt, weight: "bold")
    set align(center)

    v(1em)
    grid(columns: (47%, 47%), gutter: 6%,
      {
        let todo-count = counter("todo").final().at(0);
        if (todo-count > 0) {
          set text(fill: red)
          block(width: 100%, inset: 4pt)[#todo-count TODOs remaining]
        }
      },
      {
        let note-count = counter("note").final().at(0);
        if (note-count > 0) {
          block(fill: yellow, width: 100%, inset: 4pt)[#note-count notes]
        }
      }
    )
  }
}


#let introduction(print, ..args) = {
  // hide empty pages from web version
  if print {
    // assignment must be on a single sheet from both sides
    pagebreak(to: "odd")
  } else {
    // Typst cannot embed PDFs, add the assignment separately
    page[assignment page 1]
    page[assignment page 2]
  }

  if print {
    pagebreak(to: "odd", weak: true)
  }
  abstract-page(..args)

  if print {
    // outline should be on the right, but the outline title has a pagebreak
    pagebreak(to: "even")
  }
  outline(depth: 2)

  pagebreak(weak: true)
}