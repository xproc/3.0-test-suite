(function() {
  const button = document.querySelector("button");
  const div = document.querySelector("div");

  let seconds = 2;

  const showPara = function() {
    window.setTimeout(function () {
      div.innerHTML = "<p id='hello'>Hello, world.</p>"
    }, seconds * 1000);
  }

  button.addEventListener("click", (event) => {
    showPara();
  });
})();
