define [
  'controller'
], (Controller) ->

  class AuthController extends Controller
    channels: 
      auth:
        confirm: (data) ->
          #console.log data
        name: (data) ->
          #console.log 'You have a new name', data

    init: ->
      @idctr = 0

    go: ->
      @send 'auth', 'request', {}

    changeName: (name) ->
      @send 'auth', 'rename', {name}, @idctr++
      # @trigger 'message', {text, channel: 'global'}

      

  return {AuthController}
