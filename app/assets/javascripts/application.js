// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

function get_gist_comments(gist_id, element){
  converter = new Showdown.converter();

  $.getJSON(
    'https://gist.github.com/api/v1/json/' + gist_id + '?callback=?', function(response){

      $.each(response['gists'][0]['comments'], function(key, val) {
        element.append(
          '<div>' +
          '<img class="gravatar" src="http://gravatar.com/avatar/' + val.gravatar_id + '.png?r=PG&s=20"/> ' +
          val.user + converter.makeHtml(val.body) +
          '</div>'
        );
      });

    }
  );
}

$(document).ready(function(){

  $('.comments').each(function(){
    get_gist_comments($(this).data('gist_id'), $(this));
  });

  $('a.extend').click(function(){
    $(this).parent().css('height', 'auto');
    $(this).remove();
  });

  $('ul#entries.voting li.unvoted div.files').css('height', 'auto');
  $('ul#entries.voting li.unvoted a.extend').hide();

  $('.new_vote input[type="submit"]').hide();
  $('.new_vote input').change(function(){
    $(this).parent().submit();
  })

  var unvoted = $('li.unvoted')
  unvoted.hide();
  if(unvoted.length > 0) {
    $('#main').append('<a class="button vote">Vote</a>');
  }

  $('a.vote').click(function(){
    var lis = $('ul#entries li.unvoted');
    var index = 0;
    var li = lis[index];

    if(lis.length >= 1){
      lis.append('<span class="skip">or <a>skip this entry</a></span>')

      lis.append('<span class="entries_left"/>')
      if(lis.length <= 1){
        $('span.skip').hide();
        $('span.entries_left').text('You\'re at the last entry')
      } else {
        $('span.entries_left').text(lis.length + ' entries left to rate');
      }
    }

    $('ul.voting').addClass('voting_box')
    $('ul.voting').after('<div class="overlay"/>')

    $('div.overlay').click(function(){
      window.location.reload();
    })
    $(this).css('margin-top', '20px')
    $('ul#entries li').hide();
    $(li).show();

    $('ul#entries span.skip a').click(function(){
      $(li).hide()
      index ++
      if(index >= lis.length){ index = 0; }
      li = lis[index]
      $(li).show()
    })

    $('.new_vote').bind('ajax:success', function() {
      lis.splice(index, 1);

      if(lis.length <= 1){
        $('span.skip').hide();
        $('span.entries_left').text('You\'re at the last entry')
      } else {
        $('span.entries_left').text(lis.length + ' entries left to rate');
      }

      index ++
      if(index >= lis.length){ index = 0; }
      next_li = lis[index]

      if($(next_li).length > 0) {
        $(li).hide()
        $(next_li).show()
        li = next_li
      } else {
        window.location.reload()
      }

    });
  });
});
