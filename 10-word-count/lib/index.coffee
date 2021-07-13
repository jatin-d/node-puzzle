through2 = require 'through2'

module.exports = ->
  words = 0
  lines = 1
  chars = 0
  bytes = 0

  transform = (chunk, encoding, cb) ->
    bytes = Buffer.byteLength(chunk, encoding)
    chars = chunk.length
    #splitting camel case string into different words
    chunk = chunk.replace(/([a-z0-9])([A-Z])/gm, '$1 $2')
    #get tokenized output for space seperated words and quoted words
    tokens = chunk.match(/\w+|"[^"]+"/g)
    words = tokens.length
    #counts lines separated by new line chars from the chunk
    linesGroup = chunk.split(/\n/)
    linesWithoutText = linesGroup.pop()
    if linesWithoutText
      linesGroup.push linesWithoutText
    lines = linesGroup.length
    return cb()

  flush = (cb) ->
    this.push {words, lines, chars, bytes}
    this.push null
    return cb()

  return through2.obj transform, flush