mumuki.load(function () {

  function FileControls(tabs, editors) {
    this.tabs = tabs;
    this.editors = editors;

    this._addFileButton = this.tabs.find('.add-file-button');
    this._deleteFileButtons = this.tabs.find('.delete-file-button');
  }

  FileControls.prototype = {
    setUpAddFile: function() {
      this._addFileButton.click(function() {
        this._addFile();
      }.bind(this));
    },

    setUpDeleteFile: function() {
      var self = this;

      this._deleteFileButtons.each(function(i, element) {
        $(element).click(function() {
          self._deleteFile(self._getFileName($(this).parent()));
        });
      });
    },

    _addFile: function() {
      alert("Adding file");
    },

    _deleteFile: function(name) {
      alert("Deleting file " + name)
    },

    _getFileName: function(tab) {
      return tab.find(".file-name").text()
    }
  };

	var setUpTabsBehavior = function(event) {
	  var tabs = $('.files-tabs');
	  if (!tabs.length) return;
	  var editors = $('.tab-content');

	  var controls = new FileControls(tabs, editors);

	  controls.setUpAddFile();
	  controls.setUpDeleteFile();
	};
	$(document).ready(setUpTabsBehavior);
});
