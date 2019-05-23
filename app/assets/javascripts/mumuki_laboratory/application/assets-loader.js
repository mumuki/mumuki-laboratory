mumuki.assetsLoader = {
  layout: {
    onStartLoading: function () {

    },
    onFinishLoading: function () {

    }
  },
  editor: {
    onStartLoading: function () {
      mumuki.kids.disableContextModalButton();
    },
    onFinishLoading: function () {
      mumuki.kids.enableContextModalButton();
    }
  }
};
