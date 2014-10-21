{Reply} = require '../middleware/reply'
{Auth} = require '../middleware/auth'

exports.load = (Controller) ->
  class ChatChannel
    constructor: ({@id, @name, @controller}) ->
      @clients = []
      @history = []

    send: (message) ->
      @history.push {message:message.data.text, channel:@id, sender:message.Auth.name}
      @history = @history.slice -100 # Only store the last x messages in history
      for client in @clients
        client.send 'chat', {command: 'message', id:undefined, data:{message:message.data.text, channel:@id, sender:message.Auth.name}}

    sendHistory: (client) ->
      client.send 'chat', {command: 'history', id:undefined, data:{messages:@history}}

    addClient: (client) ->
      @clients.push client

    removeClient: (id) ->
      @clients = @clients.filter (client) -> id != client.connectionid


  # Chat module
  class ChatController extends Controller
    events:
      'ws/chat/subscribe': @middleware([Reply]) (message) ->
        @log "#{@s message.connectionid} subscribed to #{@c message.data.channel}"
        @channels[message.data.channel] ?= new ChatChannel {id:message.data.channel, name:message.data.channel, controller:this}
        @channels[message.data.channel].addClient message.reply
        @channels[message.data.channel].sendHistory message.reply

      'ws/chat/message': @middleware([Auth]) (message) ->
        @log "#{@s message.Auth.name or message.connectionid} sent a message to #{@c message.data.channel}"
        #@log "Auth: #{JSON.stringify message.Auth}"
        @channels[message.data.channel]?.send message

      'ws/disconnect': (message) ->
        @log "Removing #{@s message.connectionid}"
        @channels[channelname].removeClient(message.connectionid) for channelname of @channels


    init: ->
      @channels = {}

  return ChatController
