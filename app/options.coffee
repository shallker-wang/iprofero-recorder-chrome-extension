require('lib/setup')

Spine = require('spine')
OptionsNav = require('controllers/options.nav')
OptionsContent = require('controllers/options.content')

class Options extends Spine.Controller

  className: 'recorder-options'

  constructor: ->
    super

    @nav = new OptionsNav
    @content = new OptionsContent
    @append @nav, @content

    Spine.Route.setup()
    @navigate '/account' unless window.location.hash

module.exports = Options