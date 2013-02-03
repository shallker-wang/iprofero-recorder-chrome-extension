Spine = require('spine')

class Setting extends Spine.Model
  @configure 'Setting', 'name', 'value'

  @extend Spine.Model.Local

  @get: (name)->
    setting = @findByAttribute 'name', name
    setting.value if setting

  @set: (name, value)->
    setting = @create name: name, value: value
    setting.save()
    
module.exports = Setting