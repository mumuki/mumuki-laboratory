mumuki.SubmissionsStore = (() => {
  const SubmissionsStore = new class {
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
      const submissionAndResult = window.localStorage.getItem(this._keyFor(exerciseId));
      if (!submissionAndResult) return null;
      return JSON.parse(submissionAndResult);
    }

    /**
     * Saves the result for the given exercise
     *
     * @param {number} exerciseId
     * @param {SubmissionAndResult} submissionAndResult
     */
    setSubmissionResultFor(exerciseId, submissionAndResult) {
      window.localStorage.setItem(this._keyFor(exerciseId), this._asString(submissionAndResult));
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
      window.localStorage.clear();
    }

    // private API

    /**
     * Serializes the submission and result.
     * Private attributes are ignored
     */
    _asString(submissionAndResult) {
      return JSON.stringify(submissionAndResult, (key, value) => {
        if (!key.startsWith("_")) return value
      });
    }

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
