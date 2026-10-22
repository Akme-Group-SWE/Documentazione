#import "../templateVerbali.typ": *

#show: report.with(
  titolo: "Verbale Interno 22/10/2026",
  stato: "Approvato",
  versione: "1.0.0",
  registro-modifiche: (
    ("1.0.0", "22/10/2026", "Chen Daxin", "Roberto Piovesan", "Versione approvata"),
    ("0.1.0", "22/10/2026", "Davide Loparco", "Chen Daxin", "Prima stesura verbale"),
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
  odg: (
    "Verifica e allineamento dei template Typst",
    "Organizzazione cartella test per i template",
    "Pianificazione prossime attività di gruppo",
  ),
  htmlId: "Candidatura-VerbaliInterni",
  verificatore-interno: "Chen Daxin",
  left-signature: "firma-Chen.png",
  tipo-verbale: "Interno",
)

= Informazioni generali
In data *22 ottobre 2026*, i membri del gruppo Akme Group si sono riuniti in via telematica per discutere e collaudare i modelli grafici della documentazione di progetto.

= Resoconto
== Allineamento dei template
Si è proceduto alla standardizzazione grafica dei file Typst in modo da garantire un layout coerente per tutti i documenti:
- Copertina istituzionale con logo UniPD e logo del gruppo;
- Header e footer con tracciamento della numerazione delle pagine;
- Registro delle modifiche e indice automatico.

== Risultati dei test
Tutti i documenti compilano correttamente senza produrre avvisi o errori di formattazione.

= Decisioni e attività
#figure(
  table(
    columns: (2fr, 2fr, 1fr),
    align: (left + horizon, left + horizon, left + horizon),
    stroke: (x, y) => if y == 0 { (bottom: 1.2pt + black) } else { (bottom: 0.6pt + black) },
    inset: (y: 7pt, x: 5pt),

    [*Attività*], [*Incaricato*], [*Scadenza*],
    [Finalizzazione dei template], [Mattia Cadamuro], [23/10/2026],
    [Revisione verbali], [Roberto Piovesan], [24/10/2026],
  ),
  caption: [Riepilogo delle decisioni],
)

