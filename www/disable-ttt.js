// Enable or Disable the Relative Rates for Risk Groups based on Risk Group 
// 
// f returns curried functions, i.e. by passing n to f we get back a function 
// which knows n and will disable/enable the nth TTT panel's relative rates 
// according to whether or not the risk group is "Define a Custom Risk Group"
//
// When a change is made to the risk group in the nth TTT panel, a setInterval 
// is run so that f(n)() is run every 100 milliseconds. 
//
// TODO: Will applying many of these setIntervals slow down the app? What about
// in slow/old/bad browsers?

$(document).ready(function() {
  
	f = function(n) {
		return function() {
			if ($('#ttt' + n + 'risk')[0][0].text != 'Define a Custom Risk Group') {
				shinyjs.disable('ttt' + n + 'progression-rate');
				shinyjs.disable('ttt' + n + 'prevalence-rate');
				shinyjs.disable('ttt' + n + 'mortality-rate');
			} else {
				shinyjs.enable('ttt' + n + 'progression-rate');
				shinyjs.enable('ttt' + n + 'prevalence-rate');
				shinyjs.enable('ttt' + n + 'mortality-rate');
			}
		};
	};

  
  $('#ttt1risk').on('change', function() {setInterval(f(1), 100)});
  $('#ttt2risk').on('change', function() {setInterval(f(2), 100)});
  $('#ttt3risk').on('change', function() {setInterval(f(3), 100)});

});
