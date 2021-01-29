describe('results renderers', () => {
  it('can compute class for status', () => {
    expect(mumuki.renderers.classForStatus('passed')).toEqual('success');
  });

  it('can compute icon for status', () => {
    expect(mumuki.renderers.iconForStatus('pending')).toEqual('fa-circle');
  });

  it('can compute progress list item for status', () => {
    expect(mumuki.renderers.progressListItemClassForStatus('passed_with_warnings')).toEqual('progress-list-item text-center warning ');
  });

  it('can compute progress list item for status when active', () => {
    expect(mumuki.renderers.progressListItemClassForStatus('failed', true)).toEqual('progress-list-item text-center danger active');
  });
});
