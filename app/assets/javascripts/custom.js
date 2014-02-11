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

  $("#get-edit-multiple").on("ajax:success", function(event, data, status, xhr) {
    $("#forms-modal").html(data).modal('show');
  }).children().on("ajax:success", function(e) {
    return false;
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

  $('#forms-modal').on('click', '.remove-hstore-fields', function(event) {
    $(this).closest('.form-group').html('');
    event.preventDefault();
  });
 
  $('#forms-modal').on('click', '.add-fields', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $('.add-fields-link-wrapper').before($(this).data('fields').replace(regexp, time));
    event.preventDefault();
  });

  $('#forms-modal').on('click', '.add-hstore-fields', function(event) {
    $('.add-fields-link-wrapper').before($(this).data('fields'));
    event.preventDefault();
  });

  $('#forms-modal').on('change', '.dynamic-attr-key', function(event){
    nameElem  = $(this);
    valueElem = nameElem.closest('.form-group').find('.dynamic-attr-value');
    value     = nameElem.val();
    valueElem.attr('id', 'master_film_defects_' + value);
    valueElem.attr('name', 'master_film[defects][' + value + ']');
  })

  // enables edit multiple button
  $("input.film-select").click(function() {
    var unchecked = $('input.film-select:checked').length;
    if (unchecked >= 1) {
      $('#films-edit-multiple').removeAttr('disabled');
    }
    else {
      $('#films-edit-multiple').attr('disabled', 'disabled');
    }
  });
});
