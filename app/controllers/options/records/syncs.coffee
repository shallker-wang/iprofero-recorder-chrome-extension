Spine = require('spine')

Record = require 'models/record'

class Syncs extends Spine.Controller

  className: 'records-sync'

  events:
    'click [action=sync]': 'onClickSync'

  constructor: ->
    super
    @recordsUnsynced = Record.getUnsynced()
    @count = @recordsUnsynced.length
    @render() if @count

  render: ->
    @html @view count: @count

  view: (data)->
    require('views/options/records/syncs')(data)

  onClickSync: (click)=>
    click.preventDefault()
    click.stopPropagation()
    @sync()

  sync: (record)->
    Record.sync()
    @release()
   
module.exports = Syncs