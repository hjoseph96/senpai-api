module ApplicationHelper
    def cdn_for(file)
        "#{Rails.application.credentials.cdn_url}/#{prefix}/#{file.key}"
    end

    def prefix
        case Rails.env
            when 'development' then 'dev'
            when 'staging' then 'stage'
            when 'production' then 'prod'
        end
    end
end
