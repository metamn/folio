jQuery.noConflict();
     
// Use jQuery via jQuery(...)
jQuery(document).ready(function(){
  
  var horizontal = "";
  for (i=0; i<400; i++) {
    horizontal += '<div class="col">&nbsp;</div>';
  }
  
  var vertical = ""
  for (i=0; i<500; i++) {
    vertical += '<div class="col">&nbsp;</div>';
  }
  
  jQuery("body").append(
    '<div id="gridh" class="grid">' + horizontal + '</div>' +
    '<div id="gridv" class="grid">' + vertical + '</div>'
  );
    
});   
