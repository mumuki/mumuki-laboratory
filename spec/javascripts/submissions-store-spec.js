describe("SubmissionsStore", () => {
  const emptyProgramSubmission = {"solution[content]": "program {}"};
  /** @type {SubmissionResult} */
  const passedSubmissionResult = {status: 'passed'};
  /** @type {SubmissionAndResult} */
  const passedEmptyProgramSubmissionAndResult = { submission: emptyProgramSubmission, result: passedSubmissionResult };

  beforeEach(() => {
    window.localStorage.clear()
  });

  describe('getLastSubmission', () => {
    it("answers null if submission not present", () => {
      expect(mumuki.SubmissionsStore.getLastSubmissionAndResult(1)).toBe(null)
    })

    it("answers the last submission result if already sent", () => {
      mumuki.SubmissionsStore.setSubmissionResultFor(1, passedEmptyProgramSubmissionAndResult)
      expect(mumuki.SubmissionsStore.getLastSubmissionAndResult(1)).toEqual(passedEmptyProgramSubmissionAndResult)
    })
  })

  describe('getLastSubmissionStatus', () => {
    it("answers pending if submission not present", () => {
      expect(mumuki.SubmissionsStore.getLastSubmissionStatus(1)).toBe('pending')
    })

    it("answers the last submission status if previously sent", () => {
      mumuki.SubmissionsStore.setSubmissionResultFor(1, passedEmptyProgramSubmissionAndResult)
      expect(mumuki.SubmissionsStore.getLastSubmissionStatus(1)).toBe('passed')
    })
  });

  describe('getCachedResultFor', () => {
    it("answers null if submission not present", () => {
      expect(mumuki.SubmissionsStore.getSubmissionResultFor(1, emptyProgramSubmission)).toBe(null)
    })

    it("answers the last submission if previously sent", () => {
      mumuki.SubmissionsStore.setSubmissionResultFor(1, passedEmptyProgramSubmissionAndResult)
      expect(mumuki.SubmissionsStore.getSubmissionResultFor(1, emptyProgramSubmission)).toEqual(passedSubmissionResult)
    })
  });
})
