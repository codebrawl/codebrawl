//= require jquery
//= require address

$.address.change(function(event) {
  filename = event.value.substring(1)
  if(filename.length > 0){
    $('#sidebar li').each(function(){ $(this).removeClass('current')})
    $('ul#files li').hide()
    $('ul#drawer li[data-filename="' + filename + '"]').addClass('current');
    $('ul#files li[data-filename="' + filename + '"]').show().addClass('current');
  }
});

$(document).ready(function(){
  $('#entry').prepend('<div id="sidebar"><ul id="drawer"></ul></div>');
  $('ul#files li').each(function(){
    $('ul#drawer').append('<li data-filename="' + $(this).attr('data-filename') + '"><a href="#' + $(this).attr('data-filename') + '">' + $(this).attr('data-filename') + '</li>');
  });

  $('ul#files li').hide()
  $('ul#files li:first').show().addClass('current');
  $('ul#drawer li:first').addClass('current');
});
