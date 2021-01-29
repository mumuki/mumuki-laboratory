describe('sync mode', () => {
  it('can choose server mode', () => {
    mumuki.incognitoUser = false;
    mumuki.syncMode._selectSyncMode();

    expect(mumuki.syncMode._current instanceof mumuki.syncMode.ServerSyncMode).toBe(true);
  });

  it('can choose local mode', () => {
    mumuki.incognitoUser = true;
    mumuki.syncMode._selectSyncMode();

    expect(mumuki.syncMode._current instanceof mumuki.syncMode.ClientSyncMode).toBe(true);
  });
});
