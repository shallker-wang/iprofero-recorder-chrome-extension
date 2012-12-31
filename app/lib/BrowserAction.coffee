class BrowserAction

  constructor: ->

  @openTab: (url)->
    chrome.tabs.create url: url

  @setBadgeTip: (tip)->
    tip = '' if tip is 0 or tip is '0'
    chrome.browserAction.setBadgeText text: String tip

  @clearBadgeTip: ->
    @setBadgeTip ''

  @setToolTip: (tip)->
    chrome.browserAction.setTitle title: String tip

  @listenClick: (listener)->
    chrome.browserAction.onClicked.addListener listener

module.exports = BrowserAction