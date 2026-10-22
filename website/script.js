const navLinks = document.querySelectorAll("#nav-navigation a");

const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      navLinks.forEach(link => link.classList.remove("active"));
      const activeLink = document.querySelector(`#nav-navigation a[href="#${entry.target.id}"]`);
      if (activeLink) activeLink.classList.add("active");
    }
  });
}, {
  threshold: 0.4
});

document.querySelectorAll("main section").forEach(section => observer.observe(section));
