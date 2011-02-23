function runTests(app) {
  setTimeout(function(){
    var ok = false;
    try { 
      ok = app.runTests(); 
      $("#feedback img").attr('src', '../test-' + ok + '.png');
    } 
    catch (err) { 
      $("body").append("<p>" + err.message + "</p>");
      $("#feedback img").attr('src', '../test-' + false + '.png');
      throw(err);
    }
  }, 200);
};
