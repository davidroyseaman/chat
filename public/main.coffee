define [
  '$'
  'view'
  'application'
  'views/chat'
  'views/navbar'
  'templates/layout'
], ($, View, Application, {ChatView}, {NavbarView}, layoutT) ->
  require (['vendor/bootstrap-3.1.1-dist/js/bootstrap.min'])
  class ChatApp extends Application
    title: "Chat Test"
    template: layoutT
    load: ->
    render: ->
      @navbar = new NavbarView
      @append '.js-navbar', @navbar
      @chat = new ChatView
      @append '.js-chat', @chat

    appeared: ->


  (new ChatApp).start()


