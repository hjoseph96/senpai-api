module Sources
  class UserByReportId < GraphQL::Dataloader::Source
    def fetch(report_ids)
      records = {}

      Report.includes(:user).where(id: report_ids).each do |report|
        records[report.id] = report.user
      end

      report_ids.map { |id| records[id] }
    end
  end
end