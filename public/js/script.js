$(document).ready(function() {
  
  var socket = io.connect('http://localhost:1337');

  $('#submit').on('click', function() {
    var data = {
      author: {
        nickname: $('#nick').val(),
        email: $('#email').val()
      },
      msg: $('#commentBox').val()
    };
    console.log(data);
  });
});
