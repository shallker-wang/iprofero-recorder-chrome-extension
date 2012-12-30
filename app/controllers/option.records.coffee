Spine = require('spine')
CONFIG = require 'config/iprofero'
Option = require 'models/option'
Record = require 'models/record'
window.Record = Record

class OptionRecords extends Spine.Controller

  data: {}

  className: 'option-records'

  elements:
    'legend.records-recent': 'legendRecent'
    '.records-tip-running': 'tipRuning'
    '.records-tip-new': 'tipNew'

  events:
    'click .records-tip-running .close': 'evHideTipRunning'
    'click .records-sync': 'evSync'

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
    @record = records.shift()
    requests =
      operation: 'add-timelog'
      target_week: @record.target_week
      proj_id: @record.proj_id
      activity_id: @record.activity_id
      hours: @record.hours
      day: @record.day
      redirectLink: '/sync/success'

    $.ajax
      type: 'post'
      url: CONFIG.URL.ADD_TIME_LOG
      data: requests
      success: @syncSuccess

  syncSuccess: (response)=>
    @record.updateAttribute('synced', true)
    @refresh()

  syncFailed: (response)=>
    @log 'syncFailed', response

  evHideTipRunning: (ev)->
    ev.preventDefault()
    option = new Option name: 'hide_tip_running', value: true
    option.save()
    @refresh()

  evSync: (ev)->
    ev.preventDefault()
    @sync()

  refresh: ->
    @navigate '/temp'
    @navigate '/records'

    
module.exports = OptionRecords