// preloader
$(document).on('turbolinks:load', function(){ 
  $('.preloader').fadeOut(1000); // set duration in brackets    
});

$(function() {
    new WOW().init();
})
