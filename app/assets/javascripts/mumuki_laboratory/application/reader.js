
(function(mumuki) {
  function readText(selector) {
    let player = new talkify.TtsPlayer().enableTextHighlighting();

    let playlist = new talkify.playlist()
      .begin()
      .usingPlayer(player)
      .withRootSelector(selector)
      .build();

    playlist.play();
  }

  mumuki.reader = {};
  mumuki.reader.readText = readText;

  mumuki.load(() => {
    //talkify.config.useSsml = true;
    //talkify.config.remoteService.active = false;
    talkify.config.remoteService.apiKey = "665a3969-2f1a-4c3f-b5d7-b6ebdffd3430";
  })
}(mumuki))

