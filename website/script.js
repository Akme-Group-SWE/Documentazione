const navLinks = document.querySelectorAll("#nav-navigation a");
const sections = document.querySelectorAll("main section");
const main = document.querySelector("main");
const navNav = document.querySelector("#nav-navigation");

if (sections.length > 0 && navLinks.length > 0) {
  const setActiveLink = (id) => {
    navLinks.forEach(link => {
      const isMatch = link.getAttribute("href") === `#${id}`;
      if (isMatch) {
        if (!link.classList.contains("active")) {
          link.classList.add("active");
        }
        // Se la lista di navigazione ha uno scroll, mantiene visibile l'elemento attivo
        if (navNav && navNav.scrollHeight > navNav.clientHeight) {
          link.scrollIntoView({ block: "nearest", inline: "nearest" });
        }
      } else {
        link.classList.remove("active");
      }
    });
  };

  const updateActiveSection = () => {
    if (sections.length === 0) return;

    // Rileva se lo scroll è gestito da main (desktop) o window/body (mobile)
    const isMainScrollable = main && (main.scrollHeight > main.clientHeight) && window.getComputedStyle(main).overflowY !== "visible";

    const scrollTop = isMainScrollable ? main.scrollTop : (window.scrollY || document.documentElement.scrollTop);
    const scrollHeight = isMainScrollable ? main.scrollHeight : document.documentElement.scrollHeight;
    const clientHeight = isMainScrollable ? main.clientHeight : window.innerHeight;

    // Se si è all'inizio della pagina, attiva sempre la prima sezione
    if (scrollTop <= 10) {
      setActiveLink(sections[0].id);
      return;
    }

    // Se si è arrivati in fondo alla pagina, attiva l'ultima sezione
    if (scrollTop + clientHeight >= scrollHeight - 10) {
      setActiveLink(sections[sections.length - 1].id);
      return;
    }

    const containerTop = isMainScrollable ? main.getBoundingClientRect().top : 0;
    const offset = 120; // Offset di lettura dal top

    let currentSectionId = sections[0].id;

    for (let i = 0; i < sections.length; i++) {
      const rect = sections[i].getBoundingClientRect();
      const relativeTop = rect.top - containerTop;

      if (relativeTop <= offset) {
        currentSectionId = sections[i].id;
      } else {
        break;
      }
    }

    setActiveLink(currentSectionId);
  };

  // Ottimizzazione eventi di scroll con requestAnimationFrame
  let ticking = false;
  const onScroll = () => {
    if (!ticking) {
      window.requestAnimationFrame(() => {
        updateActiveSection();
        ticking = false;
      });
      ticking = true;
    }
  };

  if (main) {
    main.addEventListener("scroll", onScroll, { passive: true });
  }
  window.addEventListener("scroll", onScroll, { passive: true });

  // Gestione click sui link della sidebar
  navLinks.forEach(link => {
    link.addEventListener("click", () => {
      const targetId = link.getAttribute("href")?.replace("#", "");
      if (targetId) {
        setActiveLink(targetId);
      }
    });
  });

  // Chiamata immediata e al caricamento completo
  updateActiveSection();
  window.addEventListener("load", updateActiveSection);
}
