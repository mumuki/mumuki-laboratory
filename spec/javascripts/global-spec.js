describe("global loading", () => {
  it("produces no global loading errors", () => {
    const error = window['__globalLoadingError__'];
    expect(!error).toBe(true, `Expected no global loading errors but got ${error && error.message}`);
  });
});
