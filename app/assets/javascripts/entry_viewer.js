//= require jquery
//= require address
//= require showdown

$.address.change(function(event) {
  filename = event.value.substring(1)
  if(filename.length > 0){
    $('#sidebar li').each(function(){ $(this).removeClass('current')})
    $('ul#files li[data-filename]').hide()
    $('ul#drawer li[data-filename="' + filename + '"]').addClass('current');
    $('ul#files li[data-filename="' + filename + '"]').show().addClass('current');
  }
});

$(document).ready(function(){
  var converter = new Showdown.converter();
  var comments = $('li[data-filename="comments"]')
  var gist_id = comments.data('gist_id')

  $.getJSON(
    'https://gist.github.com/api/v1/json/' + gist_id + '?callback=?', function(response){
      $('a[href="#comments"]').prepend('<span>' + response['gists'][0]['comments'].length + '</span> ')

      $.each(response['gists'][0]['comments'], function(key, val) {
        comments.find('span.comment_box').before(
          '<li><span class="filename"><img class="gravatar" src="http://gravatar.com/avatar/' + val.gravatar_id + '.png?r=PG&s=20"/> ' + val.user + '</span>' + converter.makeHtml(val.body) + '</li>'
        );
      });
    }
  );

  $('#sidebar').append('<ul id="drawer"/>');
  $('#sidebar input[type="submit"]').hide();
  $('input').change(function(){
    $(this).parent().submit();
  })

  $('ul#files li[data-filename]').each(function(){
    $('ul#drawer').append(
      '<li class="' + $(this).attr('data-filename') + '"data-filename="' + $(this).attr('data-filename') + '">' +
      '<a href="#' + $(this).attr('data-filename') + '">' +
      $(this).attr('data-filename') + '</a></li>'
    );
  });

  $('ul#files li').hide()
  $('ul#files li:first').show().addClass('current');
  $('ul#drawer li:first').addClass('current');
});
