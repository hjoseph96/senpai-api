Rails.configuration.to_prepare do
    ActiveStorage::Blob.class_eval do
      before_create :generate_key_with_prefix
  
      def generate_key_with_prefix
        self.key = File.join prefix, self.class.generate_unique_secure_token
      end
  
      def prefix
        case Rails.env
            when 'development' then 'dev'
            when 'staging' then 'stage'
            when 'production' then 'prod'
        end
      end
    end
  end