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

  $("#get-edit-multiple").bind("ajax:success", function(event, data, status, xhr) {
    $("#forms-modal").html(data).modal('show');
  });

  // resets modal data when closed
  $('body').on('hidden.bs.modal', '.modal', function () {
      $(this).removeData('bs.modal');
  });

  $('#forms-modal').on('click', '.remove-fields', function(event) {
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('fieldset').hide();
    event.preventDefault();
  });
 
  $('#forms-modal').on('click', '.add-fields', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $('.add-fields-link-wrapper').before($(this).data('fields').replace(regexp, time));
    event.preventDefault();
  });

  // enables edit multiple button
  $("input.film-select").click(function() {
    var unchecked = $('input.film-select:checked').length;
    if (unchecked >= 1) {
      $('#film-edit-multiple').removeAttr('disabled');
    }
    else {
      $('#film-edit-multiple').attr('disabled', 'disabled');
    }
  });
});
