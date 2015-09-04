#= require jquery
#= require jquery.turbolinks
#= require jquery_ujs
#= require jquery-ui/datepicker
#= require jquery-ui/datepicker-ru
#= require foundation
#= require jquery_nested_form

#= require turbolinks


@setDatepicker = ->
  $("input.datepicker").each (i) ->
    $(this).datepicker
      altFormat: "yy-mm-dd"
      dateFormat: "dd.mm.yy"
      altField: $(this).next()
      regional: "ru"

initial = ->
  $(document).foundation()
  setDatepicker()

$(document).on('ready page:load', initial)

$(document).on 'click', '.clear-datepicker', (e) ->
  $(this).closest('.row.collapse input.datepicker').attr('value', '')
  false

$(document).ajaxStart ->
  Turbolinks.ProgressBar.start()
$(document).ajaxSuccess ->
  Turbolinks.ProgressBar.done()