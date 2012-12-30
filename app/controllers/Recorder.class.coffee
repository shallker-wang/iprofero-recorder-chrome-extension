class Recoder

  urlLogin: CONFIG.URL.LOGIN
  urlAddTimeLog: CONFIG.URL.ADD_TIME_LOG

  constructor: ->

  login: (email, password)->
    request = 
      operation: 'user-login'
      email: email
      password: password
      redirectLink: '/'
    @sendRequest @urlLogin, @request

  addTimeLog: (week, day, projId, activeId, hours)->
    request =
      operation: 'add-timelog'
      target_week: week
      day: day
      proj_id: projId
      activity_id: activeId
      hours: hours
    @sendRequest @urlAddTimeLog, @request

  sendRequest: (url, data)->
    xhr = new XHR()
    xhr.setHeader('Content-Type', 'application/x-www-form-urlencoded')
    xhr.POST url, data