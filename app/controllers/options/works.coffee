Spine = require('spine')

Work = require('models/work')
PROJECTS = require('data/projects')
ACTIVITIES = require('data/activities')

class Works extends Spine.Controller

  className: 'tab-pane option-works'

  elements:
    '#select-work-project': 'project'
    '#select-work-activity': 'activity'
    '#select-work-hours': 'hours'
    'ul.works-list': 'list'

  events:
    'click #a-work-add': 'add'
    'click .works-list .work-delete': 'del'

  constructor: ->
    super
    Work.fetch()
    data =
      works: Work.all()
      projects: PROJECTS
      activities: ACTIVITIES
    @html @render data

  render: (data)->
    require('views/options/works')(data)

  del: (ev)->
    ev.preventDefault()
    id = $(ev.target).parent().attr('data-work-id')
    Work.destroy(id)
    @refresh()

  add: (ev)->
    ev.preventDefault()
    now = new Date
    work = new Work
    work.proj_id = @project.val()
    work.proj_name = @project.find('option:selected').text()
    work.activity_id = @activity.val()
    work.activity_name = @activity.find('option:selected').text()
    work.hours = @hours.val()
    work.time = now.getTime()
    work.save()
    @refresh()

  refresh: ->
    @navigate '/temp'
    @navigate '/works'
    
module.exports = Works