#import "./template/template.typ": *

#show: template.with(
  meta: (
    title: "An Interesting Thesis Title",
    author: (
      name: "Jan Novák",
      email: "someone@fel.cvut.cz",
      url: "https://my.project/url",
    ),
    submission-date: datetime(year: 2012, month: 1, day: 21),

    // true for bachelor's thesis, false for master's thesis
    bachelor: false,
    supervisor: "Ing. Jan Novák, PhD.",

    faculty: "Faculty of Electrical Engineering",
    department: "Department of Measurement",
    study-programme: "Open Informatics",
    branch-of-study: "Computer Engineering", // studijni obor
  ),

  // set to true if generating a PDF for print (shifts page layout, turns code blocks greyscale, correctly aligns odd/even pages,...)
  print: false,

  abstract-en: [
    #lorem(40)
    
    #lorem(60)
  ],

  abstract-cz: [
    #lorem(40)
    
    #lorem(60)
  ],

  acknowledgement: [
    #lorem(30)
    
    #lorem(30)
  ],
)

= Introduction

#lorem(80)

#lorem(120)

#lorem(140)

#lorem(40)

#lorem(70)

= Background

== Part 1

#lorem(100)

=== Subpart 1

#lorem(40)

=== Subpart 2

#lorem(70)

== Part 2

#lorem(100)

= Future work

#lorem(100)

= Conclusion

#lorem(100)


#bibliography("bibliography.bib")


// all h1 headings from here on are appendices
#show: start-appendix

= An example appendix

#lorem(100)