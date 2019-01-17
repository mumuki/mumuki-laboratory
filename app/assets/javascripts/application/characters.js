mumuki.load(function () {
  var characters = mumuki.characters || {};

  newCharacter('kibi');
  newCharacter('mebi');
  newCharacter('yobi');

  addClip('kibi', 'context', 'context');
  addClip('kibi', 'context', 'context2');
  addClip('kibi', 'corollary', 'corol2');
  addClip('kibi', 'corollary', 'corol3');
  addClip('kibi', 'corollary', 'corol4');
  addClip('kibi', 'failure', 'failure');
  addClip('kibi', 'failure', 'failure2');
  addClip('kibi', 'hint', 'hint');
  addClip('kibi', 'idle', 'idle');
  addClip('kibi', 'idle', 'idle2');
  addClip('kibi', 'idle', 'blink');
  addClip('kibi', 'talk', 'talk');
  addClip('kibi', 'talk', 'talk2');
  addClip('kibi', 'talk', 'talk3');
  addClip('kibi', 'talk', 'talk4');
  addClip('kibi', 'success/loop', 'success_l');
  addClip('kibi', 'success/loop', 'success2_l');

  addClip('mebi', 'context', 'context');
  addClip('mebi', 'context', 'context2');
  addClip('mebi', 'failure', 'failure');
  addClip('mebi', 'hint', 'hint');
  addClip('mebi', 'idle', 'idle');
  addClip('mebi', 'idle', 'idle2');
  addClip('mebi', 'idle', 'blink');
  addClip('mebi', 'talk', 'talk');
  addClip('mebi', 'talk', 'talk2');
  addClip('mebi', 'talk', 'talk3');
  addClip('mebi', 'talk', 'talk4');

  addClip('yobi', 'context', 'context');
  addClip('yobi', 'context', 'context2');
  addClip('yobi', 'failure', 'failure');
  addClip('yobi', 'hint', 'hint');
  addClip('yobi', 'idle', 'idle');
  addClip('yobi', 'idle', 'idle2');
  addClip('yobi', 'idle', 'blink');
  addClip('yobi', 'talk', 'talk');
  addClip('yobi', 'talk', 'talk2');
  addClip('yobi', 'talk', 'talk3');
  addClip('yobi', 'talk', 'talk4');

  addImage(characters, 'magnifying_glass_apparition', '/');
  addImage(characters, 'magnifying_glass_loop', '/');

  function addClip(character, context, name) {
    addImage(characters[character].svgs, name, `/character/${character}/${context}/`);
  }

  function newCharacter(name) {
    characters[name] = {};
    characters[name].actions = {};
    characters[name].svgs = {};
  }

  function addImage(object, imageName, urlPrefix) {
    var url = urlPrefix + imageName + '.svg';
    if (!object[imageName]) {
      $.get(url, function (data) {
        var duration = parseFloat($(data).find('animate').attr('dur') || 0, 10) * 1000;
        object[imageName] = new mumuki.Clip(url, duration);
      });
    }
  }

  mumuki.characters = characters;
});
