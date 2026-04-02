(function() {
  let summary = document.querySelector("#iknowwhatyoudid")

  document.querySelectorAll("button.but").forEach((button) => {
    button.onclick = function(event) {
      summary.innerHTML = `You clicked ${button.id}.`;
    }
  });

  let input_i1 = document.querySelector("input[name='i1']");
  let input_i2 = document.querySelector("#i2");
  let input_textbox = document.querySelector("#text");

  let button = document.querySelector("#text-update");
  button.onclick = function(event) {
    let message = "You updated ";
    let something = false;
    if (input_i1.value != "" && input_i2.value != "") {
      message += "the first text box and the second ";
      something = true;
    } else {
      if (input_i1.value != "") {
        message += "the first text box ";
        something = true;
      }
      if (input_i2.value != "") {
        message += "the second text box ";
        something = true;
      }
    }
    if (input_textbox.value != "") {
      if (something) {
        message += "and the text box"
      } else {
        something = true;
        message += "the text box"
      }
    }
    if (!something) {
      message += "nothing."
    }
    message = message.trim();
    summary.innerHTML = message;
  }

  document.querySelectorAll("input[type='radio']").forEach((button) => {
    button.onclick = function(event) {
      summary.innerHTML = `You selected ${event.target.value}.`;
    }
  });

  const frogs = document.querySelector("#frog-select");
  frogs.onchange = function(event) {
    const selected = event.target.value;
    const name = {
      "common-frog": "common frog",
      "common-toad": "common toad",
      "natterjack": "natterjack toad",
      "northern-pool": "northern pool frog"
    }
    if (selected === "") {
      summary.innerHTML = "You selected nothing.";
    } else {
      let message = `You selected the ${name[event.target.value]}`;
      if (message.indexOf("toad") >= 0) {
        message += " (I said 'frog', but I'll allow it)";
      }
      summary.innerHTML = message;
    }
  };

  const numbers = document.querySelector("#number-select");
  numbers.onchange = function(event) {
    let message = ""
    numbers.querySelectorAll("option").forEach((opt) => {
      if (opt.selected) {
        if (message !== "") {
          message += ", ";
        }
        message += `${opt.value}`;
      }
    });
    if (message === "") {
      summary.innerHTML = "You selected none.";
    } else if (message === "2, 3, 5, 7") {
      summary.innerHTML = "You selected the primes!";
    } else {
      summary.innerHTML = `You selected ${message}.`;
    }
  };
})();
