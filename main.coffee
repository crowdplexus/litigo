# Variables
exp = require 'express'
app = exp()
http = require 'http'
server = http.createServer(app)
io = require('socket.io').listen server
crypto = require 'crypto'
mongoose = require 'mongoose'

db = mongoose.createConnection("localhost", "litigo")

# App Configuration for all Environments
app.configure ->
  app.set 'view engine', 'jade'
  app.set 'views', __dirname + '/views'
  app.use exp.static __dirname + '/public'

# Database Connect - Mongoose
schema = mongoose.Schema
  thread: "string"
  author:
    nickname: "string"
    email: "string"
    avatar: "string"
  msg: "string"
  date: "string"

# Database add comment function
newComment = (data, cb) ->
	Comment = db.model("Comment", schema)
	comment = new Comment
    thread: data.thread
    author:
      nickname: data.author.nickname
      email: data.author.email
      avatar: "http://www.gravatar.com/avatar/#{crypto.createHash('md5').update(data.author.email).digest('hex')}"
    msg: data.msg
    date: new Date()
	comment.save cb

# Database get comment function
getComment = (thread, cb) ->
	Comment = db.model("Comment", schema)
	Comment.find {thread: thread}, cb

# Simple Temp random number genorator
randNum = () ->
	randomnumber = Math.floor(Math.random() * 11)
	return randomnumber
		
# Router
app.get '/embed/:shortname', (req, res) ->
  res.header 'Access-Control-Allow-Origin', '*'
  hash = req.params.shortname + '/' + crypto.createHash('md5').update(req.query.p + req.query.t).digest('hex')
  getComment 'test/index.htm3', (err, data) ->
    if (err)
      throw err
    res.render 'layout',
      hash: hash
      comments: data
	
# Temp function to add comment
app.get '/add', (req,res) ->
	res.send 'hello'
	data =
		thread: 'test/index.htm3'
		author:
			nickname: "Jon-test2"+randNum()
			email: "koo.studios@gmail.com"
		msg: "Hi!"
		date: "Sometime"+randNum()

	newComment data, (err) ->
		console.log 'callback'

# Temp function to get comment
app.get '/get', (req,res) ->
	res.send 'hello'
	getComment 'test/index.htm2', (err, data) ->
    console.log data
		
server.listen 1337, ->
  console.log 'Server started on port 1337'

# Socket.IO
io.sockets.on 'connection', (socket) ->
  console.log 'Someone connected!'
