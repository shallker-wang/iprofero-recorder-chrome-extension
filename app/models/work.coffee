Spine = require('spine')

class Work extends Spine.Model
  @configure 'Work', 'proj_id', 'proj_name', 'activity_id', 'activity_name', 'hours', 'time'

  @extend Spine.Model.Local
  
module.exports = Work