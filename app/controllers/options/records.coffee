iProfero = require 'lib/iProfero'
BrowserAction = require 'lib/BrowserAction'

Spine = require('spine')

Record = require 'models/record'
Setting = require 'models/setting'

Tips = require 'controllers/options/records/tips'
Syncs = require 'controllers/options/records/syncs'
Lists = require 'controllers/options/records/lists'

Timer = require 'lib/timer'

class Records extends Spine.Controller

  className: 'option-records'

  elements:
    '.tips': 'elTips'
    '.sync': 'elSync'
    '.list': 'elList'

  constructor: ->
    super
    return if not @requireAccount()
    @render()

    Record.fetch()

    @tips = new Tips el: @elTips
    @sync = new Syncs el: @elSync
    @list = new Lists el: @elList

    # @createRecord()

  render: ->
    @html require('views/options/records')()

  requireAccount: ->
    return true if Setting.get('email')
    @html require('views/units/setup_account')()
    return false

  createRecord: ->
    now = new Date
    week = Timer.getThisWeek now.getTime()
    record = new Record
      'proj_id': 1
      'proj_name': 'test'
      'activity_id': 1
      'activity_name': 'test'
      'hours': 1
      'time': now.getTime()
      'synced': false
      'target_week': "#{Timer.getFullDay week.begin} / #{Timer.getFullDay week.end}"
      'day': Timer.getFullDay now.getTime()
      'day_name': Timer.getDayName now.getTime()
    @log record
    record.save()

  login: ->
    email = Option.get 'email'
    password = Option.get 'password'
    iProfero.login email, password, @loginSuccess, @loginFailed

  alert: (type, msg)->
    @el.after require("views/alert.#{type}")(msg: msg)
    
module.exports = Records