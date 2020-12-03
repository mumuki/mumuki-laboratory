/**
 * A general-purpuose event system
 */
mumuki.events = {
  _handlers: {},

  /**
   * Enables registration of event handlers for the given event name
   *
   * @param {string} eventName
   */
  enable(eventName) {
    this._handlers[eventName] = this._handlers[eventName] || [];
  },

  /**
   * Registers a listener that will be called whenever the given event is produced.
   * If the event is not enabled, the given handler is simply ignored.
   *
   * @param {string} eventName the event to listen to
   * @param {(event: any) => void} handler
   */
  on(eventName, handler) {
    if (this._handlers[eventName]) {
      this._handlers[eventName].push(handler);
    }
  },

  /**
   * Fires a given event
   *
   * @param {string} eventName
   * @param {any} [value]
   */
  fire(eventName, value = null) {
    if (this._handlers[eventName]) {
      this._handlers[eventName].forEach(it => it(value));
    }
  },

  /**
   * Clears handlers of the given event
   *
   * @param {string} eventName
   */
  clear(eventName) {
    if (this._handlers[eventName]) {
      this._handlers[eventName] = [];
    }
  }
};
