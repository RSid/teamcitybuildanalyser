var moreInfo;
moreInfo = function() {
  $(".datapoint").mouseover(function() {
    var id = this.id;
    $('#' + id).append(' hi')
  });
};

$( document ).ready(moreInfo);
$(document).on('page:load', moreInfo);
