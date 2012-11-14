# Variables
exp = require 'express'
app = exp()
http = require 'http'
server = http.createServer(app)
io = require('socket.io').listen server

# App Configuration for all Environments
app.configure ->
  app.set 'view engine', 'jade'
  app.set 'views', __dirname + '/views'
  app.set exp.static __dirname + '/public'

# Database Connect - Mongoose

# Router
app.get '/embed/:id', (req, res) ->
  res.render 'layout'

server.listen 1337, ->
  console.log 'Server started on port 1337'

# Socket.IO
io.sockets.on 'connection', (socket) ->
  console.log 'Someone connected!'
