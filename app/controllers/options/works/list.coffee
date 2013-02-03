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
    @render()

  render: ->
    @html @view @work

  view: (data)->
    require('views/options/works/list.li')(data)

  onClickDelete: (click)=>
    evStop click
    @delete()

  delete: ->
    @work.destroy()
    @release()

class List extends Spine.Controller

  elements:
    'ul': 'elList'

  constructor: ->
    super
    @render()
    @works = Work.all()
    @renderList() if @works.length

    Work.bind 'create', @onWorkCreate

  renderList: ->
    @elList.html ''
    @appendLi @renderLi work for work in @works

  onWorkCreate: (work)=>
    @works.push work
    return @renderList() if @works.length is 1
    @appendLi @renderLi work

  appendLi: (el)->
    @elList.append el

  renderLi: (work)->
    li = new Li work: work
    li.el

  render: ->
    @html require('views/options/works/list')()

module.exports = List