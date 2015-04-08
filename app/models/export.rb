class Export < ActiveRecord::Base
  extend WithAsyncAction

  belongs_to :guide

  schedule_on_create ExportGuideJob
end
