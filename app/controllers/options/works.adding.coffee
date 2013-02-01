Spine = require('spine')

class WorksAdding extends Spine.Controller

  evStop = (ev)->
    ev.stopPropagation()
    ev.preventDefault()

  events:
    'click [action=add]': 'onClickAdd'

  constructor: ->
    super
    @html @render {projects: [], activities: []}

  render: (data)->
    require('views/options/works.adding')(data)

  onClickAdd: (click)=>
    evStop click
    @log 'onClickAdd', click

module.exports = WorksAdding