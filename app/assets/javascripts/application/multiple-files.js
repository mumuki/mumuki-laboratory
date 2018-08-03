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
      const wasSelected = this.isSelected();

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

  function FileControls(tabsContainer, editorsContainer) {
    this.tabsContainer = tabsContainer;
    this.editorsContainer = editorsContainer;

    this.MAX_TABS = 5;

    this._addFileButton = this.tabsContainer.siblings('.add-file-button');
    this._updateButtonsVisibility();
  }

  FileControls.prototype = {
    files: function() {
      const editors = this.editors();

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

      const id = 'editor-file-' + this._getFilesCount();
      this.tabsContainer.append(this._createTab(name, id));
      this.editors().parent().last().append(this._createEditor(name, id));
      const file = this.files().last().get(0).initialize(name);
      this.setUpDeleteFile(file);

      this._updateButtonsVisibility();
    },

    _deleteFile: function(file) {
      const index  = this.files().toArray()
        .map(function(file) { return file.getName(); })
        .indexOf(file.getName());
      const previousIndex = Math.max(index - 1, 0);

      const wasSelected = file.remove();
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
      textarea.attr('id', 'solution_content[' + name + ']');
      textarea.attr('name', 'solution[content[' + name + ']]');
      textarea.text('');

      // TODO: No serializa el content nuevo al agregar tabs y enviar solución
      // TODO: Detectar content type según extensión

      new mumuki.editor.CodeMirrorBuilder(textarea.get(0)).setup(textarea.data('lines'));

      return editor;
    },

    _getFilesCount: function() {
      return this.files().length;
    },

    _setVisibility: function(element, isVisible) {
      if (isVisible) element.show(); else element.hide();
    }
  };

  var setUpTabsBehavior = function() {
    var tabsContainer = $('.nav-tabs');
    if (!tabsContainer.length) return;
    var editorsContainer = $('.tab-content');

    var controls = new FileControls(tabsContainer, editorsContainer);

    controls.setUpAddFile();
    controls.setUpDeleteFiles();
  };

  $(document).ready(setUpTabsBehavior);
});
