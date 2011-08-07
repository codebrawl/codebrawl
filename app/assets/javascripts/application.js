// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require address

$.address.change(function(event) {
  filename = event.value.substring(1)
  if($('ul.files li').length > 0){
    menu_item = $('ul.menu li[data-filename="' + filename + '"]')
    if($(menu_item).length == 0){ menu_item =$('ul.menu li:first') };

    $('ul.menu li').removeClass('current').removeClass('before')
    $('ul.files li').hide()
    menu_item.addClass('current').prev().addClass('before')
    $('ul.files li[data-filename="' + filename + '"]').show()
  }
});

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
  
  $('li.entry').each(function(){
    menu_items = $(this).find('ul.menu li')
    $(menu_items).css('width', 100 / menu_items.length + '%')
  }); 

  $('.comments').each(function(){
    get_gist_comments($(this).data('gist_id'), $(this));
  });

  $('a.extend').click(function(){
    $(this).parent().css('height', 'auto');
    $(this).remove();
  });

  $('ul#entries.voting li.unvoted div.files').css('height', 'auto');
  $('ul#entries.voting li.unvoted a.extend').hide();

  $('li.unvoted .new_vote input[type="submit"]').hide();
  $('.new_vote input').change(function(){
    $(this).parent().submit();
  })

  var unvoted = $('li.unvoted')
  unvoted.hide();
  if(unvoted.length > 0) {
    $('.message').after('<a class="button vote">Vote</a>');
  }

  $('a.vote').click(function(){

    var lis = $('ul#entries li.unvoted');
    lis.sort(function() { return 0.5 - Math.random() })

    var index = 0;
    var li = lis[index];

    $('#wrapper').css('position', 'static');
    $('body').css('overflow', 'hidden');
    $('#adzerk_ad_div').hide();

    var menu_item = $(li).show()

    //
    //if(lis.length >= 1){
    //  form = lis.find('form')
    //  form.
    //    append('<span class="skip">or <a>skip this entry</a></span>').
    //    append('<span class="entries_left"/>')
    //
    //  if(lis.length <= 1){
    //    $('span.skip').hide();
    //    $('span.entries_left').text('You\'re at the last entry')
    //  } else {
    //    $('span.entries_left').text(lis.length + ' entries left to rate');
    //  }
    //}
    //
    //$('ul.voting').addClass('voting_box')
    //$('ul.voting').after('<div class="overlay"/>')
    //
    //$('div.overlay').click(function(){
    //  window.location.reload();
    //})
    //$('ul#entries li.voted, ul#entries li.unvoted').hide();
    //$(li).show();
    //
    //$('ul#entries span.skip a').click(function(){
    //  $(li).hide()
    //  index ++
    //  if(index >= lis.length){ index = 0; }
    //  li = lis[index]
    //  $(li).show()
    //})
    //
    //$('.new_vote').bind('ajax:success', function() {
    //  lis.splice(index, 1);
    //
    //  if(lis.length <= 1){
    //    $('span.skip').hide();
    //    $('span.entries_left').text('You\'re at the last entry')
    //  } else {
    //    $('span.entries_left').text(lis.length + ' entries left to rate');
    //  }
    //
    //  index ++
    //  if(index >= lis.length){ index = 0; }
    //  next_li = lis[index]
    //
    //  if($(next_li).length > 0) {
    //    $(li).hide()
    //    $(next_li).show()
    //    li = next_li
    //  } else {
    //    window.location.reload()
    //  }
    //
    //});
  });
});
