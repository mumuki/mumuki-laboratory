mumuki.load(function () {
	var setSolution = function (evt) {
		var indexes = $('.solution-choice:checked').map(function () {
			return $(this).data('index')
		}).get().join(':');
		$('#solution_content').attr('value', indexes);
	};
	$(document).ready(setSolution);
  $('.solution-choice').change(setSolution);
});
