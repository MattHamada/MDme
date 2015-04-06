## Author: Matt Hamada
## Copyright MDme 2014
##
##Will shows ajax popup windows for table links
#
#
##used for popup windows
#POPUPS = {}
#POPUPS.setup = ->
#
#  #add div to end of page
#  $("<div id=\"ajaxPopupInfo\"></div>").hide().appendTo $("body")
#  $(".popup-links").on "click", "a", POPUPS.getInfo
#  false
#
##ajax call for appointment details
#POPUPS.getInfo = ->
#  $.ajax
#    type: "GET"
#    url: $(this).attr("href")
#    timeout: 5000
#    success:  POPUPS.showInfo
#    error: ->
#      alert "Error loading data"
#
#  false
#
##ajax calls for approving/denying appointments
#POPUPS.getApproveInfo = ->
#  $.ajax
#    type: "GET"
#    url: $(this).attr("href")
#    timeout: 5000
#    error: ->
#      alert "Error processing request"
#
#  false
#
#
##data is ajax return obj
#POPUPS.showInfo = (data) ->
#
#  #center is 1/2 wide 1/4 tall as screen
#  oneFourth = Math.ceil($(window).width() / 4)
#  $("#ajaxPopupInfo").html(data).css(
#    left: oneFourth
#    width: 2 * oneFourth
#    top: 20
#    position: 'fixed'
#  ).show()
#
#  #make close link work
#  $("#closeLink").click POPUPS.hideInfo
#  false
#
#POPUPS.hideInfo = ->
#  $("#ajaxPopupInfo").hide()
#  false
#
#$ POPUPS.setup