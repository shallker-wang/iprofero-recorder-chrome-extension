Spine = require('spine')
WorksList = require('controllers/options/works/list')
WorksAdding = require('controllers/options/works/add')

Work = require('models/work')
Setting = require('models/setting')

class Works extends Spine.Controller

  elements:
    '#works-list': 'elList'
    '#works-adding': 'elAdding'

  constructor: ->
    super
    return @noAccount() if not Setting.get 'email'
    @html @render()

    Work.fetch()

    @list = new WorksList
    @elList.html @list.el
    
    @adding = new WorksAdding
    @elAdding.html @adding.el

  render: ->
    require('views/options/works')()

  noAccount: ->
    @html require('views/units/setup_account')()
    
module.exports = Works