Spine = require('spine')

class OptionsNav extends Spine.Controller

  template: require('views/options.nav')()

  tag: 'ul'
  className: 'nav nav-tabs options-nav'

  elements:
    'li': 'navs'

  events:
    'click li': 'triggle'

  constructor: ->
    super
    @append @render()

    @routes
      '/welcome': (route)-> @active 'welcome'
      '/account': (route)-> @active 'account'
      '/works': (route)-> @active 'works'
      '/records': (route)-> @active 'records'

  render: ->
    @template

  triggle: (ev)->
    ev.preventDefault()
    @nav $(ev.currentTarget).attr 'data-nav'

  nav: (section)->
    @navigate "/#{section}"

  routing: (route)->
    @active route.match.input

  getNav: (section)->
    return @navs.filter "[data-nav=#{section}]"

  active: (section)->
    @navs.removeClass 'active'
    @getNav(section).addClass 'active'

module.exports = OptionsNav