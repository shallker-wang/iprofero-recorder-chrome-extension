var jQuery  = require("jqueryify");
var exports = this;
jQuery(function(){
  var App = require("options");
  exports.app = new App({el: $("#recorder-options")});
});