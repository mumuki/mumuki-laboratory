describe('KidsButton', () => {

  let button;

  fixture.set(`
      <div class="mu-kindergarten">
          <button class="mu-kids-button">Click me<button>
          <div class="mu-kids-overlay" style="display: none"></div>
      </div>
  `);

  beforeEach(() => {
    mumuki.kids = new mumuki.Kids();
    button = new mumuki.submission.KidsSubmitButton($('.mu-kids-button'));
  })

  it('can create button', () => {
    expect(button).not.toBe(null);
  })

  it('overlay is hidden by default', () => {
    expect(mumuki.kids.$overlay.css('display')).toBe('none');
  })

  it('call showOverlay on wait', () => {
    button.wait();
    expect(mumuki.kids.$overlay.css('display')).toBe('block');
  })

  it('call hideOverlay on continue', () => {
    button.wait();
    button.continue();
    expect(mumuki.kids.$overlay.css('display')).toBe('none');
  })

})
