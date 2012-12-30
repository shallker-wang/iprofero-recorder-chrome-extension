Spine = require('spine')

class OptionWelcome extends Spine.Controller
  
  className: 'option-welcome'

  template: require('views/option.welcome')()

  constructor: ->
    super
    @html @render()

  render: ->
    @template
    
module.exports = OptionWelcome
