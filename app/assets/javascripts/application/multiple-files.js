mumuki.load(function () {

  function FileControls(tabsContainer, editorsContainer) {
    this.tabsContainer = tabsContainer;
    this.editorsContainer = editorsContainer;

    this.MAX_TABS = 5;
    this.DELETE_FILE = '.delete-file-button';
    this.FILE_NAME = '.file-name';

    this._addFileButton = this.tabsContainer.siblings('.add-file-button');
  }

  FileControls.prototype = {
    tabs: function() { return this.tabsContainer.children(); },
    editors: function() { return this.editorsContainer.find('.file-editor'); },

    setUpAddFile: function() {
      this._addFileButton.click(function() {
        this._addFile();
      }.bind(this));
    },

    setUpDeleteFiles: function() {
      this.tabs().each(function(i, element) {
        this.setUpDeleteFile($(element));
      }.bind(this));
    },

    setUpDeleteFile: function(tab) {
      tab.find(this.DELETE_FILE).click(function() {
        this._deleteFile(this._getFileName(tab));
      }.bind(this));
    },

    _addFile: function() {
      var name = prompt('Insert a file name'); // TODO: i18n, or improve somehow
      if (!name.length || !name.includes('.')) return;

      const id = 'editor-file-' + this._getFilesCount();
      this.tabsContainer.append(this._createTab(name, id));
      this.editorsContainer.append(this._createEditor(name, id));
      this.editors().last().remove();

      this._updateButtonsVisibility();
    },

    _deleteFile: function(name) {
      var tab = this.tabs().find(this.FILE_NAME + ":contains('" + name + "')").parent();
      if (!tab.length) return;

      $(tab.attr('data-target')).remove();
      tab.remove();

      this._updateButtonsVisibility();
    },

    _updateButtonsVisibility: function() {
      var filesCount = this._getFilesCount();
      var deleteButtons = this.tabs().find(this.DELETE_FILE);

      this._setVisibility(this._addFileButton, filesCount < this.MAX_TABS);
      this._setVisibility(deleteButtons, filesCount > 1);
    },

    _createTab: function(name, id) {
      var tab = this.tabs().last().clone();
      this._setFileName(tab, name);
      tab.attr('data-target', '#' + id);
      tab.removeClass('active');
      this.setUpDeleteFile(tab);

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

      // TODO: A veces no serializa el content nuevo
      // TODO: Detectar content type según extensión
      
      new mumuki.editor.CodeMirrorBuilder(textarea[0])
        .setup(textarea.data('lines'));

      return editor;
    },

    _getFilesCount: function() {
      return this.editors().length;
    },

    _setFileName: function(tab, name) {
      return tab.find(this.FILE_NAME).text(name);
    },

    _getFileName: function(tab) {
      return tab.find(this.FILE_NAME).text();
    },

    _setVisibility: function(element, isVisible) {
      if (isVisible) element.show(); else element.hide();
    }
  };

	var setUpTabsBehavior = function(event) {
	  var tabsContainer = $('.nav-tabs');
	  if (!tabsContainer.length) return;
	  var editorsContainer = $('.tab-content');

	  var controls = new FileControls(tabsContainer, editorsContainer);

	  controls.setUpAddFile();
	  controls.setUpDeleteFiles();
	};
	$(document).ready(setUpTabsBehavior);
});
