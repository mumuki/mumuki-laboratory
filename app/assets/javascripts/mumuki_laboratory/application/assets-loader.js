var assetsLoader = {
  layout: {
    onLoadingStarted: function () {

    },
    onLoadingFinished: function () {

    }
  },
  editor: {
    onLoadingStarted: function () {
      mumuki.kids.disableContextModalButton();
    },
    onLoadingFinished: function () {
      mumuki.kids.enableContextModalButton();
    }
  }
};

mumuki.assetsLoaderFor = function (kind) {
  assetsLoader[kind].onLoadingStarted();
};

mumuki.assetsLoadedFor = function (kind) {
  assetsLoader[kind].onLoadingFinished();
};
