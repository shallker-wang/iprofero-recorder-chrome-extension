iProfero = require 'lib/iProfero'
BrowserAction = require 'lib/BrowserAction'

Spine = require('spine')

Option = require 'models/option'
Record = require 'models/record'
window.Record = Record

class OptionRecords extends Spine.Controller

  data: {}

  className: 'option-records'

  elements:
    'legend.records-recent': 'legend_recent'
    '.records-tip-running': 'tip_running'
    '.records-tip-new': 'tip_new'

  events:
    'click .records-tip-running .close': 'clickHideTipRunning'
    'click .records-sync': 'clickSync'

  constructor: ->
    super
    Option.fetch()
    Record.fetch()
    # Record.destroyAll()
    @html @render @load()

  load: ->
    @data.hide_tip_running = true if Option.get 'hide_tip_running'
    @data.records_this_week = Record.getThisWeek()
    @data.records_a_week_ago = Record.getWeekAgo()
    @data.records_unsynced = Record.getUnsynced()
    @data

  render: (data)->
    require('views/option.records')(data)

  sync: ->
    records = Record.getUnsynced()
    record = records.shift()
    @record = record
    iProfero.addTimeLog record.week, record.day, record.proj_id, 
      record.activity_id, record.hours, @syncSuccess

  syncSuccess: (response)=>
    @record.updateAttribute('synced', true)
    BrowserAction.setBadgeTip Record.getUnsynced().length
    @refresh()

  syncFailed: (response)=>
    @log 'syncFailed', response

  clickHideTipRunning: (ev)->
    ev.preventDefault()
    new Option(name: 'hide_tip_running', value: true).save()
    @refresh()

  clickSync: (ev)->
    ev.preventDefault()
    @login()

  refresh: ->
    @navigate '/temp'
    @navigate '/records'

  login: ->
    email = Option.get 'email'
    password = Option.get 'password'
    iProfero.login email, password, @loginSuccess, @loginFailed

  loginSuccess: =>
    @sync()

  loginFailed: =>
    @alert 'error', 'Account invalid.'

  alert: (type, msg)->
    @el.after require("views/alert.#{type}")(msg: msg)
    
module.exports = OptionRecords