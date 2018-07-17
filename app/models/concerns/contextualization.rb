module Contextualization
  extend ActiveSupport::Concern

  class_methods do

    private

    def submission_mapping
      class_attrs = Submission.mapping_attributes.map { |it| submission_fields_overrides[it] || it }
      class_attrs.zip Submission.mapping_attributes
    end

    def submission_fields_overrides
      { status: :submission_status }
    end
  end

  included do
    serialize :submission_status, Mumuki::Laboratory::Status::Submission
    validates_presence_of :submission_status

    [:expectation_results, :test_results, :query_results].each do |field|
      serialize field
      define_method(field) { self[field]&.map { |it| it.symbolize_keys } }
    end

    composed_of :submission, mapping: submission_mapping, constructor: :from_attributes

    delegate :visible_success_output?, to: :exercise
    delegate :output_content_type, to: :language
    delegate :should_retry?, :to_submission_status, :passed?, :aborted?, to: :submission_status
  end

  def queries_with_results
    queries.zip(query_results).map do |query, result|
      {query: query, status: result&.dig(:status).defaulting(:pending), result: result&.dig(:result)}
    end
  end

  def single_visual_result?
    test_results.size == 1 && test_results.first[:title].blank? && visible_success_output?
  end

  def single_visual_result_html
    output_content_type.to_html test_results.first[:result]
  end

  def results_visible?
    (visible_success_output? || should_retry?) && !exercise.choices?
  end

  def result_preview
    result.truncate(100) if should_retry?
  end

  def result_html
    output_content_type.to_html(result)
  end

  def feedback_html
    output_content_type.to_html(feedback)
  end

  def expectation_results_visible?
    visible_expectation_results.present?
  end

  def visible_expectation_results
    StatusRenderingVerbosity.visible_expectation_results(submission_status, expectation_results || [])
  end
end
