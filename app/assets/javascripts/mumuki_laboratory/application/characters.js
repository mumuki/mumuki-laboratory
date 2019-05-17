mumuki.load(() => {
  let characters = mumuki.characters || {};

  muvment.loadCharacters(characters, '/character/animations.json').then((characterFinishedLoadingPromises) => {
    Promise.all(characterFinishedLoadingPromises).then((characterIds) => {
      mumuki.presenterCharacter = characters[atRandom(characterIds)];
      placeKidsAnimations();
    });
  });

  function placeKidsAnimations() {
    placeAnimation('.mu-kids-character-animation', 'blink');
    placeAnimation('.mu-kids-character-context', 'context');
  }

  function placeAnimation(selector, clip) {
    let canvas = $(selector);
    mumuki.presenterCharacter.playAnimation(clip, canvas);
  }

  function atRandom(array) {
    return array[Math.floor(Math.random() * array.length)];
  }  

  mumuki.characters = characters;
});
