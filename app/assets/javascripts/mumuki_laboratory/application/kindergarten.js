mumuki.load(() => {
  mumuki.kindergarten = {
    speak(text, locale) {
      const msg = new SpeechSynthesisUtterance();
      msg.text = text;
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
    }
  };

  mumuki.kindergarten.disablePlaySoundButtonIfNotSupported();

});
