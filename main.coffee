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
app.get '/embed/:shortname', (req, res) ->
  shortname = req.params.shortname
  hash = req.query.p + req.query.t
  res.render 'layout',
    shortname: shortname
    hash: hash

server.listen 1337, ->
  console.log 'Server started on port 1337'

# Socket.IO
io.sockets.on 'connection', (socket) ->
  console.log 'Someone connected!'
