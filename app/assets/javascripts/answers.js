$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })

  $('.answer-votes').on('ajax:success', function(e) {
    var rates = e.detail[0];
    $('.answer-score').html('<p>' + rates + '</p>')
  })
  .on('ajax:error', function(e) {
    var errors = e.detail[0];
    $.each(errors, function(index, value) {
      $('.answer-errors').html('<p>' + value + '</p>');
    })
  })
});


