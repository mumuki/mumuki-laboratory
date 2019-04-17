mumuki.load(function () {
  const button = $('.mu-avatar-button');
  const field = $('.mu-avatar-field');
  const image = $('.mu-avatar-image');

  button.click(() => {
    field.trigger('click');
  });

  field.change(function() {
    const input = this;

    if (input.files && input.files[0]) {
      const reader = new FileReader();

      reader.onload = function(e) {
        image.attr('src', e.target.result);
      }

      reader.readAsDataURL(input.files[0]);
    }
  });
});
