#import "../templateDocumentiGenerici.typ": *

#show: report.with(
  titolo: "Norme di Progetto",
  tipo-documento: "Norme di Progetto",
  stato: "In lavorazione",
  versione: "1.0.0",
  registro-modifiche: (
    ("1.0.0", "22/10/2026", "Mattia Cadamuro", "Roberto Piovesan", "Riorganizzazione processi e sezioni"),
    ("0.2.0", "20/10/2026", "Chen Daxin", "Davide Loparco", "Aggiunta standard documentali"),
    ("0.1.0", "18/10/2026", "Davide Loparco", "Pietro Giulio Bassi", "Struttura iniziale del documento"),
  ),
  distribuzione: (
    "Akme Group",
    "Prof. Cardin Riccardo",
    "Prof. Vardanega Tullio",
  ),
  htmlId: "NormeDiProgetto",
  verificatore-interno: "Roberto Piovesan",
  left-signature: "firma-Piovesan.jpeg",
)

= Introduzione
== Scopo del documento
Il presente documento ha lo scopo di definire le norme, le convenzioni e gli standard che ciascun membro del gruppo *Akme Group* è tenuto a rispettare durante l'intero ciclo di vita del progetto.

== Glossario
Al fine di evitare ambiguità e incomprensioni sui termini utilizzati nei documenti ufficiali, i termini tecnici o con significato specifico sono contrassegnati con una lettera "G" ad apice e definiti puntualmente nel #gloss("Glossario").

= Processi primari
== Sviluppo
Il processo di sviluppo include tutte le attività necessarie alla progettazione, implementazione e test del prodotto software:
- Definizione dell'architettura;
- Codifica secondo le linee guida aziendali;
- Esecuzione delle suite di test automatici in pipeline di Continuous Integration (#gloss("CI")).

= Processi di supporto
== Gestione della configurazione
Tutti i componenti del progetto sono versionati tramite #gloss("Git") e ospitati su repository GitHub. Per garantire la tracciabilità delle modifiche, ogni commit deve seguire la convenzione Conventional Commits.

