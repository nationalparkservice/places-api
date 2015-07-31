/* jshint camelcase: false */
module.exports = function (config) {
  return function (req, callback) {
    var tools = require('./tools')(config);
    var auths = tools.splitAuthHeader(req.headers.authorization);
    tools.getAccessSecret(auths.oauth_token, function (tokens) {
      if (tokens) {
        tools.getUserInfo(tokens.request_token, tokens.request_token_secret, auths.oauth_token, tokens.access_token_secret, function (e, username, userId) {
          // Verify the signature
          var origSig = auths.oauth_signature;
          var requestedUrl = req.protocol + '://' + req.get('Host') + req.originalUrl;
          var compareSigs = tools.osmOauth._getSignatures.map(function (getSignature) {
            return encodeURIComponent(getSignature(req.method, requestedUrl, tools.verification.baseString(auths), tokens.access_token_secret));
          });
          if (compareSigs.indexOf(origSig) > -1) {
            callback({
              'valid': !e,
              'userId': userId,
              'username': username
            });
          } else {
            callback({
              'valid': false
            });
          }
        });
      } else {
        callback({
          'valid': false
        });
      }
    });
  };
};

