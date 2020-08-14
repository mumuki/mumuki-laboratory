describe('exercise', () => {
  it('current exercise information is available when present', () => {
    $('body').html(`
    <input type="hidden" name="mu-exercise-id" id="mu-exercise-id" value="3361" />
    <input type="hidden" name="mu-exercise-layout" id="mu-exercise-layout" value="input_right" />`)

    mumuki.exercise.load()

    expect(mumuki.exercise.id).toBe(3361);
    expect(mumuki.exercise.layout).toBe('input_right');
  })

  it('current exercise information is available when not present', () => {
    $('body').html(``)

    mumuki.exercise.load()

    expect(mumuki.exercise.id).toBe(null);
    expect(mumuki.exercise.layout).toBe(null);
  })

})
