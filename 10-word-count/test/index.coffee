assert = require 'assert'
WordCount = require '../lib'
fs = require 'fs'
path = require 'path'

helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()

describe '10-word-count', ->

  it 'should count words in a phrase', (done) ->
    input = 'test'
    expected = words: 1, lines: 1, chars:4 , bytes:4
    helper input, expected, done

  it 'should count words in a phrase irrespective of case', (done) ->
    input = 'TEST'
    expected = words: 1, lines: 1, chars:4 , bytes:4
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1, chars:20 , bytes:20
    helper input, expected, done

  it 'should count words in a phrase irrespective of nuber of spaces between words', (done) ->
    input = 'this is       a basic       test'
    expected = words: 5, lines: 1, chars:32 , bytes:32
    helper input, expected, done

  it 'should ignore punctuation marks in a phrase', (done) ->
    input = 'this is a basic test, but with punctuation!'
    expected = words: 8, lines: 1, chars:43 , bytes:43
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1, chars:19 , bytes:19
    helper input, expected, done
  
  it 'should be able to count multiple quoted words in a single sentence', (done) ->
    input = 'This test "must not" consider "must not" as "two words"'
    expected = words: 7, lines: 1, chars:55 , bytes:55
    helper input, expected, done

  it 'should consider camel case as different words', (done) ->
    input = 'FunPuzzle is CamelCases'
    expected = words: 5, lines: 1, chars:23 , bytes:23
    helper input, expected, done

  it 'should consider camel case as different words irrespective of first char case', (done) ->
    input = 'funPuzzle is camelCases'
    expected = words: 5, lines: 1, chars:23 , bytes:23
    helper input, expected, done

  it 'should also count lines', (done) ->
    input = 'FunPuzzle is CamelCases \n and Lines too'
    expected = words: 8, lines: 2, chars:39 , bytes:39
    helper input, expected, done