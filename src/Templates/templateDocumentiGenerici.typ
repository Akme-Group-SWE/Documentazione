#import "../lib/libDocumentiGenerici.typ": *
#import "../lib/libUtil.typ": *

#let primary = rgb("#000000")
#let secondary = rgb("#1a1a1a")
#let gray-dark = rgb("#2c3e50")

#let gloss(term) = [*#term#sub[G]*]

#let report(
  titolo: none,
  stato: none,
  versione: none,
  distribuzione: ("Akme Group", "Prof. Cardin Riccardo", "Prof. Vardanega Tullio"),
  htmlId: none,
  registro-modifiche: (),
  verificatore-interno: "",
  left-signature: "",
  tipo-documento: "",
  index: "0",
  body,
) = [
  #show link: underline

  #let versione-auto = if versione != none {
    versione
  } else if registro-modifiche != none and registro-modifiche.len() > 0 {
    registro-modifiche.first().at(0)
  } else {
    ""
  }

  #set document(
    title: titolo,
    author: "Akme Group",
    keywords: (htmlId, versione-auto, index),
  )

  #set page(
    paper: "a4",
    margin: (
      top: 2cm,
      bottom: 2cm,
      left: 2.5cm,
      right: 2.5cm,
    ),
  )

  #set heading(numbering: "1.")

  #set par(
    justify: true,
    leading: 0.75em,
    spacing: 1.2em,
  )

  #show: hwr.with(
    language: "it",
    main-font: "PT Sans",

    metadata: (
      title: titolo,
      version: if versione-auto != "" [Versione #text(weight: "bold")[#versione-auto]] else [Versione 1.0.0],
      company-logo: image("../shared/logo-big1.png", width: 70%),
      uni-logo: image("../shared/logo_unipd_scritta.jpg", width: 51%),
    ),

    custom-entries: (
      (key: "Stato", value: stato, index: 0),
      (
        key: "Distribuzione",
        value: if distribuzione != none {
          for d in distribuzione {
            d + "\n"
          }
        } else { "" },
        index: 1,
      ),
    ),
    tipo-documento: tipo-documento,
    verificatore-interno: verificatore-interno,
    label-signature-left: [Firma del revisore interno],
    left-signature: left-signature,
  )

  #pagebreak()
  #counter(page).update(1)

  #set page(
    header: [
      #set text(10pt, fill: secondary)
      #grid(
        columns: (1fr, 1fr),
        align(left)[
          #move(dy: 2pt)[
            #image("../shared/logo-small1.png", height: 16pt)
          ]
        ],
        align(right)[
          #text(size: 11pt)[
            #titolo
          ]
        ],
      )
      #line(length: 100%, stroke: 0.5pt)
    ],
    footer: [
      #set text(11pt)
      #line(length: 100%, stroke: 0.5pt)
      #v(0.5em)
      #align(center)[
        #context [
          Pagina #counter(page).display() di #counter(page).final().at(0)
        ]
      ]
    ],
  )

  #if registro-modifiche != none and registro-modifiche.len() > 0 [
    #block()[
      #text(size: 12pt, weight: "bold")[
        #heading(outlined: false, numbering: none)[Registro Modifiche]
      ]

      #table(
        columns: (0.1fr, 0.14fr, 0.22fr, 0.22fr, 0.32fr),
        align: left,
        stroke: (x, y) => (
          bottom: if y == 0 { 1pt + black } else { 0.8pt + black },
        ),
        table.header([*Ver.*], [*Data*], [*Autore*], [*Verificatore*], [*Descrizione*]),
        ..for (ver, data, autore, verificatore, descrizione) in registro-modifiche {
          ([#ver], [#data], [#autore], [#verificatore], [#descrizione])
        },
      )
    ]
    #pagebreak()
  ]

  #v(1em)
  #outline(indent: 1em)

  #pagebreak()

  #body
]

