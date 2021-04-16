mumuki.load(() => {
  class File {
    static get NAME_CLASS() { return '.file-name'; }
    static get DELETE_BUTTON_CLASS() { return '.delete-file-button'; }

    constructor(tab, editor) {
      this.tab = tab;
      this.editor = editor;
    }

    initialize(name) {
      this.name = name;
      this.unselect();

      return this;
    }

    get name() {
      return this.tab.find(File.NAME_CLASS).text();
    }

    set name(name) {
      return this.tab.find(File.NAME_CLASS).text(name);
    }

    get deleteButton() {
      return this.tab.find(File.DELETE_BUTTON_CLASS);
    }

    get isSelected() {
      return this.tab.children().first().hasClass("active");
    }

    setUpOnRemove(handler) {
      this.tab.find(File.DELETE_BUTTON_CLASS).click(() => {
        handler(this);
      });
    }

    remove() {
      const wasSelected = this.isSelected;

      this.tab.remove();
      this.editor.remove();

      return wasSelected;
    }

    select() {
      this._selectElement(this.tab);
      this._selectElement(this.editor);
    }

    unselect() {
      this._unselectElement(this.tab);
      this._unselectElement(this.editor);
    }

    _selectElement(element) {
      element.addClass('active');
      element.addClass('show');
    }

    _unselectElement(element) {
      element.removeClass('active');
      element.removeClass('show');
    }
  }

  class MultipleFileEditor {
    constructor(tabsContainer, editorsContainer) {
      this.tabsContainer = tabsContainer;
      this.editorsContainer = editorsContainer;

      this.MAX_TABS = 5;

      this._addFileButton = this.tabsContainer.siblings('.add-file-button');
      this.updateButtonsVisibility();
    }

    get mainFile() {
      return this._mainFile || '';
    }

    set mainFile(mainFile) {
      this._mainFile = mainFile;
    }

    get files() {
      const editors = this.editors;

      return this.tabs.map((i, tab) => {
        return new File($(tab), $(editors[i]));
      });
    }

    get tabs() {
      return this.tabsContainer.children();
    }

    get editors() {
      return this.editorsContainer.find('.file-editor');
    }

    get highlightModes() {
      return this._getDataFromHiddenInput('#highlight-modes');
    }

    get locales() {
      return this._getDataFromHiddenInput('#multifile-locales');
    }

    setUpAddFile() {
      this._addFileButton.click(() => {
        this._addFile();
      });
    }

    setUpDeleteFiles() {
      this.files.each((i, file) => {
        this.setUpDeleteFile(file);
      });
    }

    setUpDeleteFile(file) {
      file.setUpOnRemove(() => this._deleteFile(file));
    }

    updateButtonsVisibility() {
      const filesCount = this._getFilesCount();

      this._setVisibility(this._addFileButton, filesCount < this.MAX_TABS);
      this.files.toArray().forEach(file => {
        this._setVisibility(file.deleteButton, file.name !== this.mainFile && filesCount > 1);
      });
    }

    resetEditor() {
      const defaultContents = this._getDataFromHiddenInput('#multifile-default-content');
      mumuki.page.editors.each(function (i, editor) {
        editor.getDoc().setValue(defaultContents[i] ? defaultContents[i].content : '');
      });
    }

    _addFile() {
      let name = prompt(this.locales.insert_file_name);
      const alreadyExists = this.files.toArray().some(it => it.name === name);
      if (!name || !name.includes('.') || alreadyExists) return;
      name = this._sanitize(name);

      const id = `editor-file-${this._getFilesCount()}`;
      this.tabsContainer.append(this._createTab(name, id));
      this.editors.parent().last().append(this._createEditor(name, id));
      const file = this.files.last().get(0).initialize(name);
      this.setUpDeleteFile(file);

      this.updateButtonsVisibility();
    }

    _deleteFile(file) {
      const index = this.files.toArray()
        .map(file => file.name)
        .indexOf(file.name);
      const previousIndex = Math.max(index - 1, 0);

      const wasSelected = file.remove();
      if (wasSelected) {
        this.tabs.children()[previousIndex].click();
      }

      this.updateButtonsVisibility();
    }

    _createTab(name, id) {
      const tab = this.tabs.last().clone();
      let link = tab.children().first();
      link.attr('data-bs-target', `#${id}`);
      link.removeClass('active');

      return tab;
    }

    _createEditor(name, id) {
      const editor = this.editors.last().clone();
      editor.attr('id', id);
      editor.find('.CodeMirror').remove();

      const textarea = editor.children().first();
      this._setUpTextArea(textarea, `solution_content[${name}]`, `solution[content[${name}]]`);

      const highlightMode = this._getHighlightModeFor(name);
      const codeMirrorEditor = new mumuki.editor.CodeMirrorBuilder(textarea.get(0))
        .setupEditor()
        .setupMinLines(textarea.data('lines'))
        .setupLanguage(highlightMode)
        .build();

      mumuki.page.editors.push(codeMirrorEditor);

      codeMirrorEditor.on("change", (event) => {
        textarea.val(event.getValue());
      });

      const solutionTextArea = $('.new_solution').find('textarea').last();
      this._setUpTextArea(solutionTextArea, '', '');

      return editor;
    }

    _getFilesCount() {
      return this.files.length;
    }

    _setUpTextArea(textarea, id, name) {
      textarea.attr('id', id);
      textarea.attr('name', name);
      textarea.text('');
      textarea.val('');
    }

    _getHighlightModeFor(name) {
      const extension = name.split('.').pop();
      const language = this.highlightModes.find((it) => it.extension === extension);

      return language && language.highlight_mode || extension;
    }

    _sanitize(name) {
      return name.replace(/[^0-9A-Z\.-]/ig, "_");
    }

    _setVisibility(element, isVisible) {
      if (isVisible) element.show(); else element.hide();
    }

    _getDataFromHiddenInput(name) {
      return JSON.parse($(name).val());
    }
  }

  const setUpTabsBehavior = () => {
    const tabsContainer = $('.nav-tabs').last();
    if (!tabsContainer.length) return;
    const editorsContainer = $('.tab-content');

    const multipleFileEditor = new MultipleFileEditor(tabsContainer, editorsContainer);
    mumuki.multipleFileEditor = multipleFileEditor;
    multipleFileEditor.setUpAddFile();
    multipleFileEditor.setUpDeleteFiles();
  };

  $(document).ready(setUpTabsBehavior);

});
