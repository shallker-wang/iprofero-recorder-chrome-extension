Spine = require('spine')

Setting = require 'models/setting'

class Tips extends Spine.Controller

  events:
    'click [action=hide]': 'onClickHide'

  constructor: ->
    super
    @html @render() if not @hided()

  render: ->
    require('views/options/records/tips')()

  onClickHide: (click)=>
    click.preventDefault()
    click.stopPropagation()
    @hide()

  hide: ->
    Setting.set 'hide_tip_running', 1
    @release()

  hided: ->
    Setting.get 'hide_tip_running'

module.exports = Tips