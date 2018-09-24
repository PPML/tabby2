$(document).ready(function() {
    $("label[for='agegroupYears']")
    .attr('tabindex', '0')
    .first()
    .append("<span class='sr-only'> After tabbing to the next element, use the up and down arrow keys in the next input-element to select the year.</span>");

    $("label[for='estimatesLabels']")
    .attr('tabindex', '0')
    .first()
    .append("<span class='sr-only'> After tabbing to the next element, use the up and down arrow keys to select the data labels shown in the visualization.</span>");

});
