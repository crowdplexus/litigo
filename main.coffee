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
mongoose = require("mongoose")
db = mongoose.createConnection("localhost", "litigo")
schema = mongoose.Schema(thread: "string", nickname: "string", email: "string", msg: "string", date: "string")

# Database add comment function
newComment = (thread, msg, nickname, email, date) ->
	Comment = db.model("Comment", schema)
	comment = new Comment(thread: thread, nickname: nickname, email: email, msg: msg, date: date)
	comment.save (err) ->
		if (err)
			return false
		else
			return true

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
