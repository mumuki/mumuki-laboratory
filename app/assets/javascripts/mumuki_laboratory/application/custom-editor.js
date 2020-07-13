var mumuki = mumuki || {};

(function (mumuki) {

  var CustomEditor = {
    /**
     * @typedef {{getContent: () => {name: string, value: string}}} CustomEditorSource
     */

    /**
     * @type {CustomEditorSource[]}
     */
    sources: [],

    /**
     * @param {CustomEditorSource} source
     */
    addSource(source) {
      CustomEditor.sources.push(source);
    },

    /**
     * @deprecated use getContents instead
     */
    getContent() {
      return this.getContents();
    },

    /**
     * @returns {{name: string, value: string}[]}
     */
    getContents() {
      return CustomEditor.sources.map( e => e.getContent() );
    },

    clearSources() {
      this.sources = [];
    },

    get hasSources() {
      return this.sources.length > 0;
    }
  };

  mumuki.load(() => {
    mumuki.CustomEditor.clearSources();
  });

  /**
   * This module allows custom editors to register
   * content sources that can not me mapped to standard selectors {@code mu-custom-editor-value},
   * {@code mu-custom-editor-extra} and {@code mu-custom-editor-test}
   *
   * CustomEditor sources are cleared after page reload even when using turbolinks
   *
   * @module mumuki.CustomEditor
   */
  mumuki.CustomEditor = CustomEditor;
}(mumuki));
