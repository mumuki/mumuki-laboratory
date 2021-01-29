describe('csrf token', () => {
  it('can create token', () => {
    expect(new mumuki.CsrfToken()).not.toBe(null);
  });
});


