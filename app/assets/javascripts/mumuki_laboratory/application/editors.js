/**
 * This module allows to read and write the current editor's contents
 * regardless if it is an standard editor or a custom editor
 */
mumuki.editors = {
  /**
   * @type {() => void}
   */
  _contentSyncer: null,

  /**
   * Updates the current editor's content
   *
   * @param {string} content
   */
  setContent(content) {
    const $customEditor = $('#mu-custom-editor-value');
    if ($customEditor.length) {
      $customEditor.val(content);
    } else {
      mumuki.editor.setContent(content);
    }
  },


  /**
   * @returns {EditorProperty[]}
   */
  getContents() {
    return mumuki.CustomEditor.hasSources ?
      mumuki.CustomEditor.getContents() :
      this.getStandardEditorContents();
  },

  /**
   * Syncs and returns the content objects of the standard editor form
   *
   * This content object may include keys like {@code content},
   * {@code content_extra} and {@code content_test}
   *
   * @returns {EditorProperty[]}
   */
  getStandardEditorContents() {
    this._syncContent();
    return $('.new_solution').serializeArray();
  },

  /**
   * Answers a submission object with a key for each of the current
   * editor sources.
   *
   * This method will use CustomEditor's sources if availble, or
   * standard editor's content sources otherwise
   *
   * @returns {Submission}
   */
  getSubmission() {
    let submission = {
      _pristine: $('.submission-results').children().length === 0
    };
    let contents = this.getContents();
    contents.forEach((it) => {
      submission[it.name] = it.value;
    });
    return submission;
  },

  /**
   * Copies current solution from it native rendering components
   * to the appropriate submission form elements.
   *
   * Both editors and runners with a custom editor that don't register a source should
   * register its own syncer function in order to {@link syncContent} work properly.
   *
   * @see registerContentSyncer
   * @see CustomEditor#addSource
   */
  _syncContent() {
    if (this._contentSyncer) {
      this._contentSyncer();
    }
  },

  /**
   * Sets a content syncer, that will be used by {@link _syncContent}
   * in ordet to dump solution into the submission form fields.
   *
   * Each editor should have its own syncer registered - otherwise previous or none may be used
   * causing unpredicatble behaviours - or cleared by passing {@code null}.
   *
   * As a particular case, runners with custom editors that don't add sources using {@link CustomEditor#addSource}
   * should set the {@code #mu-custom-editor-value} value within its syncer.
   *
   * @param {() => void} [syncer] the syncer, or null, if no sync'ing is needed
   */
  registerContentSyncer(syncer = null) {
    this._contentSyncer = syncer;
  },

  /**
   * @param {CustomEditorSource} source
   */
  addCustomSource(source) {
    mumuki.CustomEditor.addSource(source);
  }
};
