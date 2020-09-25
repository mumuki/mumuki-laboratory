mumuki.load(() => {
  mumuki.kindergarten = {
    speak(selector, locale) {
      const msg = new SpeechSynthesisUtterance();
      msg.text = $(selector).text();
      msg.lang = locale.split('_')[0];
      msg.pitch = 0;
      window.speechSynthesis.speak(msg);
    },
    showContext() {
      mumuki.kids.showContext();
    },
    disablePlaySoundButtonIfNotSupported() {
      if (!window.speechSynthesis) {
        const $button = $('.mu-kindergarten-play-description')
        $button.prop('disabled', true);
        $button.css('cursor', 'not-allowed');
        $button.children('i').removeClass('fa-volume-up').addClass('fa-volume-off');
      }
    },
    toggleHint() {
      $('.mu-kindergarten-light-speech-bubble').toggleClass('open');
    },
    toggleHintMedia() {
      const $hintMedia = $('.mu-kindergarten-hint-media');
      const $i = $('.expand-or-collapse-hint-media').children('i');
      $i.toggleClass('fa-caret-down').toggleClass('fa-caret-up');
      $hintMedia.toggleClass('open');
    }
  };

  mumuki.kindergarten.disablePlaySoundButtonIfNotSupported();

});
