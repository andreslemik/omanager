$(document).on 'change', 'input[name="order[order_type]"]', ->
  order_type = @.value
  $.ajax(
    url: $('#url').val()
    dataType: 'script'
    data: { order_type: order_type }
    success: ->
      setDatepicker()
  )
