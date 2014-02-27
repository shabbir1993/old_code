jQuery(function() {

  // resets modal data when closed
  $('body').on('hidden.bs.modal', '.modal', function () {
      $(this).removeData('bs.modal');
  });
});
