function runTests(app) {
  setTimeout(function(){
    var ok = false;
    try { ok = app.runTests(); } 
    catch (err) { ok = false; }
    $("#feedback img").attr('src', '../test-' + ok + '.png');
  }, 200);
};
