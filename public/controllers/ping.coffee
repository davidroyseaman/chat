define [
  'controller'
], (Controller) ->

  class PingController extends Controller
    channels: 
      ping:
        pong: (data) ->          
          diff = new Date - @lastPing
          @trigger 'update', {ping:diff}

    request: ->
      @lastPing = new Date
      @send 'ping', 'ping', {}
    

  return {PingController}
