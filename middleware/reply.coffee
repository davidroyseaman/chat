exports.Reply = (message, next) ->
  # console.log 'IN REPLY MIDDLEWARE'
  clientID = message.connectionid.toString()
  message.reply = {
    connectionid: clientID
    send: (channel, message) =>
      # @log "#{@c '<-'} #{@s clientID} Reply MW #{@c channel}/#{@c message.command}. Data:#{@c JSON.stringify(message.data)}"
      message.channel = channel
      message.connectionid = clientID
      @send "ws/send", message
  }
  next()
