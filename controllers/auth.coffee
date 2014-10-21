{Reply} = require '../middleware/reply'
{Auth} = require '../middleware/auth'
uuid = require 'node-uuid'
redis = require 'redis'

exports.load = (Controller) ->
  # Pretty sure the client can be shared between multiple controller instances
  # Although it won't be checked till way later once I have multiple instances running
  # with sharding and shit
  client = redis.createClient()

  # Auth module
  class AuthController extends Controller
    events: 
      'ws/auth/request': @middleware([Reply]) (message) ->
        connectionID = message.connectionid
        newUserID = uuid.v4()
        
        client.hset 'auth/c2u', connectionID, newUserID, (err) ->
        client.hset 'auth/u2c', newUserID, connectionID, (err) ->
      
        message.reply.send 'auth', {command: 'confirm', id:undefined, data:{userID: newUserID}}

      'ws/auth/rename': @middleware([Reply, Auth]) (message) ->
        client.hset 'auth/u2n', message.Auth.userID, message.data.name, (err) ->
        @log "#{@s message.reply.connectionid} (userid #{@s message.Auth.userID}) now known as #{@c message.data.name}"
        message.reply.send 'auth', {command: 'name', id:undefined, data:{userID: message.userID, name: message.data.name}}


    init: ->
      client.select 1, () =>
        @log 'Shit I should wait for this somehow...'

  return AuthController