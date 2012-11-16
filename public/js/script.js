/*
*  Client Side Scripts and Functions
*/


$(document).ready(function() {
  // Tell parent how tall the document is
  parent.postMessage($(document).height(), '*');  

  // Connect to socket.IO
  var socket = io.connect('http://localhost:1337');
  socket.emit('switch', $('body').data('hash'));

  // Common functions namespaced to Litigo
  var Litigo = {
    error: function (msg) {
      $('#form').append('<div class="error"><b>Warning!</b> '+msg+'</div>');
      $('.error').delay(5000).fadeOut();
    }
  };

  //------------ EVENTS -----------//

  // Removes and replaces placeholders on focus and on blur, respectively
  $('input[type=text], #commentBox').on('focus', function() {
    if ($(this).val() === $(this).data('placeholder')) $(this).val('').css('color', '#333');
  }).on('blur', function() {
    if (!$(this).val()) $(this).val($(this).data('placeholder')).css('color', '#AAA');
  });


  // Distribute!
  socket.on('distribute', function(data) { 
      // Preprend this to comments
      // TODO Use templating maybe?
      $('#comments').prepend('<article class="new"><img src="' + data.author.avatar + '"><span class="nick">' + data.author.nickname + '</span><span class="date">' + data.date + '</span><div class="post-body"><p>' + data.msg + '</p></div></article>'); parent.postMessage($(document).height(), "*"); 
      $('.new').animate({
        'marginTop': '0',
        'opacity': '1'
      },200);
  }); 
  
  // Submit form 
  $('#submit').on('click', function() { 
    // Checks to see if anyting is empty (in which it would have the placeholder)
    var empty = false;
    $('input[type=text], #commentBox').each(function(i) {
      if ($(this).val() === $(this).data('placeholder')) empty = true;
    });

    // 
    if (empty == true) {
      Litigo.error('Please check that all fields are completed.');
    } else {
      // Combine everything into data
      var data = {
        thread: $('body').data('hash'),
        author: {
          nickname: $('#nick').val(),
          email: $('#email').val()
        },
        msg: $('#commentBox').val()
      };

      // Emit data back to server
      socket.emit('comment', data, function() {
        $('input[type="text"], #commentBox').each(function(i) {
          $(this).val($(this).data('placeholder'));
        });
      });
    }
  });
});
