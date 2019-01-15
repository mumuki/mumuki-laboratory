var mumuki = mumuki || {};

(function (mumuki) {

  var CustomEditor = {
    sources: [],

    addSource: function (source) {
      CustomEditor.sources.push(source);
    },

    // Each external source must implement getContent method

    getContent: function () {
      return CustomEditor.sources.map( e => e.getContent() );
    }
  };

  mumuki.CustomEditor = CustomEditor;

}(mumuki));
