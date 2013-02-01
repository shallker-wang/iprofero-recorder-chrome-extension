Spine = require('spine')

CONFIG = require('config/iprofero')
Setting = require('models/setting')
XHR = require('lib/XHR')
iProfero = require 'lib/iProfero'

class Accounts extends Spine.Controller
  
  className: 'option-accounts'

  email: ''
  password: ''

  elements:
    '#input-account-email': 'input_email'
    '#input-account-password': 'input_password'
    'legend.account-setting': 'legend_setting'

  events:
    'click #a-save': 'clickSave'

  constructor: ->
    super
    Setting.fetch()
    @email = Setting.get 'email'
    @password = Setting.get 'password'
    @html @render @load()

  render: (data)->
    require('views/options/accounts')(data)

  load: ->
    email: @email, password: @password

  save: ->
    @email = @input_email.val()
    @password = @input_password.val()
    setting = new Setting name: 'email', value: @email
    setting.save()
    setting = new Setting name: 'password', value: @password
    setting.save()
    @alert 'success', 'Account saved.'

  invalid: =>
    @alert 'error', 'Account incorrect.'

  valid: =>
    @save()

  clickSave: (ev)->
    email = @input_email.val()
    password = @input_password.val()
    iProfero.login email, password, @valid, @invalid

  # type: 'error', 'success'
  alert: (type, msg)->
    @legend_setting.after require("views/alert.#{type}")(msg: msg)

module.exports = Accounts