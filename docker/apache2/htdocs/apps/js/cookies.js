(function() {
  counter = 0;

  function showCookies() {
    const div = document.querySelector("#cookies");
    let count = 0
    let inner = "<table><thead><tr><th>Name</th><th>Value</th></tr></thead>"
    inner += "<tbody>";
    document.cookie.split("; ").forEach(cookie => {
      if (cookie.startsWith("cookie") || cookie.startsWith("selenium")) {
        count++;
        tokens = cookie.split("=")
        inner += `<tr><td>${tokens[0]}</td><td>${tokens[1]}</td></tr>`
      }
    });
    if (count == 0) {
      div.innerHTML = "";
    } else {
      div.innerHTML = `${inner}</tbody></table>`
    }
  }

  function setCookie(name, value, seconds) {
    var expires = "";
    if (seconds) {
        var date = new Date();
        date.setTime(date.getTime() + (seconds*1000));
        expires = "; expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + (value || "")  + expires + "; SameSite=Strict; path=/";
  }

  function setupButton(id) {
    let button = document.querySelector(`#${id}`);
    button.addEventListener("click", (event) => {
      setCookie(`cookie${++counter}`, button.innerHTML, 5)
      showCookies()
    });
  }

  setupButton("hobnail")
  setupButton("chocchip")
  setupButton("sugar")
  showCookies()
})();
