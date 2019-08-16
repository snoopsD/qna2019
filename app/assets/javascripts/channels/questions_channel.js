App.cable.subscriptions.create('QuestionsChannel', {
  connected(){ 
    if ($('.questions').length) {
      this.perform('follow');
    } else {
      this.perform('unfollow');
    }
  },    
  received(data) {
    $('.questions').prepend(data) }
});
