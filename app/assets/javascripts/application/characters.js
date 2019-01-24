mumuki.load(function () {
  var characters = mumuki.characters || {};

  $.get('/character/animations.json',  function (animations) {
    Object.keys(animations).forEach((character) => {
      newCharacter(character);

      let promises = loadAnimations(character, animations[character].svgs);

      Promise.all(promises).then(() => {
        loadActions(character, animations[character].actions)
      });
    });
  });

  function newCharacter(name) {
    characters[name] = {};
    characters[name].svgs = {};
    characters[name].actions = {};
  }

  function loadAnimations(character, animations) {
    return animations.map((svg) =>
      addClip(character, svg))
  }

  function loadActions(character, actions) {
    Object.keys(actions || {}).forEach((action) => {
      addAction(character, action, parseAction(character, actions[action]));
    });
  }

  function addAction(character, actionName, action) {
    characters[character].actions[actionName] = action
  }

  function parseAction(character, action) {
    if (!action.type) return characters[character].svgs[action];

    return mumuki.animation[action.type](action.animations.map((animation) => parseAction(character, animation)));
  }

  addImage(characters, 'magnifying_glass_apparition', '/');
  addImage(characters, 'magnifying_glass_loop', '/');

  function addClip(character, name) {
    return addImage(characters[character].svgs, name, `/character/${character}/`);
  }

  function addImage(object, imageName, urlPrefix) {
    var url = urlPrefix + imageName + '.svg';
    if (object[imageName]) return Promise.resolve();

    return new Promise((resolve) => {
      $.get(url, function (data) {
        var duration = parseFloat($(data).find('animate').attr('dur') || 0, 10) * 1000;
        object[imageName] = new mumuki.Clip(url, duration);
        resolve();
      });
    });
  }

  mumuki.characters = characters;
});
