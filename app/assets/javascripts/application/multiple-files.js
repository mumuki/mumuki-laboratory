mumuki.load(function () {

  function File(tab, editor) {
    this.tab = tab;
    this.editor = editor;
  }

  File.FILE_NAME_CLASS = '.file-name';
  File.DELETE_BUTTON_CLASS = '.delete-file-button';

  File.prototype = {
    initialize: function(name) {
      this.setName(name);
      this.unselect();

      return this;
    },

    getName: function() {
      return this.tab.find(File.FILE_NAME_CLASS).text();
    },

    setName: function(name) {
      return this.tab.find(File.FILE_NAME_CLASS).text(name);
    },

    isSelected: function() {
      return this.tab.hasClass("active");
    },

    setUpOnRemove: function(handler) {
      this.tab.find(File.DELETE_BUTTON_CLASS).click(function() {
        handler(this);
      }.bind(this));
    },

    remove: function() {
      var wasSelected = this.isSelected();

      this.tab.remove();
      this.editor.remove();

      return wasSelected;
    },

    select: function() {
      this._selectElement(this.tab);
      this._selectElement(this.editor);
    },

    unselect: function() {
      this._unselectElement(this.tab);
      this._unselectElement(this.editor);
    },

    _selectElement: function(element) {
      element.addClass('active');
      element.addClass('in');
    },

    _unselectElement: function(element) {
      element.removeClass('active');
      element.removeClass('in');
    }
  };

  function MultipleFileEditor(tabsContainer, editorsContainer) {
    this.tabsContainer = tabsContainer;
    this.editorsContainer = editorsContainer;

    this.MAX_TABS = 5;

    this._addFileButton = this.tabsContainer.siblings('.add-file-button');
    this._updateButtonsVisibility();
  }

  MultipleFileEditor.prototype = {
    files: function() {
      var editors = this.editors();

      return this.tabs().map(function(i, tab) {
        return new File($(tab), $(editors[i]));
      });
    },

    tabs: function() {
      return this.tabsContainer.children();
    },

    editors: function() {
      return this.editorsContainer.find('.file-editor')
    },

    setUpAddFile: function() {
      this._addFileButton.click(function() {
        this._addFile();
      }.bind(this));
    },

    setUpDeleteFiles: function() {
      this.files().each(function(i, file) {
        this.setUpDeleteFile(file);
      }.bind(this));
    },

    setUpDeleteFile: function(file) {
      file.setUpOnRemove(this._deleteFile.bind(this));
    },

    _addFile: function() {
      var name = prompt('Insert a file name'); // TODO: i18n, or improve somehow
      if (!name.length || !name.includes('.')) return;

      var id = 'editor-file-' + this._getFilesCount();
      this.tabsContainer.append(this._createTab(name, id));
      this.editors().parent().last().append(this._createEditor(name, id));
      var file = this.files().last().get(0).initialize(name);
      this.setUpDeleteFile(file);

      this._updateButtonsVisibility();
    },

    _deleteFile: function(file) {
      var index  = this.files().toArray()
        .map(function(file) { return file.getName(); })
        .indexOf(file.getName());
      var previousIndex = Math.max(index - 1, 0);

      var wasSelected = file.remove();
      if (wasSelected) this.files()[previousIndex].select();

      this._updateButtonsVisibility();
    },

    _updateButtonsVisibility: function() {
      var filesCount = this._getFilesCount();
      var deleteButtons = this.tabs().find(File.DELETE_BUTTON_CLASS);

      this._setVisibility(this._addFileButton, filesCount < this.MAX_TABS);
      this._setVisibility(deleteButtons, filesCount > 1);
    },

    _createTab: function(name, id) {
      var tab = this.tabs().last().clone();
      tab.attr('data-target', '#' + id);

      return tab;
    },

    _createEditor: function(name, id) {
      var editor = this.editors().last().clone();
      editor.attr('id', id);
      editor.find('.CodeMirror').remove();

      var textarea = editor.children().first();
      this._setUpTextArea(textarea, 'solution_content[' + name + ']', 'solution[content[' + name + ']]');

      var highlightMode = this._getHighlightModeFor(name);
      var codeMirrorEditor = new mumuki.editor.CodeMirrorBuilder(textarea.get(0))
        .setupEditor()
        .setupMinLines(textarea.data('lines'))
        .setupLanguage(highlightMode)
        .build();

      codeMirrorEditor.on("change", function(event) {
        textarea.val(event.getValue());
      });

      var solutionTextArea = $('.new_solution').find('textarea').last();
      this._setUpTextArea(solutionTextArea, '', '');

      return editor;
    },

    _getFilesCount: function() {
      return this.files().length;
    },

    _setUpTextArea: function(textarea, id, name) {
      textarea.attr('id', id);
      textarea.attr('name', name);
      textarea.text('');
      textarea.val('');
    },

    _getHighlightModeFor: function(name) {
      var highlightModes = JSON.parse($('#highlight-modes').val());
      var extension = name.split('.').pop();
      var language = highlightModes.find(function(it) {
        return it.extension === extension;
      });

      return language && language.highlight_mode || extension;
    },

    _setVisibility: function(element, isVisible) {
      if (isVisible) element.show(); else element.hide();
    }
  };

  var setUpTabsBehavior = function() {
    var tabsContainer = $('.nav-tabs');
    if (!tabsContainer.length) return;
    var editorsContainer = $('.tab-content');

    var controls = new MultipleFileEditor(tabsContainer, editorsContainer);

    controls.setUpAddFile();
    controls.setUpDeleteFiles();
  };

  $(document).ready(setUpTabsBehavior);
});
