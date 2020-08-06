describe('sync mode', () => {
  it('can choose server mode', () => {
    mumuki.incognitoMode = false;
    mumuki.syncMode._selectSyncMode();

    expect(mumuki.syncMode._current instanceof mumuki.syncMode.ServerSyncMode).toBe(true);
  })

  it('can choose local mode', () => {
    mumuki.incognitoMode = true;
    mumuki.syncMode._selectSyncMode();

    expect(mumuki.syncMode._current instanceof mumuki.syncMode.ClientSyncMode).toBe(true);
  })
})
