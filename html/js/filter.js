'use strict';

document.addEventListener("keydown", filter, false);

function filter(event) {
  if (event.code == 'F2') {
    document.querySelectorAll("tr").forEach(function (row) {
      let fail = row.querySelector("td.fail") != null;
      let pass = row.querySelector("td.pass") != null;
      let unk = row.querySelector("td.unknown") != null;
      if (pass || fail || unk) {
        // It's a result row
        if (pass && !fail && !unk) {
          row.style.display = "none";
        }
      }
    });
  }
}
