Shiny.addCustomMessageHandler("tabby:altupdate", function(msg) {
  $(msg.selector).data("alt", msg.alt);
});

$(document).ready(function() {
  $(".shiny-plot-output").on("shiny:value", function(e) {
    var $plot = $(this);
    var $img = $(this).children("img");
    $img.attr("alt", $plot.data("alt"));
  });
  $(".shiny-plot-output img").on("load", function(e) {
    var $img = $(this);
    var $plot = $img.closest(".shiny-plot-output");
    $img.attr("alt", $plot.data("alt"));
  });
});
