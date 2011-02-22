(function() {
  var error, success;
  success = function(message) {
    return $('#results').append("<p class='success'>" + message + "</p>");
  };
  error = function(message) {
    $('#results').append("<p class='error'>" + message + "</p>");
    return $.post('/error', function(data) {
      return $('#theend').append("<p class='error'>" + data + "</p>");
    });
  };
  $(document).ready(function() {
    var Fix, app;
    try {
      Fix = NibJS.require('fixture');
      if (Fix != null) {
        success("Fix is correctly loaded and defined!");
      } else {
        error("NibJS.require seems buggy");
      }
      app = new Fix.App();
      if (app.say_hello() === "Hello from App") {
        success("Building an App instance seems working!");
      } else {
        error("Building an App instance has failed");
      }
      return $.post('/success', function(data) {
        return $('#theend').append("<p class='success'>" + data + "</p>");
      });
    } catch (err) {
      return error(err.message);
    }
  });
}).call(this);
