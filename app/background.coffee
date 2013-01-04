require('lib/setup')
Timer = require 'lib/timer'
BrowserAction = require 'lib/BrowserAction'

Spine = require('spine')

CONFIG = require 'config/extension'

Work = require 'models/work'
Record = require 'models/record'

class Background extends Spine.Controller

  running_interval: CONFIG.RUNNING_INTERVAL  # 1 minute
  records_create_hour: CONFIG.RECORDS_CREATE_HOUR
  records_created_today: false
  records_unsync_count: 0

  constructor: ->
    super
    Record.fetch()
    BrowserAction.listenClick @clickIcon
    @afterInstalled() if @isFirstInstalled()
    @running()

  openOptions: ->
    BrowserAction.openTab 'options.html'

  isFirstInstalled: ->
    return localStorage.installed

  afterInstalled: ->
    @openOptions()
    localStorage.installed = true

  running: ->
    @checkTime()
    @checkUnsync()
    window.setInterval @checkTime, @running_interval
    window.setInterval @checkUnsync, @running_interval

  createRecords: (now)->
    Work.fetch()
    works = Work.all()
    for work in works
      week = Timer.getThisWeek now.getTime()
      targetWeek = "#{@getFullDay week.begin} / #{@getFullDay week.end}"
      fullDay = Timer.getFullDay now.getTime()
      dayName = Timer.getDayName now.getTime()
      record = new Record
      record.proj_id = work.proj_id
      record.proj_name = work.proj_name
      record.activity_id = work.activity_id
      record.activity_name = work.activity_name
      record.hours = work.hours
      record.time = now.getTime()
      record.synced = false
      record.target_week = targetWeek
      record.day = fullDay
      record.day_name = dayName
      @log record
      record.save()

  checkTime: =>
    @log 'checkTime'
    now = new Date
    @createRecords(now) if @isRecordsCreateHour(now) and not @isRecordsCreatedToday(now)

  checkUnsync: =>
    Record.fetch()
    @records_unsync_count = Record.getUnsynced().length
    if @records_unsync_count
    then BrowserAction.setBadgeTip @records_unsync_count
    else BrowserAction.clearBadgeTip()

  clickIcon: (tab)=>
    if @records_unsync_count
    then BrowserAction.openTab 'options.html#/records'
    else BrowserAction.openTab 'options.html'

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