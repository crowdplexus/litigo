# Variables
exp = require 'express'
app = exp()
http = require 'http'
server = http.createServer(app)
io = require('socket.io').listen server
mongoose = require("mongoose")

db = mongoose.createConnection("localhost", "litigo")

# App Configuration for all Environments
app.configure ->
  app.set 'view engine', 'jade'
  app.set 'views', __dirname + '/views'
  app.set exp.static __dirname + '/public'

# Database Connect - Mongoose
schema = mongoose.Schema
  thread: "string"
  author:
    nickname: "string"
    email: "string"
  msg: "string"
  date: "string"

# Database add comment function
newComment = (data, cb) ->
	Comment = db.model("Comment", schema)
	comment = new Comment
    thread: data.thread
    author:
      nickname: data.author.nickname
      email: data.email
    msg: data.msg
    date: data.date
	comment.save cb

# Database get comment function
getComment = (thread) ->
	Comment = db.model("Comment", schema)
	Comment.find
		thread: thread
	, "nickname email msg date", (err, data) ->
		console.log data

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
