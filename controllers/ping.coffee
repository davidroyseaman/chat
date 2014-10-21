{Reply} = require '../middleware/reply'

exports.load = (Controller) ->
  # Ping module
  class PingController extends Controller
    events: 
      'ws/ping/ping': @middleware([Reply]) (message) ->
        message.reply.send 'ping', {command: 'pong', id:undefined, data:{ts: (new Date).toISOString()}}

    init: ->

  return PingController
  