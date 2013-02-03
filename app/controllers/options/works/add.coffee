Spine = require('spine')
iProfero = require('lib/iProfero')
Work = require('models/work')

class Add extends Spine.Controller

  evStop = (ev)->
    ev.stopPropagation()
    ev.preventDefault()

  elements:
    'select.projects' : 'elProject'
    'select.activities': 'elActivity'
    'select.hours': 'elHour'

  events:
    'click [action=add]': 'onClickAdd'

  constructor: ->
    super
    iProfero.getProjectsAndActivities @onGetProjectsAndActivities

  render: (data)->
    require('views/options/works/add')(data)

  onClickAdd: (click)=>
    evStop click
    @createWork()

  createWork: ->
    projId = @elProject.val()
    projName = @elProject.find('option:selected').text()
    activityId = @elActivity.val()
    activityName = @elActivity.find('option:selected').text()
    hours = @elHour.val()
    now = new Date
    work = new Work
      'proj_id': projId
      'proj_name': projName
      'activity_id': activityId
      'activity_name': activityName
      'hours': hours
      'time': now.getTime()
    work.save()

  onGetProjectsAndActivities: (data)=>
    @html @render data

module.exports = Add