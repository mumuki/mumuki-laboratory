 mumuki.organization = {

  /**
   * The current organization's id
   *
   * @type {number?}
   * */
  _id: null,

  /**
   * The current organization's id
   *
   * @type {number?}
   * */
  get id() {
    return this._id;
  },

  /**
   * Set global current organization information
   */
  load() {
    const $muOrganizationId = $('#mu-organization-id');
    if ($muOrganizationId.length) {
      this._id = $muOrganizationId.val();
    } else {
      this._id = null;
    }
  }
};

mumuki.load(() => mumuki.organization.load());
