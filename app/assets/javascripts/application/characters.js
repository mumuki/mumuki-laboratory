mumuki.load(() => {
  let characters = mumuki.characters || {};

  muvment.loadCharacters(characters, '/character/animations.json').then((characterFinishedLoadingPromises) => {
    Promise.race(characterFinishedLoadingPromises).then((character) => {
      mumuki.presenterCharacter = characters[character];
      placeKidsAnimations();
    });
  });

  function placeKidsAnimations() {
    placeAnimation('.mu-kids-character > img', 'jump');
    placeAnimation('#mu-kids-character-context', 'context');
  }

  function placeAnimation(selector, clip) {
    let canvas = $(selector);
    mumuki.presenterCharacter.playAnimation(clip, canvas);
  }

  mumuki.characters = characters;
});
