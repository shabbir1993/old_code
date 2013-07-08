jQuery(function() {
  $('body').on('click', '.remove-fields', function(event) {
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('fieldset').hide();
    event.preventDefault();
  });
 
  $('body').on('click', '.add-fields', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    event.preventDefault();
  });

  $('body').on('change', '#film_destination', function(event) {
    var backend_destinations = ["stock", "testing", "nc", "scrap"]
    $('.destination-fields').hide();
    if ($.inArray($(this).val(), backend_destinations) !== -1)
    {
      $('#backend-destination-fields').show();
    }
    if ($(this).val() === "wip")
    {
      $('#checkout-destination-fields').show();
    } 
  });
});

