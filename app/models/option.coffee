Spine = require('spine')

class Option extends Spine.Model
  @configure 'Option', 'name', 'value'

  @extend Spine.Model.Local

  @get: (name)->
    option = @findByAttribute 'name', name
    option.value if option
    
module.exports = Option