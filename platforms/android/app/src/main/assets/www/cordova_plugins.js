cordova.define('cordova/plugin_list', function(require, exports, module) {
  module.exports = [
    {
      "id": "ir.metrix.cordova.Metrix",
      "file": "plugins/ir.metrix.cordova/www/metrix.js",
      "pluginId": "ir.metrix.cordova",
      "clobbers": [
        "Metrix"
      ]
    }
  ];
  module.exports.metadata = {
    "cordova-plugin-whitelist": "1.3.4",
    "ir.metrix.cordova": "1.6.0"
  };
});