success = (message)->
  $('#results').append("<p class='success'>#{message}</p>")

error = (message)->
  $('#results').append("<p class='error'>#{message}</p>")

  $.post '/error', (data)->
    $('#theend').append("<p class='error'>#{data}</p>")

$(document).ready ->
  try

    Fix = NibJS.require('fixture')
    if Fix?
      success("Fix is correctly loaded and defined!") 
    else
      error("NibJS.require seems buggy")

    app = new Fix.App()
    if app.say_hello() is "Hello from App"
      success("Building an App instance seems working!")
    else
      error("Building an App instance has failed")

    $.post '/success', (data)->
      $('#theend').append("<p class='success'>#{data}</p>")
      
  catch err
    error(err.message)