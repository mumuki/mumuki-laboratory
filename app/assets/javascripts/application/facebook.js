var bindFacebookEvents, initializeFacebookSDK, loadFacebookSDK, restoreFacebookRoot, saveFacebookRoot;

$(function () {
  loadFacebookSDK();
  if (!window.fbEventsBound) {
    return bindFacebookEvents();
  }
});

bindFacebookEvents = function () {
  $(document).on('page:fetch', saveFacebookRoot).on('page:change', restoreFacebookRoot).on('page:load', function () {
    return typeof FB !== "undefined" && FB !== null ? FB.XFBML.parse() : void 0;
  });
  return this.fbEventsBound = true;
};

saveFacebookRoot = function () {
  if ($('#fb-root').length) {
    return this.fbRoot = $('#fb-root').detach();
  }
};

restoreFacebookRoot = function () {
  if (this.fbRoot != null) {
    if ($('#fb-root').length) {
      return $('#fb-root').replaceWith(this.fbRoot);
    } else {
      return $('body').append(this.fbRoot);
    }
  }
};

loadFacebookSDK = function () {
  window.fbAsyncInit = initializeFacebookSDK;
  return $.getScript("//connect.facebook.net/" + window.mumukiLocale.facebook_code + "/sdk.js#xfbml=1&version=v2.5");
};

initializeFacebookSDK = function () {
  return FB.init({
    status: true,
    cookie: true,
    xfbml: true,
    version: 'v2.5'
  });
};
