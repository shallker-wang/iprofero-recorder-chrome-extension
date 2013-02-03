Spine = require('spine')
iProfero = require('lib/iProfero')

class Record extends Spine.Model
  @configure 'Record', 'proj_id', 'proj_name', 'activity_id', 'activity_name', 'hours', 'time', 'synced', 'target_week', 'day', 'day_name'

  @extend Spine.Model.Local

  @getUnsynced: ->
    @select (record)-> record.synced is false

  @getThisWeek: ->
    curr = new Date
    thisMonday = new Date(curr.setDate(curr.getDate() - curr.getDay() + 1))
    thisSunday = new Date(curr.setDate(curr.getDate() - curr.getDay() + 7))
    startTime = new Date(thisMonday.getFullYear(), thisMonday.getMonth(), thisMonday.getDate())
    endTime = new Date(thisSunday.getFullYear(), thisSunday.getMonth(), thisSunday.getDate())
    records = @getTimeBetween startTime, endTime
    records.reverse()

  @getWeekAgo: ->
    curr = new Date
    thisMonday = new Date(curr.setDate(curr.getDate() - curr.getDay() + 1))
    thisMondayTime = new Date(thisMonday.getFullYear(), thisMonday.getMonth(), thisMonday.getDate())
    records = @getBefore thisMondayTime
    records.reverse()

  @getAfter: (time)->
    @select (record)-> record.time > time

  @getBefore: (time)->
    @select (record)-> record.time < time

  @getTimeBetween: (startTime, endTime)->
    @select (record)-> record.time > startTime and record.time < endTime

  @sync: ->
    onSyncSuccess = (rid)=>
      record = @find rid
      record.updateAttribute 'synced', true
    records = @getUnsynced()
    for record in records
      iProfero.addTimeLog record.id, record.week, record.day, record.proj_id, 
        record.activity_id, record.hours, onSyncSuccess

module.exports = Record