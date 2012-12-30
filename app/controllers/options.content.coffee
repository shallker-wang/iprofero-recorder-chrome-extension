Spine = require('spine')
doT = require('lib/doT')

Welcome = require('controllers/option.welcome')
Accounts = require('controllers/option.accounts')
Works = require('controllers/option.works')
Records = require('controllers/option.records')

class OptionsContent extends Spine.Controller

  className: 'options-content'

  constructor: ->
    super
    
    @routes
      '/welcome': (route)->
        @html new Welcome

      '/account': (route)->
        @html new Accounts

      '/works': (route)->
        @html new Works

      '/works/refresh': (route)->
        @navigate '/works'
        
      '/records': (route)->
        @html new Records

module.exports = OptionsContent