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

  @addTimeLog: (rid, week, day, projId, activityId, hours, onSuccess, onFailed)->
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
      success: => onSuccess rid

  @getProjectsAndActivities: (onGet)->
    onSuccess = (content, codeName, xhr)->
      data =
        projects: {}
        activities: {}
      $dom = $(content)
      elProjects = $dom.find('#proj_id option')
      elActivities = $dom.find('#activity_id option')
      for elProject in elProjects
        data.projects[$(elProject).attr('value')] = $(elProject).text()
      for elActivity in elActivities
        data.activities[$(elActivity).attr('value')] = $(elActivity).text()
      onGet? data

    $.ajax
      url: 'http://iprofero.proferochina.com/front/time/mytimesheet'
      success: onSuccess

  sendRequest: (url, data)->
    xhr = new XHR()
    xhr.setHeader('Content-Type', 'application/x-www-form-urlencoded')
    xhr.POST url, data

module.exports = iProfero