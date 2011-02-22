jasmine = require('jasmine-node')

for key in jasmine
  global[key] = jasmine[key]

isVerbose = false
showColors = true

logger = (runner, log)->
  process.exit runner.results().failedCount

# Execute nibjs jasmine specs
folder = __dirname
jasmine.executeSpecsInFolder folder, logger, isVerbose, showColors, "_spec.coffee$"
