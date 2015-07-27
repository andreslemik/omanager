#= require jquery
#= require jquery.turbolinks
#= require jquery_ujs
#= require foundation
#= require turbolinks


initial = ->
  $(document).foundation()
  setDatepicker()

$(document).on('ready page:load', initial)