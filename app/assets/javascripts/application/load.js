var mumuki = mumuki || {};

(function (mumuki) {
    mumuki.load = function (callback) {
        $(document).on('page:load', callback);
        $(document).ready(callback);
    };
})(mumuki);
