Spine = require('spine')

class OptionsNav extends Spine.Controller

  tag: 'ul'
  className: 'nav nav-tabs options-nav'

  elements:
    'li': 'navs'

  events:
    'click li': 'onClickLi'

  constructor: ->
    super
    @append @render()

  render: ->
    require('views/options.nav')()

  onClickLi: (click)=>
    @active click.currentTarget

  active: (el)->
    $(el).siblings().removeClass 'active'
    $(el).addClass 'active'

module.exports = OptionsNav