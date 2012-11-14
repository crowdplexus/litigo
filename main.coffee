io = require('socket.io').listen 1337, ->
  console.log 'Server started on port 1337'

io.sockets.on 'connection', (socket) ->
  socket.emit 'msg', {hello: 'world'}
