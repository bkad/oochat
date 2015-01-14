angular.module "prat"
.factory "eventHub", ($q) ->
  class EventHub
    _.extend @::, Backbone.Events

    constructor: (config) ->
      @address = config.address
      @reconnectTimeout = config.reconnectTimeout
      @blockingDequeue = []
      @timeoutIDs = []
      @queueing = true
      @reconnect = false
      @queue = []

      @createSocket()

    createSocket: =>
      @socket?.close()
      @timeoutIDs.push(setTimeout(@createSocket, @reconnectTimeout))
      console.log "Connecting to #{@address}"
      @socket = new WebSocket(@address)
      @socket.onmessage = @onMessage
      @socket.onclose = @onConnectionFailed
      @socket.onopen = @onConnectionOpened

    onMessage: (message) =>
      messageObject = JSON.parse(message.data)
      if @queueing
        @queue.push(messageObject)
      else
        @trigger(messageObject.action, messageObject.action, messageObject.data)

    onReconnect: (callback) =>
      @blockingDequeue.push(callback)

    dequeue: =>
      @trigger(message.action, message.action, message.data) for message in @queue
      @queue = []
      @queueing = false

    sendJSON: (messageObject) => @socket.send(JSON.stringify(messageObject))

    sendPreview: (message, channel) =>
      @sendJSON
        action: "preview_message"
        data:
          message: message
          channel: channel

    leaveChannel: (channel) =>
      @sendJSON
        action: "leave_channel"
        data:
          channel: channel

    joinChannel: (channel) =>
      @sendJSON
        action: "join_channel"
        data:
          channel: channel

    onConnectionFailed: =>
      @reconnect = true
      @clearAllTimeoutIDs()
      @trigger("connection-failed", "connection-failed", @reconnectTimeout/1000)
      @timeoutIDs.push(setTimeout(@createSocket, @reconnectTimeout))

    onConnectionOpened: =>
      #@alertHelper.delAlert()
      @clearAllTimeoutIDs()
      @deferDequeue(@blockingDequeue...) if @reconnect
      @reconnect = false
      console.log "Connection successful"

    clearAllTimeoutIDs: =>
      clearTimeout(timeoutID) for timeoutID in @timeoutIDs
      @timeoutIDs = []

    # When connected, queue events and wait for backfilling to finish before dequeuing
    deferDequeue: (callbacks...) =>
      $q.all(callback.call() for callback in callbacks)
       .then(@dequeue, @dequeue)


  websocketProtocol = if "https:" is document.location.protocol then "wss" else "ws"
  new EventHub
    address: "#{websocketProtocol}://#{document.location.host}/eventhub"
    reconnectTimeout: 4000
