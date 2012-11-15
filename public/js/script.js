$(document).ready(function() {
  parent.postMessage($(document).height(), '*');  
  var socket = io.connect('http://localhost:1337');

  $('input[type=text], #commentBox').on('focus', function() {
    if ($(this).val() == $(this).data('placeholder')) $(this).val('').css('color', '#333');
  }).on('blur', function() {
    if (!$(this).val()) $(this).val($(this).data('placeholder')).css('color', '#AAA');
  });

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
