CONFIG = require 'config/iprofero'

class iProfero

  @urlLogin: CONFIG.URL.LOGIN
  @urlAddTimeLog: CONFIG.URL.ADD_TIME_LOG

  constructor: ->

  @login: (email, password, loginSuccess, loginFailed)->
    requests =
      operation: 'user-login'
      email: email
      password: password
      redirectLink: '/login/success'
    
    $.ajax
      type: 'post'
      url: @urlLogin
      data: requests
      statusCode:
        404: loginSuccess ? ->
        200: loginFailed ? ->

  @addTimeLog: (week, day, projId, activityId, hours, success, failed)->
    requests =
      operation: 'add-timelog'
      target_week: week
      proj_id: projId
      activity_id: activityId
      hours: hours
      day: day
      redirectLink: '/sync/success'

    $.ajax
      type: 'post'
      url: @urlAddTimeLog
      data: requests
      success: success ? ->

  sendRequest: (url, data)->
    xhr = new XHR()
    xhr.setHeader('Content-Type', 'application/x-www-form-urlencoded')
    xhr.POST url, data

module.exports = iProfero