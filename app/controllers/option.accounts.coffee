Spine = require('spine')

CONFIG = require('config/iprofero')
Option = require('models/option')
XHR = require('lib/XHR')

class OptionAccounts extends Spine.Controller
  
  className: 'option-accounts'

  elements:
    '#input-account-email': 'email'
    '#input-account-password': 'password'
    'legend.account-setting': 'legendSetting'

  events:
    'click #a-save': 'evSave'

  constructor: ->
    super
    Option.fetch()
    data = {}
    if Option.get 'email'
      data.email = Option.get 'email'
      data.password = Option.get 'password'
    @html @render data

  getOption: (name)->
    option = Option.findByAttribute 'name', name
    option.value

  render: (data)->
    require('views/option.accounts')(data)

  evSave: (ev)->
    @iProferoLogin @email.val(), @password.val()

  save: ->
    option = new Option 'name': 'email', 'value': @email.val()
    option.save()
    option = new Option 'name': 'password', 'value': @password.val()
    option.save()
    @alert 'success', 'Account saved.'

  loginFailed: =>
    @alert 'error', 'Account incorrect.'

  loginSuccess: =>
    @save()

  # type: 'error', 'success'
  alert: (type, msg)->
    @legendSetting.after require("views/alert.#{type}")(msg: msg)

  iProferoLogin: (email, password)->
    # email = 'shallker.wang@profero.com'
    # password = 'wanghanhua'

    requests =
      operation: 'user-login'
      email: email
      password: password
      redirectLink: '/login/success'
    
    # xhr = new XHR
    # xhr.addListener 'load', (ev)=>
    #   switch ev.target.status
    #     when 404 then @loginSuccess()
    #     else @loginFailed 'Account incorrect'
    # xhr.postForm URL_LOGIN, requests

    $.ajax
      type: 'post'
      url: CONFIG.URL.LOGIN
      data: requests
      statusCode:
        404: @loginSuccess
        200: @loginFailed

module.exports = OptionAccounts