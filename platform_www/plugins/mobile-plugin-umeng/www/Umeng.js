cordova.define("mobile-plugin-umeng.Umeng", function(require, exports, module) {
var exec = require('cordova/exec');

exports.coolMethod = function (arg0, success, error) {
    exec(success, error, 'Umeng', 'coolMethod', [arg0]);
};

});
