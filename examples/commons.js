var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
NibJS.TestSuite = {
  tests: ['1-basic', '2-coffee'],
  indexOf: function(test) {
    var i, t, _len, _ref;
    _ref = NibJS.TestSuite.tests;
    for (i = 0, _len = _ref.length; i < _len; i++) {
      t = _ref[i];
      if (t === test) {
        return i;
      }
    }
    return null;
  },
  findNext: function() {
    var index, loc, next, test;
    loc = window.location;
    if ((loc.hash != null) && loc.hash !== "") {
      test = loc.hash.substring(1);
      index = NibJS.TestSuite.indexOf(test);
      if (index != null) {
        return next = NibJS.TestSuite.tests[index + 1];
      }
    }
  },
  runNext: function() {
    var moveNext, next;
    next = NibJS.TestSuite.findNext();
    if (next != null) {
      moveNext = function() {
        return window.location = "../" + next + "/index.html";
      };
      return setTimeout(moveNext, 1000);
    }
  },
  runOne: __bind(function(app) {
    var runit;
    runit = function() {
      var ok;
      try {
        ok = app.runTests();
        $("#feedback img").attr('src', "../test-" + ok + ".png");
        return NibJS.TestSuite.runNext();
      } catch (err) {
        $("body").append("<p>" + err.message + "</p>");
        $("#feedback img").attr('src', "../test-false.png");
        throw err;
      }
    };
    return setTimeout(runit, 1500);
  }, this)
};