jQuery(function() {

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
    $(this).closest('.add-fields-link-wrapper').before($(this).data('fields').replace(regexp, time));
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
});
