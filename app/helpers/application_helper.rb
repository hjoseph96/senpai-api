module ApplicationHelper
    def cdn_for(file)
        "#{Rails.application.credentials.cdn_url}/#{file.key}"
    end
end
