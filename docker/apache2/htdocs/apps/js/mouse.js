(function() {
  const draggable = document.querySelector("#drag");
  const dropzones = Array.from(document.querySelectorAll(".drop"));
  const message = document.querySelector("#message");
  let parent = null;

  // Inspired by https://dev.to/lensco825/making-a-simple-drag-and-drop-with-js-29l2

  dropzones.forEach((zone) => {
    zone.addEventListener("dragover", (event) => {
      event.preventDefault();
      zone.appendChild(draggable);
      parent = zone;
    });
  });

  dropzones.forEach((zone) => {
    zone.addEventListener("dragover", () => {
      zone.classList.add("hover");
    });
    zone.addEventListener("dragleave", () => {
      zone.classList.remove("hover");
    });
  });

  draggable.addEventListener("drag", () => {
    draggable.classList.add("dragging");
  });

  draggable.addEventListener("dragend", () => {
    draggable.classList.remove("dragging");
    let target = parent.classList[1] // hack, just assume drop is first
    message.innerHTML = `Dragged to ${target}.`;
  });

  const button = document.querySelector("#button");
  button.addEventListener("click", (event) => {
    message.innerHTML = "Clicked button";
  });
  button.addEventListener("dblclick", (event) => {
    message.innerHTML = "Double clicked button";
  });
})();
