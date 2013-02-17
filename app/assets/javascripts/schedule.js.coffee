# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#meetup_event_schedule_date').datepicker
    dateFormat: "mm-dd-yy",
  $('#meetup_event_date').datepicker
    dateFormat: "mm-dd-yy",
  $('#tweet_schedule_date').datepicker
    dateFormat: "mm-dd-yy",

