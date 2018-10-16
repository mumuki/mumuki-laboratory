class ConvertSubmissionsIntoSolutions < ActiveRecord::Migration[4.2]
  def change
    ActiveRecord::Base.connection.execute(
        "insert into solutions
            (content,
            exercise_id,
            status,
            result,
            submitter_id,
            expectation_results,
            created_at,
            updated_at,
            submission_id,
            submissions_count)
        select
            s.content,
            s.exercise_id,
            s.status,
            s.result,
            s.submitter_id,
            s.expectation_results,
            s.created_at,
            s.updated_at,
            s.id,
            x.submissions_count
        from submissions s
          join  (select
                    max(id) id,
                    count(id) submissions_count
                 from submissions
                 group by exercise_id, submitter_id)
              x on s.id = x.id;")
  end
end
