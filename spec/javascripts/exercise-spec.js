describe('exercise', () => {

  it('current exercise information is available when present', () => {
    $('body').html(`
    <input type="hidden" name="mu-exercise-id" id="mu-exercise-id" value="3361" />
    <input type="hidden" name="mu-exercise-layout" id="mu-exercise-layout" value="input_right" />
    <input type="hidden" name="mu-exercise-settings" id="mu-exercise-settings" value="{}" />`)

    mumuki.exercise.load();

    expect(mumuki.exercise.id).toBe(3361);
    expect(mumuki.exercise.layout).toBe('input_right');
    expect(mumuki.exercise.settings).toEqual({});
    expect(mumuki.exercise.current).not.toBe(null);
  })

  it('current exercise information is available when present and settings are not empty', () => {
    $('body').html(`
    <input type="hidden" name="mu-exercise-id" id="mu-exercise-id" value="3361" />
    <input type="hidden" name="mu-exercise-layout" id="mu-exercise-layout" value="input_right" />
    <input type="hidden" name="mu-exercise-settings" id="mu-exercise-settings" value="{\\\\"game_mode\\\\": true}" />`)

    mumuki.exercise.load();

    expect(mumuki.exercise.id).toBe(3361);
    expect(mumuki.exercise.layout).toBe('input_right');
    expect(mumuki.exercise.settings).toEqual({game_mode: true});
    expect(mumuki.exercise.current).not.toBe(null);
  })

  it('current exercise information is available when not present', () => {
    $('body').html(``)

    mumuki.exercise.load();

    expect(mumuki.exercise.id).toBe(null);
    expect(mumuki.exercise.layout).toBe(null);
    expect(mumuki.exercise.settings).toBe(null);
    expect(mumuki.exercise.current).toBe(null);
  })
})
