mumuki.load(function () {
  let noop = function noop() {};

  class State {
    constructor(name, movie) {
      this.movie = movie;
      this.name = name;
      this.callbacks = {
        end: noop,
        start: noop
      };
    }

    on(event, callback) {
      this.callbacks[event] = callback;
      return this;
    };

    onEnd(callback) {
      return this.on('end', callback);
    };

    onEndSwitch(character, stateName) {
      return this.onEnd(function () {
        return character.switch(stateName);
      });
    };

    onStart(callback) {
      return this.on('start', callback);
    };

    play(imageDomElement) {
      this.callbacks.start();
      this.movie.play(imageDomElement).then(this.callbacks.end.bind(this));
    };
  };

  class Scene {
    constructor(imageDomElement) {
      this.states = {};
      this.image = imageDomElement;
    }

    addState(state) {
      if (!this.currentState) this.currentState = state;
      this.states[state.name] = state;
      return this;
    };

    switch(stateName) {
      this.currentState = this.states[stateName];
      this.play();
    };

    play() {
      this.currentState.play(this.image);
    };
  };

  class Clip {
    constructor(src, duration) {
      this.src = src;
      this.duration = duration;
    }

    play(where) {
      where.src = this.src;
      
      return new Promise((resolve) => {
        setTimeout(resolve, this.duration);
      });
    }
  };

  class Animation {
    constructor(clips, player) {
      this.clips = clips;
      this.player = player;
    }

    play(where) {
      return this.player(this.clips, where);
    };
  };

  function sequence(clips) {
    return new Animation(clips, function (clips, where) {
      let accum = Promise.resolve();

      clips.forEach((clip) =>
        accum = accum.then(() => 
          clip.play(where)));
      
      return accum;
    });
  }

  function oneOf(clips) {
    return new Animation(clips, function (clips, where) {
      return clips[Math.floor(Math.random() * clips.length)].play(where)
    });
  }

  mumuki.State = State;
  mumuki.Scene = Scene;
  mumuki.Clip = Clip;

  mumuki.animation = { sequence: sequence, oneOf: oneOf };
});
