define [
  'backbone'
  'controllers/stem'
  'events'
], (Backbone, Stem, Events) ->

  class Controller 
    constructor: () ->
      @paths = {}
      Stem.registerChannel 'redis', this

    ensure: (id) ->
      @paths[id] = new RedisModel(id) unless @paths[id]?

    set: (path, field, value) ->
      #Stem.send 'redis', {command:'set', path, field, value}
      Stem.send {channel: 'redis', command:'set', id:path, data: {key:field, value}}

    addModel: (path, model) ->
      Stem.send {channel: 'redis', command:'subscribe', id:path} unless @paths[path]?

      @paths[path] ?= []
      @paths[path].push model


    handlers:
      "init": (id, data) ->
        @ensure id
        @paths[id].load data

      "set": (id, data) ->
        @ensure id
        obj._data[data.key] = data.value for obj in @paths[id]

  controller = new Controller

  class RedisModel extends Events
    constructor: (@path) ->
      controller.addModel @path, this
      @_data = {}

    load: (data) ->
      @_data = data

    get: (field) -> @_data[field]
    set: (field, value) ->
      # Not that easy buddy. Got to go through server.
      controller.set @path, field, value
      #@_data[field] = value

  

  return RedisModel

