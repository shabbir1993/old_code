jQuery(function() {
  $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    $('#dimensions-map').highcharts().setSize($('#dimensions-map').width(),$('#dimensions-map').height());
  });
});
