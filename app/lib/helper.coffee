@evStop = (ev)->
  ev.preventDefault()
  ev.stopPropagation()

module.exports = @