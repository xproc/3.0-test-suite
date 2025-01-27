(function() {
  let seconds = 0
  let span = document.querySelector("#seconds")

  const timer = function() {
    window.setTimeout(function () {
      span.innerHTML = `${seconds}`;
      seconds++;
      timer();
    }, 1000);
  }

  timer();
})();
