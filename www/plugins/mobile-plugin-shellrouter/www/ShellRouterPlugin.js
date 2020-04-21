cordova.define("mobile-plugin-shellrouter.ShellRouterPlugin", function(require, exports, module) {

  var ShellRouterPlugin = function () {
  };

  ShellRouterPlugin.prototype.pushState = function (succ, fail, path) {
    cordova.exec(succ, fail, 'ShellRouterPlugin', 'pushState', [path]);
  };
  
  ShellRouterPlugin.prototype.replaceState = function (succ, fail, path) {
    cordova.exec(succ, fail, 'ShellRouterPlugin', 'replaceState', [path]);
  };

  ShellRouterPlugin.prototype.goBack = function (succ, fail) {
    cordova.exec(succ, fail, 'ShellRouterPlugin', 'goBack', []);
  };
 
  var instance = new ShellRouterPlugin();
   
  module.exports = instance;


});
