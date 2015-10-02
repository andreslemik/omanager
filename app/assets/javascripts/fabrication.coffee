$(document).on 'click', '#item-get-ready', ->
  id = $('#order_item_dept_id :selected').val()
  item_id = $(@).data('id')
  id = id || 0
  if id != 0
    $.ajax
      url: item_id + '/get_ready'
      method: 'PUT'
