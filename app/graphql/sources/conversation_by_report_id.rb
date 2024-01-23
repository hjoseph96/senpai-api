module Sources
  class ConversationByReportId < GraphQL::Dataloader::Source
    def fetch(report_ids)
      records = {}

      Report.includes(:conversation).where(id: report_ids).each do |report|
        records[report.id] = report.conversation
      end

      report_ids.map { |id| records[id] }
    end
  end
end