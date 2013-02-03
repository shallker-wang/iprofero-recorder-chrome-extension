Spine = require('spine')

class Navs extends Spine.Controller

  evStop = (ev)->
    ev.preventDefault()
    ev.stopPropagation()

  elements:
    'li': 'elNavs'

  events:
    'click li': 'onClickLi'

  constructor: ->
    super
    @append @render()
    @initRoutes()

    # Spine.Route.bind 'change', (a)-> console.log 'onChange', a

  initRoutes: ->
    for el in @elNavs
      @registerRoute $(el).attr('nav')

  registerRoute: (route)->
    register = {}
    register[route] = @onRoute 
    @routes register

  onRoute: (route)=>
    @active route.match[0]

  render: ->
    require('views/options/navs')()

  onClickLi: (click)=>
    evStop click
    @navigate $(click.currentTarget).attr('nav')

  active: (nav)->
    @elNavs.removeClass 'active'
    @elNavs.filter("[nav='#{nav}']").addClass 'active'

module.exports = Navs