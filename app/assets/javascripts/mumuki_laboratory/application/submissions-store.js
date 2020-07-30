(() => {
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
      const submission = window.localStorage.getItem(this._keyFor(exerciseId));
      if (!submission) return null;
      return JSON.parse(submission);
    }

    /**
     * @param {number} exerciseId
     * @param {SubmissionAndResult} submission
     */
    setLastSubmission(exerciseId, submission) {
      window.localStorage.setItem(this._keyFor(exerciseId), this._asString(submission));
    }

    getCachedResultFor(exerciseId, newSolution) {
      const lastSubmission = this.getLastSubmission(exerciseId);
      if (!lastSubmission
          || lastSubmission.result.status === 'aborted'
          || !this._solutionEquals(lastSubmission, newSolution)) {
        return null;
      }
      return lastSubmission.result;
    }

    // private API

    _asString(object) {
      return JSON.stringify(object);
    }

    _keyFor(exerciseId) {
      return `/exercise/${exerciseId}/submission`;
    }

    _solutionEquals(submission, solution) {
      return this._asString(submission.content) === this._asString(solution);
    }
  };
  mumuki.SubmissionsStore = SubmissionsStore;
})();
