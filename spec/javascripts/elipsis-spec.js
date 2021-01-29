describe('elipsis', () => {
  it('does nothing when no elipsis', () => {
    expect(mumuki.elipsis('hello')).toEqual('hello');
  });

  it('replaces student elipsis', () => {
    expect(mumuki.elipsis(`function longitud(unString) {
      /*&lt;elipsis-for-student@*/
      return unString.length;
      /*@elipsis-for-student&gt;*/
    }`)).toEqual(`function longitud(unString) {
      /* ... */
    }`);
  });

  it('replaces student hidden', () => {
    expect(mumuki.elipsis(`function longitud(unString) {
      /*&lt;hidden-for-student@*/
      return unString.length;
      /*@hidden-for-student&gt;*/
    }`)).toEqual(`function longitud(unString) {
      /**/
    }`);
  });
});
