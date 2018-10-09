$(document).ready(function() {
  
  f1 = function() {
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
  
  f2 = function() {
    if ($('#ttt2risk')[0][0].text != 'Define a Custom Risk Group') {
      shinyjs.disable('ttt2progression-rate');
      shinyjs.disable('ttt2prevalence-rate');
      shinyjs.disable('ttt2mortality-rate');
    } else {
      shinyjs.enable('ttt2progression-rate');
      shinyjs.enable('ttt2prevalence-rate');
      shinyjs.enable('ttt2mortality-rate');
    }
  };
  
    f3 = function() {
    if ($('#ttt3risk')[0][0].text != 'Define a Custom Risk Group') {
      shinyjs.disable('ttt3progression-rate');
      shinyjs.disable('ttt3prevalence-rate');
      shinyjs.disable('ttt3mortality-rate');
    } else {
      shinyjs.enable('ttt3progression-rate');
      shinyjs.enable('ttt3prevalence-rate');
      shinyjs.enable('ttt3mortality-rate');
    }
  };
  
  
  $('#ttt1risk').on('change', function() {setInterval(f1, 100)});
  $('#ttt2risk').on('change', function() {setInterval(f2, 100)});
  $('#ttt3risk').on('change', function() {setInterval(f3, 100)});

});