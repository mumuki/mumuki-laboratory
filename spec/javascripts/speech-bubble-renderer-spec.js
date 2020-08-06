describe('results renderers', () => {
  it('can render result item', () => {
    expect(mumuki.renderers.renderSpeechBubbleResultItem('fix that')).toEqual(`
        <div class="results-item">
          <ul class="results-list">
            <li>fix that</li>
          </ul>
        </div>`);
  })

})
