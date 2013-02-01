Spine = require('spine')
WorksList = require('controllers/options/works.list')
WorksAdding = require('controllers/options/works.adding')

Setting = require('models/setting')

class Works extends Spine.Controller

  elements:
    '#works-list': 'elList'
    '#works-adding': 'elAdding'

  constructor: ->
    super
    return @noAccount() if not Setting.get 'email'
    @html @render()

    Options.get 'email'

    @list = new WorksList
    @elList.html @list.el
    
    @adding = new WorksAdding
    @elAdding.html @adding.el

  render: ->
    require('views/options/works')()

  noAccount: ->
    @html '<p>You need to setup your account first.</p>'
    
module.exports = Works