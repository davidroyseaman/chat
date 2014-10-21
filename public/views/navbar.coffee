define [
  '$'
  'view'
  'controllers/auth'
  'controllers/ping'
  'templates/navbar'
], ($, View, {AuthController}, {PingController}, navbarT) ->
  class NavbarView extends View
    template: navbarT
    events:
      'change .js-nickname': 'rename'

    init: ->
      @authController = new AuthController      
      @waitOn @authController.Promise 'load'
    
      @pingController = new PingController()

    appeared: ->
      @pingController.on 'update', ({ping}) =>        
        @$('.js-ping').text "#{ping} ms"
        if (ping < 50)
          col = 'rgba(0,255,0,1.0)'
        else if (ping > 500)
          col = 'rgba(255,0,0,1.0)'
        # else if (ping < (500-50)/2)
        #   ratio = (ping - 50) / (500-50)/2
        #   col = "rgba(#{Math.floor(ratio*255)},255,0,1.0)"
        # else 
        #   ratio = (ping - 50 - (500-50) / 2 ) / (500-50)
        #   col = "rgba(255,#{Math.floor((1-ratio)*255)},0,1.0)"          
        else 
          ratio = (ping - 50) / (500-50)
          col = "rgba(#{Math.floor(ratio*255)},#{Math.floor((1-ratio)*255)},0,1.0)"

        @$('.js-ping').css {backgroundColor:col}
      
      window.setInterval => 
        @pingController.request()
      , 5000
      @pingController.request()

    rename: ->
      @authController.changeName @$('.js-nickname').val()

  {NavbarView}
