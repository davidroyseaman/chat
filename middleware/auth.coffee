redis = require 'redis'
client = redis.createClient()

client.select 1, () ->
  console.log '(auth middleware) gyar... fibres?'

exports.Auth = (message, next) ->
  connectionID = message.connectionid.toString()

  client.hget 'auth/c2u', connectionID, (err, userID) ->
    client.hget 'auth/u2n', userID, (err, name) ->
      message.Auth = {
        userID
        name
      }
      next()
