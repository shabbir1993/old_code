idleTime = 0;
$(document).ready(function () {
  // Increment the idle time counter every minute.
  var idleInterval = setInterval(timerIncrement, 60000);
  $(this).mousemove(function (e) {
    idleTime = 0;
  });
  $(this).keypress(function (e) {
    idleTime = 0;
  });
});

function timerIncrement() {
  idleTime = idleTime + 1;
  if (idleTime > 4) {
    window.location = document.getElementById('logout').href
  }
}
