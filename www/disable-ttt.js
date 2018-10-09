$(document).ready(function() {
  
  f = function() {
    console.log('updating');
    if ($('#ttt1risk')[0][0].text != 'Define a Custom Risk Group') {
      shinyjs.disable('ttt1progression-rate');
      shinyjs.disable('ttt1prevalence-rate');
      shinyjs.disable('ttt1mortality-rate');
    } else {
      shinyjs.enable('ttt1progression-rate');
      shinyjs.enable('ttt1prevalence-rate');
      shinyjs.enable('ttt1mortality-rate');
    }
  };
  
  $('#ttt1risk').on('change', function() {setTimeout(f, 100)});

});