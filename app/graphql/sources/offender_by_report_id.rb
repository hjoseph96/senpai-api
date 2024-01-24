module Sources
  class OffenderByReportId < GraphQL::Dataloader::Source
    def fetch(report_ids)
      records = {}

      Report.includes(:offender).where(id: report_ids).each do |report|
        records[report.id] = report.offender
      end

      report_ids.map { |id| records[id] }
    end
  end
end