# Sorgente Documentazione - Akme Group

In questa cartella si trovano tutti i sorgenti [Typst](https://typst.app/) per la documentazione del gruppo **Akme Group**, suddivisi per fase e tipologia.

---

## Struttura della cartella `src/`

- **`Templates/`**: contiene i template principali per i documenti:
  - `templateVerbali.typ`: template per i verbali interni ed esterni, provvisto di testata, ordine del giorno, tabella partecipanti, registro modifiche e sezione firme.
  - `templateDocumentiGenerici.typ`: template per documenti ufficiali (Norme di Progetto, Piano di Progetto, Piano di Qualifica, Analisi dei Requisiti, ecc.).
  - `templateSlides.typ` e `templateSlidesRTB.typ`: template per presentazioni e slide (basati sul package `polylux`).
- **`lib/`**: funzioni e moduli di supporto:
  - `libVerbali.typ`: impaginazione, layout prima pagina e blocco firme per i verbali.
  - `libDocumentiGenerici.typ`: impaginazione per documenti generici.
  - `libLetter.typ`: layout per lettere di presentazione formali.
  - `libUtil.typ`: funzioni ausiliarie per generare link a repository, issue e pull request (`#issue()`, `#pr()`, `#repo()`).
  - `libRequisiti.typ`: funzioni di supporto per il tracciamento dei requisiti.
- **`shared/`**: risorse condivise tra i documenti:
  - `logo-big1.png`: logo esteso con testo scuro per documenti su fondo bianco.
  - `logo-small1.png`: logo icona scuro per l'intestazione delle pagine dei documenti.
  - `logo-big2.png` / `logo-small2.png`: loghi bianchi per sfondi scuri / sito web.
  - `logo_unipd_scritta.jpg` / `Logo_Università_Padova.svg-300x300.png`: loghi ufficiali dell'Università degli Studi di Padova.
  - `fonts/`: font `PT Sans` e `Lato` per garantire una resa tipografica uniforme.
  - `firme/`: immagini delle firme dei componenti del gruppo per i verbali e documenti.
- **`Candidatura/`**: documenti e verbali della fase di candidatura.
- **`RTB/`**: documenti e verbali della fase Requirements and Technology Baseline.
- **`PB/`**: documenti e verbali della fase Product Baseline.
- **`Diario di Bordo/`**: resoconti periodici e slide delle presentazioni.

---

## Esempio d'uso: Verbale di riunione

Per creare un nuovo verbale (es. `src/Candidatura/Verbali Interni/2025-10-22.typ`):

```typst
#import "../../Templates/templateVerbali.typ": *

#show: report.with(
  titolo: "Verbale interno 22/10/2025",
  stato: "Verificato",
  versione: "1.0.0",
  registro-modifiche: (
    ("1.0.0", "23/10/2025", "Marco Giacon", "Roberto Piovesan", "Versione finale approvata"),
    ("0.1.0", "22/10/2025", "Marco Giacon", "Roberto Piovesan", "Prima stesura verbale"),
  ),
  partecipanti: (
    "Roberto Piovesan",
    "Marco Giacon",
    "Pietro Giulio Bassi",
    "DaXin Chen",
    "Mattia Cadamuro",
    "Davide Loparco",
  ),
  distribuzione: (
    "Akme Group",
    "Prof. Cardin Riccardo",
    "Prof. Vardanega Tullio",
  ),
  odg: (
    "Punto 1 all'ordine del giorno",
    "Punto 2 all'ordine del giorno",
  ),
  htmlId: "Candidatura-VerbaliInterni",
  verificatore-interno: "Roberto Piovesan",
  left-signature: "../shared/firme/firma-Piovesan.jpeg",
  tipo-verbale: "Interno",
)

= Introduzione
Testo introduttivo del verbale...

= Resoconto
== Discussione punto 1
Dettagli discussione...
```

---

## Esempio d'uso: Documento generico

```typst
#import "../../Templates/templateDocumentiGenerici.typ": *

#show: report.with(
  titolo: "Valutazione Capitolati",
  stato: "In lavorazione",
  registro-modifiche: (
    ("0.1.0", "22/10/2025", "DaXin Chen", "Mattia Cadamuro", "Bozza iniziale"),
  ),
  distribuzione: (
    "Akme Group",
    "Prof. Cardin Riccardo",
    "Prof. Vardanega Tullio",
  ),
  htmlId: "Candidatura-Generale",
  verificatore-interno: "Mattia Cadamuro",
  left-signature: "../shared/firme/firma-Cadamuro.jpeg",
  tipo-documento: "Valutazione Capitolati",
)

= Introduzione
Contenuto del documento...
```

---

## Esempio d'uso: Lettera formale

```typst
#import "../../lib/libLetter.typ": *

#show: almost-tud-letter.with(
  title: "Lettera di Presentazione",
  from: (
    name: "Akme Group",
    email: "akmeswe@gmail.com",
  ),
  to: [
    Alla cortese attenzione di \
    Prof. Vardanega Tullio \
    Prof. Cardin Riccardo \
  ],
  date: "2025-10-31",
  subject: "Candidatura capitolato C...",
  logo: "../shared/logo-big1.png",
  htmlId: "Candidatura-Generale",
  versione: "1.0.0",
)

Egregi professori...
```

