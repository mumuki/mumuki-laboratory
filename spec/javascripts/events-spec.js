describe('events', () => {
  beforeEach(() => {
    mumuki.events.clear('foo');
  });

  it('is not called when it is not fired', () => {
    mumuki.events.on('foo', (e) => {
      fail(`should not be called, but got ${JSON.stringify(e)}`);
    })
  })

  it('is not called when it is fired but not enabled', () => {
    let fired = false;
    mumuki.events.on('foo', (e) => {
      fail(`should not be called, but got ${JSON.stringify(e)}`);
      fired = true;
    })
    mumuki.events.fire('foo', 42);
    expect(fired).toBe(false);
  })

  it('is called when it is fired and enabled', () => {
    let fired = false;
    mumuki.events.enable('foo');
    mumuki.events.on('foo', (event) => {
      expect(event).toEqual(42);
      fired = true;
    })

    mumuki.events.fire('foo', 42);
    expect(fired).toBe(true);
  })
})
