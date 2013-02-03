Spine = require('spine')
doT = require('lib/doT')

Welcome = require('controllers/options/welcome')
Accounts = require('controllers/options/accounts')
Works = require('controllers/options/works')
Records = require('controllers/options/records')

class Main extends Spine.Controller

  className: 'options-content'

  constructor: ->
    super
    
    @routes
      'welcome': (route)->
        @html new Welcome

      'account': (route)->
        @html new Accounts

      'works': (route)->
        @html new Works

      'records': (route)->
        @html new Records

module.exports = Main