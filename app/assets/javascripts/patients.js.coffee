# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

APTS = {}
APTS.setup = ->

  #add div to end of page
  $("<div id=\"ajaxAptInfo\"></div>").hide().appendTo $("body")
  $("#show_appointment").on "click", "a", APTS.getInfo
  false

APTS.getInfo = ->
  $.ajax
    type: "GET"
    url: $(this).attr("href")
    timeout: 5000
    success:  APTS.showInfo
    error: ->
      alert "Error loading appointment"

  false


#data is ajax return obj
APTS.showInfo = (data) ->

  #center is 1/2 wide 1/4 tall as screen
  oneFourth = Math.ceil($(window).width() / 4)
  $("#ajaxAptInfo").html(data).css(
    left: oneFourth
    width: 2 * oneFourth
    top: 250
  ).show()

  #make close link work
  $("#closeLink").click APTS.hideInfo
  false

APTS.hideInfo = ->
  #date = $("#appointments_date").val()
  $("#ajaxAptInfo").hide()
  #$(appointments_date).val(date)
  #$("#submit_button").click()
  false

$ APTS.setup