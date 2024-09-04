// poznamky z tisku:
//  - zeptat se na studijnim, jestli by nemohli zadani tisknout se spravne zarovnanou zadni stranou (obe strany jsou prirazene doprava, coz pekne vychazi pro prvni stranu, ale ne pro druhou)
//  - tenke h1 nadpisy pusobi v tisku zvlastne, obzvlast v kontrastu s h2, a margin pod h1 nadpisem taky neni idealni; asi mel Kuba pravdu, ze Technika by na h1 dopadla lip
//  - marginy pro non-numbered nadpisy jsou moc male, pusobi to zmackle
//  - #line() je v tisku dost vyrazny, dal by se zesvetlit nebo ztencit, naopak v PDF je v nekterych viewerech spatne videt
//  - odrazeni o 8mm u title page vypada dobre
//  - 80g papir u Haronu je hodne pruhledny, 100g je dobry


#import "./front.typ": *

#let template(meta: (), print: false, ..intro-args, body) = {
  set document(
    author: meta.author.name,
    title: meta.title, date:
    meta.submission-date
  )
  set text(font: "Linux Libertine", size: 11pt, lang: "en")

  // the idea behind the inner margin is that if you lay the book out flat, there should be the same amount of space in the middle as on the outside
  // however, with binding from Haron.cz, the sides do not lay flat; from discussion with the guy at Haron, 8mm is consumed by the binding, and quite a lot of extra space is lost, since the page does not lay flat due to the binding; when I measured it in my printed thesis, I think the inner margin should be roughly 34mm and the outer margin 36mm at the beginning and end (where one side lays flat), and a bit more than that in the middle, but the variance based on how much you press down on the page is quite high, so we can make our lives easier and go with a symmetric 35mm+35mm margin
  let a4-width = 210mm
  // chosen to fit roughly 85 chars per line; ideally, it should be 45-75 chars for maximum readability, but imo this looks a bit better; feel free to make it smaller
  let text-width = 140mm
  let margin = (a4-width - text-width) / 2

  set page(
    paper: "a4",
    // same top/bottom margin as inner/outer; looks good in the PDF version
    margin: margin,
  )

  // render title page before configuring the rest, which we don't use
  title-page(print, ..meta)
  
  set par(justify: true)

  set line(length: 100%, stroke: 1pt + luma(200))
  
  set figure(placement: auto)
  show figure.caption: set text(0.9em)
  show figure.caption: box.with(width: 92%)
  show figure.caption: par.with(justify: false)

  // for printing, render code in a monochrome theme
  set raw(theme: "./res/bw-theme.tmTheme") if print
  // render code blocks with a grey background and external padding
  show raw.where(block: true): it => {
    set par(justify: false)
    set align(left)
    v(8pt)
    block(
      width: 100%,
      fill: luma(248),
      spacing: 0pt,
      outset: 8pt,
      radius: 4pt,
    )[#it]
    v(8pt)
  }

  import "@preview/outrageous:0.1.0"
  set outline(indent: true)
  show outline.entry: outrageous.show-entry.with(
    font: (none, none),
    // very hacky way to format appendices differently
    // there's gotta be a better way, but I don't see it
    body-transform: (lvl, body) => {
      if "children" in body.fields() {
        let (num, ..text) = body.children
        if regex("^[A-Z]$") in num.text {
          return "Appendix " + num + ": " + text.join()
        }
      }
      body
    }
  )

  set heading(numbering: "1.1")
  show heading.where(level: 1): it => {
    // TODO: it is better to have a weak page break here, but currently,
    //  Typst seems to have a bug: https://github.com/typst/typst/issues/2841
    pagebreak(weak: false)

    show: block

    let use-supplement = it.outlined and it.numbering != none
    if (use-supplement) {
      text(size: 13pt, fill: rgb(120, 120, 120))[
        #it.supplement #counter(heading).display(it.numbering)
      ]
      linebreak()
      v(-16pt)
    }
    
    text(size: 22pt, weight: "medium")[
      #it.body
    ]

    if (use-supplement) {
      v(22pt)
    } else {
      v(5.5pt)
    }
  }

  show heading.where(level: 2): it => {
    block(it, below: 11pt)
  }

  // TODO: probably find a style that has footnotes, but also a usable
  //  consistent indexing
  //set cite(style: "chicago-notes")
  
  set bibliography(style: "ieee", title: none)
  show bibliography: it => {
    heading("Bibliography")

    set text(size: 9pt)
    set par(justify: false)
    columns(2, it)
  }

  
  introduction(print, meta.submission-date, ..intro-args)

  // start numbering from the first page of actual text
  set page(numbering: "1")
  counter(heading).update(0)
  counter(page).update(1)
  
  body
}

// call this function after bibliography using an `everything show` rule:
//   #show: start-appendix
#let start-appendix(body) = {
  set heading(supplement: "Appendix", numbering: "A.1")
  counter(heading).update(0)
  body
}

#let todo(msg) = {
  counter("todo").step()
  [#text(fill: red, weight: "bold")[TODO: #msg]]
}

#let note(msg) = {
  counter("note").step()
  [#block(fill: yellow, width: 100%, inset: 3pt, radius: 3pt)[NOTE: #msg]]
}
