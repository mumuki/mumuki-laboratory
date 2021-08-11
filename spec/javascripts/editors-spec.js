describe('editors', () => {
  beforeEach(() => {
    mumuki.CustomEditor.clearSources();
  });

  it('has initially no sources', () => {
    expect(mumuki.CustomEditor.hasSources).toBe(false);
  });

  it('can add a custom source', () => {
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
      <div class="editor-code">
        <textarea class="form-control editor" name="solution[content]" id="solution_content">the standard solution</textarea>
      </div>
    </form>`);

    mumuki.editors.addCustomSource({
      getContent() {
        return { name: "solution[content]", value: 'the custom solution' } ;
      }
    });

    expect(mumuki.editors.getSubmission()).toEqual({"_pristine": true, "solution[content]":"the custom solution"});
  });

  it('reads the form if no sources', () => {
    $('body').html(`
    <form role="form" class="new_solution">
      <div class="editor-code">
        <textarea class="form-control editor" name="solution[content]" id="solution_content">the solution</textarea>
      </div>
    </form>`);
    expect(mumuki.editors.getSubmission()).toEqual({"_pristine": true, "solution[content]":"the solution"});
  });

  it('reads the form when it is not the first submission', () => {
    $('body').html(`
    <form role="form" class="new_solution">
      <div class="editor-code">
        <textarea class="form-control editor" name="solution[content]" id="solution_content">the solution</textarea>
      </div>
    </form>
    <div class=" submission-results">
      <div class="bs-callout bs-callout-success">
        <h4 class="text-success">
          <strong><i class="fas fa-check-circle"></i> ¡Muy bien!</strong>
        </h4>
      </div>
    </div>`);
    expect(mumuki.editors.getSubmission()).toEqual({"_pristine": false, "solution[content]":"the solution"});
  });

  it('reads the form if no sources and exercise is multifile', () => {
    $('body').html(`
    <form role="form" class="new_solution">
      <div class="editor-code">
        <textarea
          class="form-control editor"
          data-editor-language="html"
          name="solution[content[index.html]]"
          id="solution_content[index.html]">some html</textarea>
        <textarea
          class="form-control editor"
          data-editor-language="css"
          name="solution[content[receta.css]]"
          id="solution_content[receta.css]">some css</textarea>
      </div>
    </form>`);
    expect(mumuki.editors.getSubmission()).toEqual({
      "_pristine": true,
      "solution[content[index.html]]": "some html",
      "solution[content[receta.css]]": "some css"
    });
  });

  it('produces empty submission if no form nor sources', () => {
    $('body').html(``);
    expect(mumuki.editors.getSubmission()).toEqual({_pristine: true});
  });
});
