fs = require 'fs'
readline = require 'readline'
fileToRead = "#{__dirname}/../data/geo.txt"

exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode
  lineReader = readline.createInterface(
    input: fs.createReadStream(fileToRead)
    output: process.stdout
    terminal: false)
  counter = 0
  lineReader.on 'line', (line) ->
    line = line.split '\t'
    if line[3] == countryCode then counter += +line[1] - +line[0]
    return
  lineReader.on 'close', () ->
    cb null, counter