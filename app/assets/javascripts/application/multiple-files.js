mumuki.load(function () {

  function FileControls(tabsContainer, editorsContainer) {
    this.tabsContainer = tabsContainer;
    this.editorsContainer = editorsContainer;

    this.tabs = tabsContainer.children();
    this.editors = editorsContainer.find('.file-editor');

    this.MAX_TABS = 3; // TODO: Fix the view so it doesn't break the UI with more than 3 tabs

    this._addFileButton = this.tabsContainer.siblings('.add-file-button');
  }

  FileControls.prototype = {
    setUpAddFile: function() {
      this._addFileButton.click(function() {
        this._addFile();
      }.bind(this));
    },

    setUpDeleteFiles: function() {
      this.tabs.each(function(i, element) {
        this.setUpDeleteFile($(element));
      }.bind(this));
    },

    setUpDeleteFile: function(tab) {
      tab.find('.delete-file-button').click(function() {
        this._deleteFile(this._getFileName(tab));
      }.bind(this));
    },

    _addFile: function() {
      var name = prompt('Insert a file name'); // TODO: i18n, or improve somehow
      if (!name.length || !name.includes('.')) return;

      this.tabsContainer.append(this._createTab(name));
      this.editorsContainer.append(this._createEditor(name));

      this._updateButtonsVisibility();
    },

    _deleteFile: function(name) {
      var tab = this.tabs.find(".file-name:contains('" + name + "')").parent();
      if (!tab.length) return;

      $(tab.attr('data-target')).remove();
      tab.remove();
    },

    _updateButtonsVisibility: function() {
      if (this._getFilesCount() < this.MAX_FILES) this._addFileButton.show();
      else this._addFileButton.hide();
    },

    _createTab: function(name) {
      var index = this._getFilesCount() + 1;
      var tab = this.tabs.last().clone();
      this._setFileName(tab, name);
      tab.attr('data-target', '#editor-file-' + index);
      tab.removeClass('active');
      this.setUpDeleteFile(tab);

      return tab;
    },

    _createEditor: function(name) {
      var editor = this.editors.last().clone();
      editor.find('.CodeMirror').remove();

      var textarea = editor.children().first();
      textarea.attr('id', 'solution_content[' + name + ']');
      textarea.text('');
      // TODO: Setupear CodeMirror

      return editor;
    },

    _getFilesCount: function() {
      return this.editors.length;
    },

    _setFileName: function(tab, name) {
      return tab.find(".file-name").text(name);
    },

    _getFileName: function(tab) {
      return tab.find(".file-name").text();
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
