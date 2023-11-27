class ReportSerializer < ActiveModel::Serializer
  attributes :id,  :reason, :created_at,
             :conversation, :reporter, :offender

  def conversation
    object.conversation.messages.map(&:content)
  end

  def reporter
    object.user
  end

  def offender
    object.offender
  end
end
