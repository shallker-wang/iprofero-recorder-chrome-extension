Spine = require('spine')

Setting = require 'models/setting'
Record = require 'models/record'

class Li extends Spine.Controller

  constructor: (data)->
    super
    @record = data.record
    @render()

  render: (record)->
    @html @view @record

  view: (record)->
    require('views/options/records/lists.li')(record)


class Lists extends Spine.Controller

  elements:
    'ul.this-week': 'elThisWeek'
    'ul.week-ago': 'elWeekAgo'

  constructor: ->
    super
    @recordsThisWeek = Record.getThisWeek()
    @recordsWeekAgo = Record.getWeekAgo()
    @render()

  render: ->
    @html @view()
    @renderThisWeek() if @recordsThisWeek.length
    @renderWeekAgo() if @recordsWeekAgo.length

  view: ->
    require('views/options/records/lists')()

  renderThisWeek: ->
    @elThisWeek.html ''
    @elThisWeek.append @renderLi record for record in @recordsThisWeek

  renderWeekAgo: ->
    @elWeekAgo.html ''
    @elWeekAgo.append @renderLi record for record in @recordsWeekAgo

  renderLi: (record)->
    li = new Li record: record
    li.el
   
module.exports = Lists