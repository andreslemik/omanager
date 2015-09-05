retail = ->
  $('#retail').val()
$(document).on 'change', '.categories', ->
  id = @.id.replace(/[^0-9\.]/g,'')
  category_id = @.value
  select = $('#order_order_items_attributes_' + id + '_manufacturer')
  products = $('#order_order_items_attributes_'+id+'_product_id')
  price = $('#order_order_items_attributes_' + id + '_cost')
  $.ajax(
    url: '/products/manufacturers/' + category_id
    dataType: 'JSON'
    success: (data) ->
      select.html('')
      products.html('')
      price.val('')
      $('#option_values_' + id).html('')
      select.append('<option value></option>')
      $.each(data, (key, val) ->
        select.append('<option id="' + val.id + '" ctg="'+category_id+'" value="'+val.id+'">' + val.name + '</option>')
      )
    error: ->
      select.html('<option id="-1">Укажите категорию</option>')
      price.val('')
      $('#option_values_' + id).html('')
      products.html('')
  )

$(document).on 'change', '.manufacturers', ->
  id = @.id.replace(/[^0-9\.]/g,'')
  manufacturer_id = $(@).children(':selected').attr('id')
  category_id = $(@).children(':selected').attr('ctg')
  select = $('#order_order_items_attributes_' + id + '_product_id')
  price = $('#order_order_items_attributes_' + id + '_cost')
  $.ajax
    url: '/products/by_category_mfc/'+category_id+'/'+manufacturer_id
    dataType: 'JSON'
    success: (data) ->
      select.html('')
      price.val('')
      $('#option_values_' + id).html('')
      select.append('<option value></option>')
      $.each(data, (key, val) ->
        select.append('<option value="' + val.id + '">' + val.name + '</option')
      )
    error: ->
      select.html('<option id="-1">Укажите категорию и производителя</option>')
      price.val('')
      $('#option_values_' +id).html('')

$(document).on 'change', '.products', ->
  id = @.id.replace(/[^0-9\.]/g,'')
  product_id = @.value
  price = $('#order_order_items_attributes_' + id + '_cost')
  $.ajax
    url: '/products/price/'  + product_id + '/' + retail()
    dataType: 'JSON'
    success: (data) ->
      price.val(data.price)
    error: ->
      price.val(0)
      $('#option_values_' +id).html('')
  cnt = $.ajax(
    url: '/products/option_values/' + product_id
    async: false
  ).responseText
  if $.parseJSON(cnt).option_values > 0
    $.ajax(
      url: '/products/option_values/' + product_id + '/' + id
      dataType: 'SCRIPT'
    )
  else
    $('#option_values_' + id).html('')

$(document).on 'change', '#order_retail_client', ->
  if @.checked
    $('.retail').show()
    $('.corporate').hide()
    $('#retail').val(1)
  else
    $('.retail').hide()
    $('.corporate').show()
    $('#retail').val(0)

$(document).on 'change', '.option_values_select', ->
  values= []
  $('.option_values_select').each ->
    values.push($(@).children(':selected').attr('value'))
  product_id = $('.products').children(':selected').attr('value')
  id = @.id.replace(/[^0-9\.]/g,'')
  price = $('#order_order_items_attributes_' + id + '_cost')
  url = '/products/price/' + product_id + '/' + retail() + '/' + values
  $.ajax
    url: url + '?attr_name=order[order_items_attributes]'
    dataType: 'JSON'
    success: (data) ->
      price.val(data.price)
    error: ->
      price.val(0)
      $('#option_values_' +id).html('')


$(document).on 'click', '.delete_order_item', ->
  id =  $(@).data('id')
  select = 'tr[data-id=' + id + ']'
  row = $(select)
  destroy = $(select + ' input[name*="_destroy"]' )
  if row.data('del') == 0
    row.data('del', 1)
    row.css('text-decoration', 'line-through')
    destroy.val(true)
    $(select + ' .delete_order_item i.icon').removeClass('fi-x')
    $(select + ' .delete_order_item i.icon').addClass('fi-refresh')
  else
    row.data('del', 0)
    destroy.val(false)
    row.css('text-decoration', 'none')
    $(select + ' .delete_order_item i.icon').removeClass('fi-refresh')
    $(select + ' .delete_order_item i.icon').addClass('fi-x')