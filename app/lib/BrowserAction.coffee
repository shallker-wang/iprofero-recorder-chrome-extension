class BrowserAction

  constructor: ->

  @openTab: (url)->
    chrome.tabs.create url: url

  @setBadgeTip: (text)->
    text = '' if text is 0 or text is '0'
    chrome.browserAction.setBadgeText text: "#{text}"

  @clearBadgeTip: ->
    @setBadgeTip '0'

  @listenClick: (listener)->
    chrome.browserAction.onClicked.addListener listener

module.exports = BrowserAction