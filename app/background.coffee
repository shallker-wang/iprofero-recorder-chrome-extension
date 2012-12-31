require('lib/setup')

Spine = require('spine')

CONFIG = require 'config/extension'
Timer = require 'lib/timer'

Work = require 'models/work'
Record = require 'models/record'

window.BA = chrome.browserAction

class Background extends Spine.Controller

  running_interval: CONFIG.RUNNING_INTERVAL  # 1 minute
  records_create_hour: CONFIG.RECORDS_CREATE_HOUR
  records_created_today: false
  records_unsync_count: 0

  constructor: ->
    super
    Record.fetch()
    @openOptions()
    @listenClick @clickBrowserAction
    @running()

  running: ->
    window.setInterval @checkTime, @running_interval
    window.setInterval @checkUnsync, @running_interval

  setUnsyncTip: (num)->
    num = num.toString()
    chrome.browserAction.setBadgeText text: num

  clearUnsyncTip: ->
    chrome.browserAction.setBadgeText text: ''

  createRecords: (now)->
    Work.fetch()
    works = Work.all()
    for work in works
      record = new Record
      record.proj_id = work.proj_id
      record.proj_name = work.proj_name
      record.activity_id = work.activity_id
      record.activity_name = work.activity_name
      record.hours = work.hours
      record.time = now.getTime()
      record.synced = false
      record.target_week = @getTargetWeek now
      record.day = @getFullDay now
      record.day_name = @getDayName now
      @log record
      record.save()

  getTargetWeek: (now)->
    week = Timer.getThisWeek now.getTime()
    "#{@getFullDay week.begin} / #{@getFullDay week.end}"

  getFullDay: (now)->
    Timer.getFullDay now.getTime()

  getDayName: (now)->
    Timer.getDayName now.getTime()

  checkTime: =>
    @log 'checkTime'
    now = new Date
    @createRecords(now) if @isRecordsCreateHour(now) and not @isRecordsCreatedToday(now)

  checkUnsync: =>
    Record.fetch()
    @records_unsync_count = Record.getUnsynced().length
    if @records_unsync_count then @setUnsyncTip @records_unsync_count else @clearUnsyncTip()

  listenClick: (listener)->
    chrome.browserAction.onClicked.addListener listener

  clickBrowserAction: (tab)=>
    if @records_unsync_count then @openOptionRecords() else @openOptions()

  openTab: (url)->
    chrome.tabs.create url: url

  openOptions: ->
    @openTab "options.html"

  openOptionRecords: ->
    @openTab 'options.html#/records'

  isRecordsCreateHour: (now)->
    now.getHours() is @records_create_hour

  isRecordsCreatedToday: (now)->
    return true if @records_created_today is true
    return @records_created_today = true if @isLastRecordCreatedToday(now)
    false
      
  isLastRecordCreatedToday: (now)->
    return false unless lastRecord = Record.last()
    return true if now.getDate() == new Date(lastRecord.time).getDate()
    false

module.exports = Background