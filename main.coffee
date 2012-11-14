# Variables
exp = require 'express'
app = exp()

# App Configuration for all Environments
app.configure ->
  app.set 'view engine', 'jade'
  app.set 'views', __dirname + '/views'
  app.set exp.static __dirname + '/public'

# Hello World!
app.get '/', (req, res) ->
  res.send 'hello world!'

# Socket.IO
io = require('socket.io').listen 1337, ->
  console.log 'Server started on port 1337'

io.sockets.on 'connection', (socket) ->
  socket.emit 'msg', {hello: 'world'}
