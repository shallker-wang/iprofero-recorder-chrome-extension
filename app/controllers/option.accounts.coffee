Spine = require('spine')

CONFIG = require('config/iprofero')
Option = require('models/option')
XHR = require('lib/XHR')
iProfero = require 'lib/iProfero'

class OptionAccounts extends Spine.Controller
  
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
    Option.fetch()
    @email = Option.get 'email'
    @password = Option.get 'password'
    @html @render @load()

  render: (data)->
    require('views/option.accounts')(data)

  load: ->
    email: @email, password: @password

  save: ->
    @email = @input_email.val()
    @password = @input_password.val()
    option = new Option name: 'email', value: @email
    option.save()
    option = new Option name: 'password', value: @password
    option.save()
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

module.exports = OptionAccounts