function loadChoicesSolution() {
    $('.solution-choice').change(function (evt) {
        var indexes = $('.solution-choice:checked').map(function () {
            return $(this).data('index')
        }).get().join(':');
        $('#solution_content').attr('value', indexes);
    });
}
mumukiLoad(loadChoicesSolution);
