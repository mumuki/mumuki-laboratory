mumuki.load(() => {
  function appendElementValue(values, element) {
    values[element.attr('name')] = element.val();
  }

	function setSolution(evt) {
    let  values = {};

    $('.mu-free-form-input').each(function () {
      appendElementValue(values, $(this));
    });

		$('#solution_content').attr('value', JSON.stringify(values));
  };

	$(document).ready(setSolution);
  $('.mu-free-form-input').change(setSolution);
});
