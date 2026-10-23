#let primary = rgb("#000000")
#let secondary = rgb("#1a1a1a")
#let gray-dark = rgb("#2c3e50")

#let gloss(term) = [*#term#sub[G]*]

#let report(
  titolo: none,
  stato: "Approvato",
  versione: none,
  partecipanti: (),
  distribuzione: ("Akme Group", "Prof. Cardin Riccardo", "Prof. Vardanega Tullio"),
  htmlId: none,
  index: "0",
  odg: (),
  registro-modifiche: (),
  verificatore-interno: "",
  left-signature: "",
  verificatore-esterno: "",
  right-signature: "",
  tipo-verbale: "Interno",
  body,
) = {
  let versione-auto = if versione != none {
    versione
  } else if registro-modifiche != none and registro-modifiche.len() > 0 {
    registro-modifiche.first().at(0)
  } else {
    "1.0"
  }

  let kw = ()
  if htmlId != none { kw.push(str(htmlId)) }
  if versione-auto != none { kw.push(str(versione-auto)) }
  if index != none { kw.push(str(index)) }

  set document(
    title: if titolo != none { titolo } else { "" },
    author: "Akme Group",
    keywords: kw,
  )

  set text(
    font: "Lato",
    lang: "it",
    size: 11pt,
  )

  show link: underline

  // Configurazione prima pagina (copertina)
  set page(
    paper: "a4",
    margin: (x: 2.5cm, y: 2.5cm),
    footer: context {
      if counter(page).get().first() == 1 [
        #align(center)[
          Gruppo: Akme Group\
          Email: akmeswe\@gmail.com
        ]
      ]
    },
  )

  // Header prima pagina con i due loghi
  v(1cm)
  grid(
    columns: (1fr, 1fr),
    align(left + horizon)[
      #image("/src/shared/logo_unipd_scritta.jpg", width: 70%)
    ],
    align(right + horizon)[
      #image("/src/shared/logo-big1.png", width: 80%)
    ],
  )

  v(1cm)

  // Titolo racchiuso tra linee
  line(length: 100%, stroke: 0.5pt)
  v(0.1cm)
  align(center)[
    #text(size: 22pt, weight: "bold")[#titolo]
  ]
  v(0.1cm)
  line(length: 100%, stroke: 0.5pt)

  v(1cm)



  // Tabella informazioni
  let partecipanti-content = if type(partecipanti) == array {
    partecipanti.join([\ ])
  } else {
    partecipanti
  }

  let distribuzione-content = if type(distribuzione) == array {
    distribuzione.join([\ ])
  } else {
    distribuzione
  }

  align(center)[
    #table(
      columns: (auto, auto),
      align: (right, left),
      stroke: (x, y) => if x == 0 { (right: 0.5pt + luma(150)) } else { none },
      inset: (x: 1.2em, y: 0.5em),
      [*Stato*], [#stato],
      [*Versione*], [#versione-auto],
      [*Partecipanti*], [#partecipanti-content],
      [*Distribuzione*], [#distribuzione-content],
    )
  ]

  v(2cm)

  // Ordine del giorno (se presente)
  if odg != none and odg.len() > 0 [
    #align(center)[
      #text(size: 17pt, weight: "bold")[Ordine del giorno]
    ]

    #set enum(numbering: "1.")
    #pad(left: 20%, right: 10%)[
      #for item in odg [
        + #item
      ]
    ]
    #v(1cm)
  ]
  // Passaggio alla seconda pagina
  pagebreak()

  // Layout delle pagine successive
  set page(
    header: [
      #grid(
        columns: (auto, 1fr),
        align(left)[
          #image("/src/shared/logo-small1.png", height: 2em)
        ],
        align(right + horizon)[
          #text(size: 11pt)[#titolo]
        ],
      )
      #v(-0.5em)
      #line(length: 100%, stroke: 1pt)
    ],
    footer: [
      #line(length: 100%, stroke: 1pt)
      #v(0.5em)
      #context align(center)[
        Pagina #counter(page).display() di #counter(page).final().first()
      ]
    ],
    margin: (top: 3cm, bottom: 3cm, x: 2.5cm),
  )

  // Registro modifiche (se presente)
  if registro-modifiche != none and registro-modifiche.len() > 0 [
    #text(size: 14pt, weight: "bold")[Registro delle modifiche]
    #v(0.5em)
    #table(
      columns: (0.12fr, 0.16fr, 0.24fr, 0.24fr, 0.34fr),
      align: left,
      stroke: (x, y) => if y == 0 { (bottom: 1.2pt + black) } else { (bottom: 0.6pt + black) },
      inset: (y: 7pt, x: 5pt),
      table.header([*Ver.*], [*Data*], [*Autore*], [*Verificatore*], [*Descrizione*]),
      ..for (ver, data, autore, verificatore, descrizione) in registro-modifiche {
        ([#ver], [#data], [#autore], [#verificatore], [#descrizione])
      },
    )
    #pagebreak()
  ]

  // Indice
  text(size: 14pt, weight: "bold")[Indice]
  v(0.5em)
  outline(
    title: none,
    indent: 1.5em,
    depth: 2,
  )

  pagebreak()

  set heading(numbering: "1.")
  set par(
    justify: true,
    leading: 0.75em,
    spacing: 1.2em,
  )

  body

  // Blocco firme finale
  if verificatore-interno != "" or left-signature != "" or verificatore-esterno != "" or right-signature != "" [
    #pagebreak()
    #v(1cm)
    #if verificatore-esterno != "" or right-signature != "" {
      grid(
        columns: (1fr, 1fr),
        gutter: 2cm,
        [
          #if verificatore-interno != "" [*#verificatore-interno* \ ]
          #if left-signature != "" [
            #let sig = if left-signature.starts-with("/") or left-signature.starts-with(".") { left-signature } else { "/src/shared/firme/" + left-signature }
            #image(sig, width: 80%)
          ]
          #line(length: 80%, stroke: 0.5pt + black)
          #v(0.2cm)
          Firma del revisore interno
        ],
        [
          #if verificatore-esterno != "" [*#verificatore-esterno* \ ]
          #if right-signature != "" [
            #let sig = if right-signature.starts-with("/") or right-signature.starts-with(".") { right-signature } else { "/src/shared/firme/" + right-signature }
            #image(sig, width: 80%)
          ]
          #line(length: 80%, stroke: 0.5pt + black)
          #v(0.2cm)
          Firma del revisore esterno
        ],
      )
    } else {
      [
        #if verificatore-interno != "" [*#verificatore-interno* \ ]
        #if left-signature != "" [
          #let sig = if left-signature.starts-with("/") or left-signature.starts-with(".") { left-signature } else { "/src/shared/firme/" + left-signature }
          #image(sig, width: 40%)
        ]
        #line(length: 40%, stroke: 0.5pt + black)
        #v(0.2cm)
        Firma del revisore interno
      ]
    }
  ]
}
