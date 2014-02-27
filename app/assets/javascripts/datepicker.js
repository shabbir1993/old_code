jQuery(function() {

  function enableDatepicker() {
    $('.bootstrap-datepicker').datepicker({
      format: 'yyyy-mm-dd'
    });
  }

  enableDatepicker()

  $(document).ajaxSuccess(function() {
    enableDatepicker()
  });
});
