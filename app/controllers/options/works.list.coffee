Spine = require('spine')

Work = require('models/work')

class Li extends Spine.Controller

  tag: 'li'

  constructor: (@work)->
    super
    @html @render @work

  render: (data)->
    require('views/options/works.list')(data)

class WorksList extends Spine.Controller

  elements:
    'ul': 'elList'

  constructor: ->
    super
    @html @render()

    Work.bind 'refresh', @onWorkRefresh

  onWorkRefresh: (works)=>
    @elList.html('')
    @elList.append @renderLi work for work in works

  renderLi: (work)->
    li = new Li work
    li.el

  render: ->
    require('views/options/works.list')()

module.exports = WorksList