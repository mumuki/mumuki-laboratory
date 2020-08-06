describe('editors', () => {

  beforeEach(() => {
    mumuki.CustomEditor.clearSources()
  })

  it('has initially no sources', () => {
    expect(mumuki.CustomEditor.hasSources).toBe(false)
  });

  it('can add a custom soure', () => {
    mumuki.editors.addCustomSource({
      getContent() {
        return { name: "solution[content]", value: 'the value' } ;
      }
    });

    expect(mumuki.CustomEditor.hasSources).toBe(true);
    expect(mumuki.CustomEditor.getContents()[0].value).toEqual('the value');
    expect(mumuki.CustomEditor.getContents()[0].name).toEqual('solution[content]');
  });

  it('reads the custom sources if present, ignoring the form', () => {
    $('body').html(`
    <form role="form" class="new_solution">
      <div class="field form-group editor-code">
        <textarea class="form-control editor" name="solution[content]" id="solution_content">the standard solution</textarea>
      </div>
    </form>`)

    mumuki.editors.addCustomSource({
      getContent() {
        return { name: "solution[content]", value: 'the custom solution' } ;
      }
    });

    expect(mumuki.editors.getSubmission()).toEqual({"solution[content]":"the custom solution"});
  });

  it('reads the form if no sources', () => {
    $('body').html(`
    <form role="form" class="new_solution">
      <div class="field form-group editor-code">
        <textarea class="form-control editor" name="solution[content]" id="solution_content">the solution</textarea>
      </div>
    </form>`)
    expect(mumuki.editors.getSubmission()).toEqual({"solution[content]":"the solution"});
  });

  it('produces empty submission if no form nor sources', () => {
    $('body').html(``);
    expect(mumuki.editors.getSubmission()).toEqual({});
  });
})
