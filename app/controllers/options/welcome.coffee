Spine = require('spine')

class Welcome extends Spine.Controller
  
  className: 'option-welcome'

  template: require('views/option.welcome')()

  constructor: ->
    super
    @html @render()

  render: ->
    @template
    
module.exports = Welcome
