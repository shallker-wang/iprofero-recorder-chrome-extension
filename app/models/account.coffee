Spine = require('spine')

class Account extends Spine.Model
  @configure 'Account', 'email', 'password'

  @extend Spine.Model.Local
  
module.exports = Account