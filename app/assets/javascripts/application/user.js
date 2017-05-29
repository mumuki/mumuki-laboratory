var mumuki = mumuki || {};

(function (mumuki) {
    function handleTabSelection() {
        var hash = document.location.hash;
        if (hash) {
            $(".nav-tabs a[data-target='" + hash + "']").tab('show');
        }
        $('a[data-toggle="tab"]').on('show.bs.tab', function (e) {
            window.location.hash = $(e.target).attr('data-target');
        });
    }

    mumuki.load(handleTabSelection);
})(mumuki);
