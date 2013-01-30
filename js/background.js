var jQuery  = require("jqueryify");
var exports = this;
jQuery(function(){
  var App = require("background");
  exports.app = new App;
});