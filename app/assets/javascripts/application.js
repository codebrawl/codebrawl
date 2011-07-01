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

  // using datejs to allow for more human readable date input on contest starting on
  var contestStartingOn = $('input#contest_starting_on'),
    hidden,
    parser,
    hint,
    defaultHintText;
  if (contestStartingOn.get(0)) {
    parser          = $('<input id="starting_on_parser" name="starting_on_parser" type="text" />');
    hint            = $('#starting_on_parser_hint');
    defaultHintText = hint.text();
    hidden          = $('<input type="hidden" />');

    hidden.attr({
      id: contestStartingOn.attr('id'),
      name: contestStartingOn.attr('name'),
      value: contestStartingOn.attr('value')
    });

    // whenver the user inputs something into the parser, it updates the display and the hidden field
    parser
      .bind('change keyup blur', function(){
        var parsedDate = Date.parse(this.value);
        if (parsedDate) {
          parsedDate = parsedDate.toString("d MMM yyyy");
          hint.text(parsedDate);
          hidden.val(parsedDate);
        } else {
          hint.text(defaultHintText)
        }
      })
      .val(contestStartingOn.val());

    // replace the input with the hidden actual element as hidden form input and put the parser element in place
    contestStartingOn
      .after(parser)
      .replaceWith(hidden);
    hint.insertAfter(parser);
  }
});
