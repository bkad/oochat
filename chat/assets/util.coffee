window.Util =
  scrolling: 0

  scrolledToBottom: ->
    # if a scrolling animation is taking place, we are at the bottom
    return true if @scrolling > 0
    messages = $(".chat-messages.current")
    difference = (messages[0].scrollHeight - messages.scrollTop()) - messages.outerHeight()
    difference <= 1

  scrollToBottom: (options = animate: true) ->
    messages = $(".chat-messages.current")
    scrollTop = messages[0].scrollHeight - messages.outerHeight() - 1
    if options.animate
      @scrolling += 1
      messages.animate({ scrollTop: scrollTop }, duration: 150, complete: -> Util.scrolling -= 1)
    else
      messages.prop(scrollTop: scrollTop)

  cleanupTipsy: -> $(".tipsy").remove()

  spinConfig:
    lines: 11,            # The number of lines to draw
    length: 13,           # The length of each line
    width: 4,             # The line thickness
    radius: 24,           # The radius of the inner circle
    corners: 1,           # Corner roundness (0..1)
    rotate: 14,           # The rotation offset
    color: "#4782B4",     # accent-blue
    speed: 1.4,           # Rounds per second
    trail: 100,           # Afterglow percentage
    shadow: false,        # Whether to render a shadow
    hwaccel: false,       # Whether to use hardware acceleration
    className: 'spinner', # The CSS class to assign to the spinner
    zIndex: 2e9,          # The z-index (defaults to 2000000000)
    top: 'auto',          # Top position relative to parent in px
    left: 'auto'          # Left position relative to parent in px

window.onbeforeunload = ->
  if $("#chat-text").val().length > 0
    return "You have an unsent message."
