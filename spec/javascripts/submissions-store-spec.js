describe("SubmissionsStore", () => {
  const emptyProgramSubmission = {"solution[content]": "program {}"};
  /** @type {SubmissionResult} */
  const passedSubmissionResult = {status: 'passed'};
  /** @type {SubmissionAndResult} */
  const passedEmptyProgramSubmissionAndResult = { submission: emptyProgramSubmission, result: passedSubmissionResult };

  beforeEach(() => {
    window.localStorage.clear();
  });

  describe('getLastSubmission', () => {
    it("answers null if submission not present", () => {
      expect(mumuki.SubmissionsStore.getLastSubmissionAndResult(1)).toBe(null);
    });

    it("answers the last submission result if already sent", () => {
      mumuki.SubmissionsStore.setSubmissionResultFor(1, passedEmptyProgramSubmissionAndResult);
      expect(mumuki.SubmissionsStore.getLastSubmissionAndResult(1)).toEqual(passedEmptyProgramSubmissionAndResult);
    });
  });

  describe('getLastSubmissionStatus', () => {
    it("answers pending if submission not present", () => {
      expect(mumuki.SubmissionsStore.getLastSubmissionStatus(1)).toBe('pending');
    });

    it("answers the last submission status if previously sent", () => {
      mumuki.SubmissionsStore.setSubmissionResultFor(1, passedEmptyProgramSubmissionAndResult);
      expect(mumuki.SubmissionsStore.getLastSubmissionStatus(1)).toBe('passed');
    });
  });

  describe('getCachedResultFor', () => {
    it("answers null if submission not present", () => {
      expect(mumuki.SubmissionsStore.getSubmissionResultFor(1, emptyProgramSubmission)).toBe(null);
    });

    it("answers the last submission if previously sent", () => {
      mumuki.SubmissionsStore.setSubmissionResultFor(1, passedEmptyProgramSubmissionAndResult);
      expect(mumuki.SubmissionsStore.getSubmissionResultFor(1, emptyProgramSubmission)).toEqual(passedSubmissionResult);
    });
  });

  describe('submissionSolutionContent', () => {
    it("works with programatic solutions", () => {
      expect(mumuki.SubmissionsStore.submissionSolutionContent({solution: {content: 'foo'}})).toEqual('foo');
    });

    it("works with classic solutions", () => {
      expect(mumuki.SubmissionsStore.submissionSolutionContent({'solution[content]': 'foo'})).toEqual('foo');
    });

    it("works with multifile solutions", () => {
      expect(mumuki.SubmissionsStore.submissionSolutionContent({
        'solution[content[index.html]]': 'html foo',
        'solution[content[index.css]]': 'css foo'
      })).toEqual('[["solution[content[index.html]]","html foo"],["solution[content[index.css]]","css foo"]]');
    });
  });

  describe('submissionSolutionEquals', () => {
    describe('programatic submissions', () => {
      it("answers true when they are equal", () => {
        expect(mumuki.SubmissionsStore.submissionSolutionEquals(
          {solution: {content: 'foo'}},
          {solution: {content: 'foo'}})).toBe(true);
      });

      it("answers true when they are equal but empty", () => {
        expect(mumuki.SubmissionsStore.submissionSolutionEquals(
          {solution: {content: ''}},
          {solution: {content: ''}})).toBe(true);
      });

      it("answers true when they are equal and there are other spurious keys", () => {
        expect(mumuki.SubmissionsStore.submissionSolutionEquals(
          {solution: {content: 'foo'}, utf8: "✓"},
          {solution: {content: 'foo'}})).toBe(true);
      });

      it("answers false when they are not equal", () => {
        expect(mumuki.SubmissionsStore.submissionSolutionEquals(
          {solution: {content: 'foo'}},
          {solution: {content: 'bar'}})).toBe(false);
      });

      it("answers false when they are not equal but one of them is empty", () => {
        expect(mumuki.SubmissionsStore.submissionSolutionEquals(
          {solution: {content: ''}},
          {solution: {content: 'bar'}})).toBe(false);
      });
    });

    describe('classic submissons', () => {
      it("answers true when they are equal", () => {
        expect(mumuki.SubmissionsStore.submissionSolutionEquals(
          {'solution[content]': 'foo'},
          {'solution[content]': 'foo'})).toBe(true);
      });

      it("answers true when they are equal but empty", () => {
        expect(mumuki.SubmissionsStore.submissionSolutionEquals(
          {'solution[content]': ''},
          {'solution[content]': ''})).toBe(true);
      });

      it("answers true when they are equal with other spurious keys", () => {
        expect(mumuki.SubmissionsStore.submissionSolutionEquals(
          {'solution[content]': 'foo'},
          {'solution[content]': 'foo', utf8: "✓"})).toBe(true);
      });

      it("answers false when they are not equal", () => {
        expect(mumuki.SubmissionsStore.submissionSolutionEquals(
          {'solution[content]': 'foo'},
          {'solution[content]': 'bar'})).toBe(false);
      });

      it("answers false when they are not equal but one of them is empty", () => {
        expect(mumuki.SubmissionsStore.submissionSolutionEquals(
          {'solution[content]': ''},
          {'solution[content]': 'bar'})).toBe(false);
      });
    });

    describe('multifile submissions', () => {
      it("answers true when they are equal", () => {
        expect(mumuki.SubmissionsStore.submissionSolutionEquals(
          {
            'solution[content[index.html]]': 'html foo',
            'solution[content[index.css]]': 'css foo'
          },
          {
            'solution[content[index.html]]': 'html foo',
            'solution[content[index.css]]': 'css foo'
          })).toBe(true);
      });

      it("answers true when they are equal with spurious keys", () => {
        expect(mumuki.SubmissionsStore.submissionSolutionEquals(
          {
            'multifile-locales': '{"insert_file_name":"Ingresa un nombre de archivo"}',
            'solution[content[index.html]]': 'html foo',
            'solution[content[index.css]]': 'css foo'
          },
          {
            'solution[content[index.html]]': 'html foo',
            'solution[content[index.css]]': 'css foo'
          })).toBe(true);
      });

      it("answers false when they are not equal", () => {
        expect(mumuki.SubmissionsStore.submissionSolutionEquals(
          {
            'solution[content[index.html]]': 'html foo',
            'solution[content[index.css]]': 'css foo'
          },
          {
            'solution[content[index.html]]': 'html foo',
            'solution[content[index.css]]': 'css bar'
          })).toBe(false);
      });

      it("answers false when they are not equal and with different keys", () => {
        expect(mumuki.SubmissionsStore.submissionSolutionEquals(
          {
            'solution[content[index.html]]': 'html foo',
            'solution[content[index.css]]': 'css foo'
          },
          {
            'solution[content[index.html]]': 'html foo'
          })).toBe(false);
      });
    });
  });
});
