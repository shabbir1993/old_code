jQuery(function() {
  $("#forms-modal").on('click', '.show-password-fields', function(event) {
    $(".password-fields").show()
    $(".show-password-fields").hide()
    event.preventDefault();
  });
});
