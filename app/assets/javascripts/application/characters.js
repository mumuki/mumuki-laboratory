mumuki.load(() => {
  let characters = mumuki.characters || {};

  $.get('/character/animations.json',  (animations) => {
    Object.keys(animations).forEach((character) => {
      newCharacter(character);

      let promises = loadAnimations(character, animations[character].svgs);

      Promise.all(promises).then(() => {
        loadActions(character, animations[character].actions);
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
      addClip(character, svg));
  }

  function loadActions(character, actions) {
    Object.keys(actions || {}).forEach((action) =>
      addAction(character, action, parseAction(character, actions[action])));
  }

  function addAction(character, actionName, action) {
    characters[character].actions[actionName] = action;
  }

  function parseAction(character, action) {
    if (!action.type) return characters[character].svgs[action];

    return mumuki.animation[action.type](action.animations.map((animation) =>
      parseAction(character, animation)));
  }

  function addClip(character, name) {
    return mumuki.animation.addImage(characters[character].svgs, name, `/character/${character}/`);
  }

  mumuki.characters = characters;
});
