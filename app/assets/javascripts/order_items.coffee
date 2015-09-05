retail = ->
  $('#order_item_retail').val()
# select product_category
$(document).on 'change', '#order_item_category', ->
  category_id = @.value
  manufacturer_select = $('#order_item_manufacturer')
  product_select = $('#order_item_product_id')
  price = $('#order_item_cost')
  $.ajax
    url: '/products/manufacturers/' + category_id
    dataType: 'JSON'
    success: (data) ->
      manufacturer_select.html('')
      product_select.html('')
      price.val(0)
      $('#option_values_0').html('')
      manufacturer_select.append('<option value></option>')
      $.each(data, (key, val) ->
        manufacturer_select.append('<option value="' + val.id + '" ctg="'+category_id+'">' + val.name + '</option>')
      )
    error: ->
      manufacturer_select.html('<option id="-1">Укажите категорию</option>')
      price.val('')
      $('#option_values_0').html('')
      products.html('')

# select manufacturer
$(document).on 'change', '#order_item_manufacturer', ->
  manufacturer_id = @.value
  category_id = $(@).children(':selected').attr('ctg')
  select = $('#order_item_product_id')
  price = $('#order_item_cost')
  $.ajax
    url: '/products/by_category_mfc/'+category_id+'/'+manufacturer_id
    dataType: 'JSON'
    success: (data) ->
      select.html('')
      price.val('')
      $('#option_values_0').html('')
      select.append('<option value></option>')
      $.each(data, (key, val) ->
        select.append('<option value="' + val.id + '">' + val.name + '</option')
      )
    error: ->
      select.html('<option id="-1">Укажите категорию и производителя</option>')
      price.val('')
      $('#option_values').html('')

# select product
$(document).on 'change', '#order_item_product_id', ->
  product_id = @.value
  price = $('#order_item_cost')
  $.ajax
    url: '/products/price/'  + product_id + '/' + + retail()
    dataType: 'JSON'
    success: (data) ->
      price.val(data.price)
    error: ->
      price.val(0)
      $('#option_values_0').html('')
  cnt = $.ajax(
    url: '/products/option_values/' + product_id
    async: false
  ).responseText
  if $.parseJSON(cnt).option_values > 0
    $.ajax(
      url: '/products/option_values/' + product_id + '/0'
      dataType: 'SCRIPT'
    )
  else
    $('#option_values_' + id).html('')

$(document).on 'change', '.option_values_select', ->
  x= []
  $('.option_values_select').each ->
    x.push($(@).children(':selected').attr('value'))
  product_id = $('#order_item_product_id').children(':selected').attr('value')
  id = 0
  price = $('#order_item_cost')
  $.ajax
    url: '/products/price/' + product_id + '/' + retail() + '/' + x
    dataType: 'JSON'
    success: (data) ->
      price.val(data.price)
    error: ->
      price.val(0)
      $('#option_values_' +id).html('')