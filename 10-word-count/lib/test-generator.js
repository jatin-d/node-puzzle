const fs = require("fs");
const FIXTURES_BASE_DIR = `${__dirname}/../test/fixtures`;
function generateFixtureJestSnippets(files) {

  const open = `
# WARNING: this file is generated automatically
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

describe '10-word-count fixtures generated', ->`;

  const testCase = `
    
    `
  const specs = files
    .map((fname) => {
      const specName = fname.split(".txt")[0].split(",");
      return `
  it '${fname} should have ${specName[0]} lines, ${specName[1]} words, ${specName[2]} chars', (done) ->
      input = fs.readFileSync '${FIXTURES_BASE_DIR}/${fname}', {encoding:'utf8'}
      expected = lines: ${specName[0]}, words: ${specName[1]}, chars: ${specName[2]}, bytes:${specName[2]}
      helper input, expected, done`;
    }).join("\n");
  return `${open}${specs}`;
}
function parseFileTree(err, files) {
  // ...
  const tmp = generateFixtureJestSnippets(files.filter((f) => f !== "tests"));
  fs.writeFileSync(`${FIXTURES_BASE_DIR}/../fixtures_generated.coffee`, tmp);
}
fs.readdir(FIXTURES_BASE_DIR, parseFileTree);