require('lib/setup')

Spine = require('spine')
Work = require 'models/work'
Record = require 'models/record'

class Background extends Spine.Controller

  records_create_hour: 6
  records_created_today: false
  records_check_interval: 1000*60  # 1 minute

  constructor: ->
    super
    Record.fetch()
    @running()

  running: ->
    window.setInterval @checkTime, @records_check_interval

  createRecords: ->
    now = new Date
    # now = new Date(2012, 12, 28)
    nowTime = now.getTime()
    Work.fetch()
    works = Work.all()
    for work in works
      record = new Record
      record.proj_id = work.proj_id
      record.proj_name = work.proj_name
      record.activity_id = work.activity_id
      record.activity_name = work.activity_name
      record.hours = work.hours
      record.time = nowTime
      record.synced = false
      record.target_week = @getThisWeek nowTime
      record.day = @getFullDay nowTime
      record.day_name = @getDayName now.getDay()
      @log record
      record.save()

  getDayName: (day)->
    weekday = []
    weekday[0] = "Sunday"
    weekday[1] = "Monday"
    weekday[2] = "Tuesday"
    weekday[3] = "Wednesday"
    weekday[4] = "Thursday"
    weekday[5] = "Friday"
    weekday[6] = "Saturday"
    weekday[day]

  getFullDay: (time)->
    now = new Date(time)
    year = now.getFullYear()
    month = now.getMonth() + 1
    date = now.getDate()
    month = "0#{month}" if month.toString().length is 1
    date = "0#{date}" if date.toString().length is 1
    fullDay = "#{year}-#{month}-#{date}"
    fullDay

  getThisWeek: (time)->
    curr = new Date(time)
    thisMonday = new Date(curr.setDate(curr.getDate() - curr.getDay() + 1))
    thisSunday = new Date(curr.setDate(curr.getDate() - curr.getDay() + 7))
    thisMondayFullDay = @getFullDay thisMonday.getTime()
    thisSundayFullDay = @getFullDay thisSunday.getTime()
    thisWeek = "#{thisMondayFullDay} / #{thisSundayFullDay}"
    thisWeek

  checkTime: =>
    currHour = new Date().getHours()
    if currHour is @records_create_hour
      @createRecords() unless @isRecordsCreatedToday()

  isRecordsCreatedToday: ->
    return true if @records_created_today is true
    lastRecord = Record.last()
    # no records at all
    return false unless lastRecord
    lastCreating = new Date lastRecord.time
    now = new Date
    if now.getDate() == lastCreating.getDate()
      @records_created_today = true
      return true
    else
      return false
      

module.exports = Background