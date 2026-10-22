/*
  Libreria di utilità per la documentazione di Akme Group.
  Fornisce funzioni per la gestione dei link a repository, issue, pull request su GitHub.
*/

/*
  Ritorna la descrizione di una repository secondo una stringa identificativa.

  = Parametri
  == repo
  Stringa che rappresenta una repository dell'organizzazione:
  - "docs": repo Documentazione
  - "poc": repo PoC
  - "actions": repo GitHub Actions
  - "backend", "frontend", ecc.

  = Valore di ritorno
  Tupla (repo-desc, repo-name, repo-long)
*/
#let repo-description-from-str(repo) = {
  repo = lower(repo)
  let repo-name
  let repo-desc
  let repo-long

  if (repo == "docs" or repo == "documentazione") {
    repo-name = "Documentazione"
    repo-desc = "Docs"
    repo-long = "documentazione"
  }
  else if (repo == "poc") {
    repo-name = "PoC"
    repo-desc = "PoC"
    repo-long = "PoC"
  }
  else if (repo == "action" or repo == "actions") {
    repo-name = "actions"
    repo-desc = "actions"
    repo-long = "GitHub Actions"
  }
  else if (repo == "mvp") {
    repo-name = "MVP"
    repo-desc = "MVP"
    repo-long = "MVP"
  }
  else {
    repo-name = repo
    repo-desc = repo
    repo-long = repo
  }

  return (repo-desc, repo-name, repo-long)
}

/*
  Ritorna lo URL di una repository o risorsa specifica su GitHub.
*/
#let get-url(url-type, repo-string) = {
  let (repo-desc, repo-name, repo-long) = repo-description-from-str(repo-string)
  let base-url = "https://github.com/Akme-Group-SWE"

  if url-type == "base" {
    (base-url, repo-name).join("/")
  }
  else if url-type == "issue" {
    (base-url, repo-name, "issues").join("/")
  }
  else if url-type == "pr" {
    (base-url, repo-name, "pull").join("/")
  }
  else if url-type == "prs" {
    (base-url, repo-name, "pulls").join("/")
  }
  else {
    panic("url-type sconosciuto: " + str(url-type))
  }
}

/*
  Ritorna un link cliccabile a una issue specifica.
  Esempio: #issue(12) o #issue(5, repo: "poc")
*/
#let issue(number, repo: "docs") = {
  let (repo-desc, _, _) = repo-description-from-str(repo)
  let issue-url = get-url("issue", repo) + "/" + str(number)

  link(issue-url)[*#repo-desc/\##number*]
}

#let issue_full(number, repo: "docs") = {
  let (_, _, repo-long) = repo-description-from-str(repo)
  let issue-url = get-url("issue", repo) + "/" + str(number)

  link(issue-url)[*Issue \##number (repo #repo-long)*]
}

/*
  Ritorna un link cliccabile a una pull request specifica.
*/
#let pr(number, repo: "docs") = {
  let (repo-desc, _, _) = repo-description-from-str(repo)
  let pr-url = get-url("pr", repo) + "/" + str(number)

  link(pr-url)[*#repo-desc/\##number*]
}

/*
  Ritorna un link cliccabile a una repository.
*/
#let repo(quale, body) = {
  let repo-url = get-url("base", quale)
  link(repo-url, body)
}

