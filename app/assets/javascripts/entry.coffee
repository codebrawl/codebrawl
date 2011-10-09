#= require jquery
#= require address

$.address.change (event) ->
  filename = event.value.substring(1)
  $('ul.files li').hide()
  li = $('ul.files li#[data-filename="' + filename + '"]')
  if li.length > 0
    li.show()
  else
    $('ul.files li:first-child').show()
