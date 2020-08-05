mumuki.renderers = mumuki.renderers || {};
mumuki.renderers.results = (() => {


  // ==========================
  // View function for building
  // the results UI
  // ==========================

  /**
   * @param {SubmissionStatus} status
   * @returns {string}
   */
  function iconForStatus(status) {
    switch (status) {
      case "errored":              return "fa-minus-circle";
      case "failed":               return "fa-times-circle";
      case "passed_with_warnings": return "fa-exclamation-circle";
      case "passed":               return "fa-check-circle";
      case "pending":              return "fa-circle";
    }
  }

  /**
   * @param {SubmissionStatus} status
   * @returns {string}
   */
  function classForStatus(status) {
    switch (status) {
      case "errored":              return "broken";
      case "failed":               return "danger";
      case "passed_with_warnings": return "warning";
      case "passed":               return "success";
      case "pending":              return "muted";
    }
  };


  /**
   * @param {SubmissionStatus} status
   * @param {boolean} [active]
   * @returns {string}
   */
  function progressListItemClassForStatus(status, active = false) {
    return `progress-list-item text-center ${classForStatus(status)} ${active ? 'active' : ''}`;
  };

  return {
    classForStatus,
    iconForStatus,
    progressListItemClassForStatus
  }
})();

/** @deprecated use {@code mumuki.renderers.results.classForStatus} instead */
mumuki.renderers.classForStatus = mumuki.renderers.results.classForStatus;
/** @deprecated use {@code mumuki.renderers.results.iconForStatus} instead */
mumuki.renderers.iconForStatus = mumuki.renderers.results.iconForStatus;
/** @deprecated use {@code mumuki.renderers.results.progressListItemClassForStatus} instead */
mumuki.renderers.progressListItemClassForStatus = mumuki.renderers.results.progressListItemClassForStatus;
