mumuki.load(() => {
  function dumpInput(values, element) {
    values[element.attr('name')] = element.val();
  }

  function loadInput(values, element) {
    element.val(values[element.attr('name')]);
  }

	function dumpForm(_event) {
    let  values = {};
    $('.mu-free-form-input').each(function () {
      dumpInput(values, $(this));
    });
		$('#solution_content').attr('value', JSON.stringify(values));
  }

  function loadForm() {
    let json = $('#solution_content').val();
    if (!json) return;

    let values = JSON.parse(json);
    $('.mu-free-form-input').each(function () {
      loadInput(values, $(this));
    });
  }

  mumuki.onInputsReady('.mu-free-form-input', loadForm);
  $('.mu-free-form-input').change(dumpForm);
});
