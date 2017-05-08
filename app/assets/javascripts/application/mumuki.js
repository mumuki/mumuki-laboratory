window.mumukiLoad = function (callback) {
    $(document).on('page:load', callback);
    $(document).ready(callback);
};
