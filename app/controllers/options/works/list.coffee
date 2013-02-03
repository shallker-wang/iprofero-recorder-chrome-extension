Spine = require('spine')

Work = require('models/work')

class Li extends Spine.Controller

  evStop = (ev)->
    ev.preventDefault()
    ev.stopPropagation()

  tag: 'li'

  events:
    'click [action=delete]': 'onClickDelete'

  constructor: (data)->
    super
    @work = data.work
    @work.bind 'update', @onUpdateWork
    @render()

  render: ->
    @html @view @work

  view: (data)->
    require('views/options/works/list.li')(data)

  onClickDelete: (click)=>
    evStop click
    @delete()

  onUpdateWork: (work)=>
    @log 'onUpdateWork', work

  delete: ->
    @work.destroy()
    @release()

class List extends Spine.Controller

  elements:
    'ul': 'elList'

  constructor: ->
    super
    @html @render()
    @works = Work.all()
    @drawList() if @works.length

    Work.bind 'create', @onWorkCreate

  drawList: ->
    @elList.html ''
    @appendLi @renderLi work for work in @works

  onWorkCreate: (work)=>
    @appendLi @renderLi work

  appendLi: (el)->
    @elList.append el

  renderLi: (work)->
    li = new Li work: work
    li.el

  render: ->
    require('views/options/works/list')()

module.exports = List