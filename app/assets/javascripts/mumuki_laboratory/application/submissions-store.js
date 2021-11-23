mumuki.SubmissionsStore = (()=> {
  class AllLocalSubmissions {
    /**
     * @param {string} key
     * @returns {SubmissionAndResult}
     */
     read(key) {
      const submissionAndResult = window.localStorage.getItem(key);
      if (!submissionAndResult) return null;
      return JSON.parse(submissionAndResult);
    }

    /**
     * @param {string} key
     * @param {SubmissionAndResult} submissionAndResult
     */
    write(key, submissionAndResult) {
      window.localStorage.setItem(key, this._asString(submissionAndResult));
    }

    clear() {
      window.localStorage.clear();
    }

    /**
     * Serializes the submission and result.
     * Private attributes are ignored
     */
    _asString(submissionAndResult) {
      return JSON.stringify(submissionAndResult, (key, value) => {
        if (!key.startsWith("_")) return value
      });
    }
  }

  class OnlyLastSubmission {
    constructor() {
      this.lastSubmissionKey = null;
      this.lastSubmissionAndResult = null;
    }

    /**
     * @param {string} key
     * @returns {SubmissionAndResult}
     */
     read(key) {
      return key === this.lastSubmissionKey ? this.lastSubmissionAndResult : null;
    }

    /**
     * @param {string} key
     * @param {SubmissionAndResult} submissionAndResult
     */
    write(key, submissionAndResult) {
      this.lastSubmissionKey = key;
      this.lastSubmissionAndResult = submissionAndResult;
    }

    clear() {
      this.lastSubmissionKey = null;
      this.lastSubmissionAndResult = null;
    }
  }

  const SubmissionsStore = new class {
    constructor() {
      this.backends = {
        AllLocalSubmissions: new AllLocalSubmissions(),
        OnlyLastSubmission: new OnlyLastSubmission()
      };
      /** @type {AllLocalSubmissions | OnlyLastSubmission} */
      this.backend = this.backends.AllLocalSubmissions;
    }

    /**
     * Returns the submission's result status for the last submission to
     * the given exercise, or pending, if not present
     *
     * @param {number} exerciseId
     * @returns {SubmissionStatus}
     */
    getLastSubmissionStatus(exerciseId) {
      const submission = this.getLastSubmissionAndResult(exerciseId);
      return submission ? submission.result.status : 'pending';
    }

    /**
     * Returns the submission and result for the last submission to
     * the given exercise
     *
     * @param {number} exerciseId
     * @returns {SubmissionAndResult}
     */
    getLastSubmissionAndResult(exerciseId) {
      return this.backend.read(this._keyFor(exerciseId));
    }

    /**
     * Saves the result for the given exercise
     *
     * @param {number} exerciseId
     * @param {SubmissionAndResult} submissionAndResult
     */
    setSubmissionResultFor(exerciseId, submissionAndResult) {
      this.backend.write(this._keyFor(exerciseId), submissionAndResult);
    }

    /**
     * Retrieves the last cached, non-aborted result for the given submission of the given exercise
     *
     * @param {number} exerciseId
     * @param {Submission} submission
     * @returns {SubmissionResult} the cached result for this submission
     */
    getSubmissionResultFor(exerciseId, submission) {
      const last = this.getLastSubmissionAndResult(exerciseId);
      if (!last
          || last.result.status === 'aborted'
          || !this.submissionSolutionEquals(last.submission, submission)) {
        return null;
      }
      return last.result;
    }

     /**
     * Extract the submission's solution content, expressed as a string
     *
     * @param {Submission} submission
     * @returns {string}
     */
    submissionSolutionContent(submission) {
      if (submission.solution) {
        return submission.solution.content;
      } else if (submission['solution[content]'] !== undefined) {
        return submission['solution[content]'];
      } else {
        return JSON.stringify(
          Object
            .entries(submission)
            .filter(([key, _]) => key.startsWith('solution[content[')));
      }
    }

    /**
     * Compares two solutions to determine if they are equivalent
     * from the point of view of the code evaluation
     *
     * @param {Submission} one
     * @param {Submission} other
     * @returns {boolean}
     */
    submissionSolutionEquals(one, other) {
      return this.submissionSolutionContent(one) === this.submissionSolutionContent(other);
    }

    clear() {
      this.backend.clear();
    }

    // private API

    _keyFor(exerciseId) {
      return `/organization/${mumuki.organization.id}/user/${mumuki.user.id}/exercise/${exerciseId}/submission`;
    }
  }();
  return SubmissionsStore;
})();

mumuki.load(() => {
  $('.mu-restart-guide').on("confirm:complete", (e) => {
    if (e.detail[0]) {
      mumuki.SubmissionsStore.clear();
    }
  });
});
