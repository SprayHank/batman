`#!/usr/bin/env node
`

# batman.js
# Batman
# Copyright Shopify, 2011

{Batman} = require('../lib/batman.js')

Batman.missingArg = (name) ->
  console.log('why so serious? (please provide ' + name + ')')

tasks = {}
aliases = {}

task = (name, description, f) ->
  if typeof description == 'function'
    f = description
  else
    f.description = description

  f.name = name

  tasks[name] = f
  return f

alias = (name, original) ->
  f = tasks[original]
  if !f.aliases
    f.aliases = []

  f.aliases.push(name)
  aliases[name] = f

task 'server', 'starts the Batman server', ->
  require('./server.js')

alias 's', 'server'

task 'gen', 'generate an app or files inside an app', ->
  require('./generator.js')

alias 'g', 'gen'

task '-T', ->
  for key in tasks
    if key.substr(0,1) == '-'
      continue

    string = key

    aliases = tasks[key].aliases
    if aliases
      string += ' (' + aliases.join(', ') + ')'

    desc = tasks[key].description
    if desc
      string += ' -- ' + desc

    console.log(string)

arg = process.argv[2]
if arg
  request = tasks[arg] || aliases[arg]
  if request then request() else console.log(arg + ' is not a known task')
else
  Batman.missingArg('task')
