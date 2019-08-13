$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden');
  })

  $('.question-votes').on('ajax:success', function(e) {
    var rates = e.detail[0];
    $('.question-score').html('<p>' + rates + '</p>')
  })

  .on('ajax:error', function(e) {
    var errors = e.detail[0];
    console.log(errors);
    $.each(errors, function(index, value) {
      $('.question-errors').html('<p>' + value + '</p>');
    })
  })
  
});
