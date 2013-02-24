# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery    ->
  update_venues()
  update_events()
  $("#meetup_event_schedule_date").datepicker dateFormat: "mm-dd-yy"
  $("#meetup_event_date").datepicker dateFormat: "mm-dd-yy"
  $("#meetup_comment_schedule_date").datepicker dateFormat: "mm-dd-yy"
  $("#tweet_schedule_date").datepicker dateFormat: "mm-dd-yy"
  $("#meetup_event_group_meetup_group_id").click ->
    update_venues()
    false
  $("#meetup_group_meetup_group_id").click ->
    update_events()
    false

update_venues = ->
  $.ajax
    type: "POST"
    url: "http://localhost:3000/schedule/get_meetup_venues"
    data:
      group_id: $("#meetup_event_group_meetup_group_id option").val()

    dataType: "json"
    success: (json) ->
      $("#meetup_event_venue_meetup_venue_id option").remove()
      $.each json, (key, value) ->
        $("#meetup_event_venue_meetup_venue_id").append $("<option>").text(value[1]+" "+ value[2]+" "+value[3]+","+value[4]).attr("value", value[0])

update_events = ->
  $.ajax
    type: "POST"
    url: "http://localhost:3000/schedule/get_meetup_events"
    data:
      group_id: $("#meetup_group_meetup_group_id option").val()
    dataType: "json"
    success: (json) ->
      $("#meetup_event_meetup_event_id option").remove()
      $.each json, (key,value) ->
        d= new Date(value[2])
        $("#meetup_event_meetup_event_id").append $("<option>").text(value[1]+ " " + d.toLocaleString()).attr("value",value[0])

