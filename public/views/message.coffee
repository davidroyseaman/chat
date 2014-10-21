define [
  '$'
  'view'
  'templates/chat/message'
], ($, View, messageT) ->
  class MessageView extends View
    template: messageT

    init: ->
      
    render: ->
      @$('.js-user').text @model.sender
      @$('.js-message').text @model.text

  {MessageView}
