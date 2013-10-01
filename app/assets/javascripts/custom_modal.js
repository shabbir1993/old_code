jQuery(function() {
  $('body').on('hidden', '.modal', function () {
      $(this).removeData('modal');
  });

  $("#inventory-form").bind("ajax:success", function(event, data, status, xhr) {
    $("#film-actions-modal .modal-body").html(data);
    $("#film-actions-modal").modal('show');
  });
});
