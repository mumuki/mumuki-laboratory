mumuki.SubmissionsStore = (() => {
  const SubmissionsStore = new class {
    /**
     * @param {number} exerciseId
     * @returns {SubmissionStatus}
     */
    getLastSubmissionStatus(exerciseId) {
      const submission = this.getLastSubmission(exerciseId);
      return submission ? submission.result.status : 'pending';
    }

    /**
     * @param {number} exerciseId
     * @returns {SubmissionAndResult}
     */
    getLastSubmission(exerciseId) {
      const submissionAndResult = window.localStorage.getItem(this._keyFor(exerciseId));
      if (!submissionAndResult) return null;
      return JSON.parse(submissionAndResult);
    }

    /**
     * @param {number} exerciseId
     * @param {SubmissionAndResult} submissionAndResult
     */
    setLastSubmission(exerciseId, submissionAndResult) {
      window.localStorage.setItem(this._keyFor(exerciseId), this._asString(submissionAndResult));
    }

    /**
     * Retrieves the last cached, non-aborted result for the given submission
     *
     * @param {number} exerciseId
     * @param {Submission} submission
     * @returns {SubmissionResult} the cached result for this submission
     */
    getCachedResultFor(exerciseId, submission) {
      const lastSubmission = this.getLastSubmission(exerciseId);
      if (!lastSubmission
          || lastSubmission.result.status === 'aborted'
          || !this.submissionSolutionEquals(lastSubmission.submission, submission)) {
        return null;
      }
      return lastSubmission.result;
    }

     /**
     * Extract the submission's solution content
     *
     * @param {Submission} submission
     * @returns {string}
     */
    submissionSolutionContent(submission) {
      if (submission.solution) {
        return submission.solution.content;
      } else {
        return submission['solution[content]'];
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

    // private API

    _asString(object) {
      return JSON.stringify(object);
    }

    _keyFor(exerciseId) {
      return `/exercise/${exerciseId}/submission`;
    }
  };

  return SubmissionsStore;
})();
