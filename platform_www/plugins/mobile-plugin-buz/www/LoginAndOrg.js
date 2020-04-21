cordova.define("mobile-plugin-buz.LoginAndOrg", function(require, exports, module) {
var exec = require('cordova/exec');

module.exports = {
    logout:function(succ, fail){
        exec(succ, fail, 'LoginAndOrg', 'logout', []);
    },
    action:function(succ, fail, param){
        exec(succ, fail, 'LoginAndOrg', 'action', [param]);
    }
}

});
