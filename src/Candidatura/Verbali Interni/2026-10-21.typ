#import "../../Templates/templateVerbali.typ": *

#show: report.with(
  titolo: "Verbale interno 21/10/2026",
  stato: "Approvato",
  versione: "1.0.0",
  registro-modifiche: (
    ("1.0.0", "23/10/2026", "Roberto Piovesan", "Roberto Piovesan", "Revisione del documento e approvazione finale"),
    ("0.1.0", "22/10/2026", "Davide Loparco", "Roberto Piovesan", "Integrazione discussione capitolati e attività"),
  ),
  odg: (
    "Review template documenti", "Raccolta domande per i capitolati", "Discussione disponibilità orarie",
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
  verificatore-interno: "Roberto Piovesan",
  left-signature: "firma-Piovesan.jpeg",
  tipo-verbale: "Interno",
)

= Informazioni generali
Con il presente verbale si certifica che Akme Group si è riunito in data 21/10/2026 dalle 17:30 alle 18:40 con l'intento di revisionare quanto prodotto dall'ultimo incontro e definire gli aspetti da approfondire con le aziende proponenti.

= Resoconto

== Revisione e approvazione template
A seguito di una revisione da parte del team sono stati approvati e quindi presi in adozione i template typst#super[G] prodotti.
Il team si riserva la possibilità di creare ulteriori template in futuro, qualora fosse necessario.

== Raccolta domande
Il team si è impegnato in un brainstorming per raccogliere le domande da porre alle aziende proponenti, in modo da chiarire ambiguità e dubbi sorti dalla lettura dei capitolati. Le domande saranno poste durante i colloqui con le aziende contattate.

== Discussione disponibilità orarie
Poiché le aziende che hanno risposto alle email da parte del team hanno chiesto delle preferenze di orario per effettuare dei colloqui conoscitivi, sono state individuate delle fasce orarie ottimali in cui potesse essere presente il maggior numero di membri del team.
La fascia oraria ideale risulta essere compresa tra le 16:00 e le 17:30.

= Decisioni e attività
In data 22/10/2026 è previsto un incontro con Halue per il capitolato C8 (Sonar). L'appuntamento avverrà via Google Meet con il referente Valentino Baraldo, dalle 16:00 alle 16:30.

A seguire, la suddivisione dello svolgimento delle attività di questa settimana.

#figure(
  table(
    columns: (2.2fr, 2.2fr, 1fr),
    align: (left + horizon, left + horizon, left + horizon),
    stroke: (x, y) => if y == 0 { (bottom: 1.2pt + black) } else { (bottom: 0.6pt + black) },
    fill: none,
    inset: (y: 7pt, x: 5pt),

    [*Descrizione*], [*Responsabile*], [*Scadenza*],
    [Redazione del verbale odierno], [Davide Loparco], [23/10/2026],
    [Creazione e gestione organization Github#super[G]], [Mattia Cadamuro, Chen DaXin], [23/10/2026],
    [Creazione label per issue nella repo], [Marco Giacon], [25/10/2026],
    [Redazione del verbale esterno], [Pietro Giulio Bassi, Roberto Piovesan], [25/10/2026],
  ),
  caption: [Decisioni intraprese e attività conseguenti],
) <tab-decisioni>