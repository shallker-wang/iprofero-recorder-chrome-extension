require('lib/setup')

Spine = require('spine')
Navs = require('controllers/options/navs')
Main = require('controllers/options/main')

Setting = require('models/setting')
# Work = require('models/work')
# Record = require('models/record')

iProfero = require('lib/iProfero')

class Options extends Spine.Controller

  className: 'recorder-options'

  constructor: ->
    super

    Setting.fetch()
    # Work.fetch()
    # Record.fetch()
    
    @navs = new Navs
    @main = new Main
    @append @navs, @main

    Spine.Route.setup()
    @navigate '/welcome' unless window.location.hash

    @login() if @hasAccount()

  hasAccount: ->
    Setting.get 'email'

  login: ->
    iProfero.login Setting.get('email'), Setting.get('password')

module.exports = Options