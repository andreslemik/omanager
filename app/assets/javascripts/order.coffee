$(document).on 'change', '.categories', ->
  id = @.id.replace(/[^0-9\.]/g,'')
  category_id = @.value
  select = $('#order_order_items_attributes_' + id + '_manufacturer')
  products = $('#order_order_items_attributes_'+id+'_product_id')
  $.ajax(
    url: '/products/manufacturers/' + category_id
    dataType: 'JSON'
    success: (data) ->
      select.html('')
      products.html('')
      select.append('<option value></option>')
      $.each(data, (key, val) ->
        select.append('<option id="' + val.id + '" ctg="'+category_id+'">' + val.name + '</option>')
      )
    error: ->
      select.html('<option id="-1">Укажите категорию</option>')
  )

$(document).on 'change', '.manufacturers', ->
  id = @.id.replace(/[^0-9\.]/g,'')
  manufacturer_id = $(@).children(':selected').attr('id')
  category_id = $(@).children(':selected').attr('ctg')
  select = $('#order_order_items_attributes_' + id + '_product_id')
  $.ajax
    url: '/products/by_category_mfc/'+category_id+'/'+manufacturer_id
    dataType: 'JSON'
    success: (data) ->
      select.html('')
      select.append('<option value></option>')
      $.each(data, (key, val) ->
        select.append('<option id="' + val.id + '">' + val.name + '</option')
      )
    error: ->
      select.html('<option id="-1">Укажите категорию и производителя</option>')

$(document).on 'change', '.products', ->
  id = @.id.replace(/[^0-9\.]/g,'')
  product_id = $(@).children(':selected').attr('id')
  price = $('#order_order_items_attributes_' + id + '_cost')
  $.ajax
    url: '/products/price/' + product_id
    dataType: 'JSON'
    success: (data) ->
      price.val(data.price)
    error: ->
      price.val(0)