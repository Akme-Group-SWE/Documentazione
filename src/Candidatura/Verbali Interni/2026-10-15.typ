#import "../../Templates/templateVerbali.typ": *

#show: report.with(
  titolo: "Verbale interno 15/10/2026",
  stato: "Approvato",
  versione: "1.0.0",
  registro-modifiche: (
    ("1.0.0", "18/10/2026", "Davide Loparco", "Davide Loparco", "Revisione del documento e approvazione finale"),
    ("0.2.0", "17/10/2026", "Roberto Piovesan", "Davide Loparco", "Integrazione discussione capitolati e attività"),
    ("0.1.0", "16/10/2026", "Roberto Piovesan", "Davide Loparco", "Prima stesura del verbale"),
  ),
  odg: (
    "Definizione way of working",
    "Creazione nome e logo del gruppo",
    "Creazione dell'indirizzo email",
    "Scelta dei canali di comunicazione",
    "Discussione dei capitolati",
  ),
  partecipanti: (
    "Pietro Giulio Bassi",
    "Mattia Cadamuro",
    "Chen Daxin",
    "Marco Giacon",
    "Davide Loparco",
    "Roberto Piovesan",
  ),
  distribuzione: (
    "Akme Group",
    "Prof. Cardin Riccardo",
    "Prof. Vardanega Tullio",
  ),
  verificatore-interno: "Davide Loparco",
  left-signature: "firma-Loparco.jpeg",
  tipo-verbale: "Interno",
)

= Informazioni generali
Si certifica che il giorno *15 ottobre 2026*, dalle 17:40 alle 19:00, si è tenuto un incontro virtuale del gruppo Akme Group. La sessione è stata organizzata con l'obiettivo di stabilire un *way of working*#super[G] e definire l'identità del gruppo, compresi il nome e la scelta del logo.

= Resoconto
== Denominazione e Canali di Contatto
A seguito di una breve discussione, è stata approvata la proposta di Davide Loparco di adottare *Akme Group* come nome ufficiale. Contestualmente, per la gestione di tutte le comunicazioni ufficiali verso l'esterno, è stato attivato l'indirizzo email: *akmeswe\@gmail.com*.

== Definizione del Logo e dell'Identità Visiva
Il gruppo ha valutato e approvato all'unanimità due versioni del logo, progettate per garantire massima versatilità a seconda del contesto di applicazione: una variante estesa per grandi dimensioni (Figura 1) e una versione compatta per spazi ridotti (Figura 2).

#align(center)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 1.5em,
    figure(
      image("/src/shared/logo-big1.png", width: 80%),
      caption: [Versione per grandi dimensioni.],
    ),
    figure(
      image("/src/shared/logo-small1.png", width: 32%),
      caption: [Versione compatta.],
    ),
  )
]

== Scelta dei canali di comunicazione
Per la gestione delle attività e del coordinamento interno, sono stati adottati i seguenti canali:
- *WhatsApp#super[G]:* utilizzato per le comunicazioni brevi e quotidiane;
- *Discord#super[G]:* utilizzato come piattaforma principale per le riunioni da remoto.

== Discussione dei capitolati
#align(center)[
  #table(
    columns: (1fr, 2fr, 2fr, 1.5fr),
    align: (center + horizon, left + horizon, left + horizon, center + horizon),
    fill: (x, y) => if y == 0 { rgb("e6ecf2") } else { none },
    stroke: 0.5pt + luma(150),
    inset: 8pt,

    [*Preferenza*], [*Codice e Titolo Capitolato*], [*Azienda Proponente*], [*Azione Prevista*],
    [1°], [C2 - NEXUM Concierge], [EGGON], [Richiesta incontro],
    [2°], [C0 - AIRA: AI Requests Automation], [San Marco Informatica], [Richiesta incontro],
    [3°], [C8 - Sonar: Documentazione vivente], [Halue], [-],
  )
]

#v(4pt)
#text(size: 0.9em, style: "italic")[
  *Nota:* È stato deciso di contattare via email le aziende *EGGON* e *San Marco Informatica* per fissare un incontro di approfondimento sui rispettivi capitolati.
]

== Strumenti e Gestione Documentale
- *Redazione:* Come linguaggio per la redazione della documentazione è stato adottato *Typst*#super[G], scelto per la sintassi semplice e la ricchezza di funzionalità.
- *Template Standard:* Verranno sviluppati modelli (template) standard per uniformare la stesura dei futuri documenti.
- *Versionamento e Automazione:* La documentazione sarà gestita tramite *GitHub*#super[G]. La pubblicazione su *GitHub Pages*#super[G] avverrà in modo automatico mediante l'integrazione con le *GitHub Actions*#super[G].

= Decisioni e attività
Il gruppo alla fine dell'incontro ha deciso come suddividersi i compiti con relative scadenze.

#figure(
  table(
    columns: (2.2fr, 2.2fr, 1fr),
    align: (left + horizon, left + horizon, left + horizon),
    stroke: (x, y) => if y == 0 { (bottom: 1.2pt + black) } else { (bottom: 0.6pt + black) },
    fill: none,
    inset: (y: 7pt, x: 5pt),

    [*Descrizione*], [*Responsabile*], [*Scadenza*],
    [Redazione del verbale], [Roberto Piovesan], [18/10/2026],
    [Creazione sito _GitHub Pages_ e Glossario#super[G]], [Chen Daxin, Marco Giacon], [21/10/2026],
    [Creazione template _Typst_], [Mattia Cadamuro], [21/10/2026],
    [Contatto aziende], [Pietro Giulio Bassi, Davide Loparco], [20/10/2026],
  ),
  caption: [Decisioni intraprese e attività conseguenti],
) <tab-decisioni>
