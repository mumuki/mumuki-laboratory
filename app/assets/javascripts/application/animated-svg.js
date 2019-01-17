mumuki.load(function () {

  function _classCallCheck(instance, Constructor) {
    if (!(instance instanceof Constructor)) {
      throw new TypeError("Cannot call a class as a function");
    }
  }

  var noop = function noop() {
  };

  var State = function () {
    function State(name, movie) {
      _classCallCheck(this, State);
      this.movie = movie;
      this.name = name;
      this.callbacks = {
        end: noop,
        start: noop
      };
    }

    State.prototype.on = function on(event, callback) {
      this.callbacks[event] = callback;
      return this;
    };

    State.prototype.onEnd = function onEnd(callback) {
      return this.on('end', callback);
    };

    State.prototype.onEndSwitch = function onEndSwitch(character, stateName) {
      return this.onEnd(function () {
        return character.switch(stateName);
      });
    };

    State.prototype.onStart = function onStart(callback) {
      return this.on('start', callback);
    };

    State.prototype.play = function play(imageDomElement) {
      this.callbacks.start();
      this.movie.play(imageDomElement).then(this.callbacks.end.bind(this));
    };

    return State;
  }();

  var Scene = function () {
    function Scene(imageDomElement) {
      _classCallCheck(this, Scene);

      this.states = {};
      this.image = imageDomElement;
    }

    Scene.prototype.addState = function addState(state) {
      if (!this.currentState) this.currentState = state;
      this.states[state.name] = state;
      return this;
    };

    Scene.prototype.switch = function _switch(stateName) {
      this.currentState = this.states[stateName];
      this.play();
    };

    Scene.prototype.play = function play() {
      this.currentState.play(this.image);
    };

    return Scene;
  }();

  var Clip = function () {
    function Clip(src, duration) {
      this.src = src;
      this.duration = duration;
    }

    Clip.prototype.play = function play(where) {
      where.src = this.src;
      
      return new Promise((resolve) => {
        setTimeout(resolve, this.duration);
      });
    }

    return Clip;
  }();

  mumuki.State = State;
  mumuki.Scene = Scene;
  mumuki.Clip = Clip;

});
