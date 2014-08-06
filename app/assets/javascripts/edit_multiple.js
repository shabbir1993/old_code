jQuery(function() {

  $("#get-edit-multiple").on("ajax:success", function(event, data, status, xhr) {
    $("#forms-modal .modal-content").html(data);
    $("#forms-modal").modal('show');
  }).children().on("ajax:success", function(e) {
    return false;
  });

  // enables submit buttons
  $("input.film-select").click(function() {
    var unchecked = $('input.film-select:checked').length;
    if (unchecked >= 1) {
      $('.submit-selected').removeAttr('disabled');
    }
    else {
      $('.submit-selected').attr('disabled', 'disabled');
    }
  });
});
