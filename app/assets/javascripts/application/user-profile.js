mumuki.load(function () {
  const field = $('.mu-avatar-field');
  const image = $('.mu-avatar-image');
  const overlay = $('.mu-avatar-overlay');

  image.hover(() => overlay.show(), () => overlay.hide());

  image.click(() => {
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
