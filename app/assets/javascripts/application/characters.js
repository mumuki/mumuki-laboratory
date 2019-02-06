mumuki.load(() => {
  let characters = mumuki.characters || {};

  $.get('/character/animations.json',  (animations) => {
    loadCharacters(animations.main);
    loadAnimationGroup(animations.extra);
  });

  function loadAnimationGroup(animations) {
    return Object.keys(animations).map((character) => {
      newCharacter(character);

      return loadAnimations(character, animations[character].svgs).then(() =>
        loadActions(character, animations[character].actions)).then(() =>
        character);
    });
  }

  function loadCharacters(animations) {
    var characterFinishedLoadingPromises = loadAnimationGroup(animations);

    Promise.race(characterFinishedLoadingPromises).then((character) => {
      mumuki.character = characters[character];
      placeAnimations();
    });
  }

  function newCharacter(name) {
    characters[name] = {};
    characters[name].svgs = {};
    characters[name].actions = {};
  }

  function loadAnimations(character, animations) {
    return Promise.all(animations.map((svg) =>
      addClip(character, svg)));
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

    return muvment.animation[action.type](action.animations.map((animation) =>
      parseAction(character, animation)));
  }

  function addClip(character, name) {
    return muvment.animation.addImage(characters[character].svgs, name, `/character/${character}/`);
  }

  function placeAnimations() {
    placeClip('mu-kids-character-animation', 'blink');
    placeAction('mu-kids-character-context', 'context');
  }

  function placeAction(imageId, action) {
    placeAnimation('actions', imageId, action);
  }

  function placeClip(imageId, clip) {
    placeAnimation('svgs', imageId, clip);
  }

  function placeAnimation(animationType, imageId, clip) {
    let image = $(`#${imageId}`)[0];
    mumuki.character[animationType][clip].play(image);
  }

  mumuki.characters = characters;
});
