mumuki.load(() => {
	function dumpChoices(_evt) {
		var indexes = $('.solution-choice:checked').map(function () {
			return $(this).data('index');
		}).get().join(':');
		$('#solution_content').attr('value', indexes);
	}

	mumuki.onInputsReady('.solution-choice', dumpChoices);
  $('.solution-choice').change(dumpChoices);
});
