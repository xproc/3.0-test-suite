(function() {
  const keys = document.querySelector("#keys");
  const message = document.querySelector("#message");
  let pressed = {}

  const showPressed = function(dir, up) {
    let down = ""
    for (code in pressed) {
      if (down !== "") {
        down += ", "
      }
      down += pressed[code]
    }
    if (up !== "") {
      message.innerHTML = dir + " " + down + " :: " + up
    } else {
      message.innerHTML = dir + " " + down
    }
  }  

  keys.addEventListener('keydown', (event) => {
    if (event.key != "Tab") {
      event.preventDefault();
    }

    let down = "";
    if (event.ctrlKey) {
      down += "ctrl "
    }
    if (event.altKey) {
      down += "alt "
    }
    if (event.shiftKey) {
      down += "shift "
    }
    if (event.metaKey) {
      down += "meta "
    }
    down += event.key
    pressed[event.code] = down
    showPressed("↓", "")
  });

  keys.addEventListener('keyup', (event) => {
    if (event.key != "Tab") {
      event.preventDefault();
    }

    let up = "";
    if (event.ctrlKey) {
      up += "ctrl "
    }
    if (event.altKey) {
      up += "alt "
    }
    if (event.shiftKey) {
      up += "shift "
    }
    if (event.metaKey) {
      up += "meta "
    }
    up += event.key
    delete pressed[event.code]
    showPressed("↑", up)
  });
})();
