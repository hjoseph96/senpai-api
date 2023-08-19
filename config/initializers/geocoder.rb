Geocoder.configure(ip_lookup: :ipapi_com, api_key: Rails.application.credentials.ip_api_key)

Geocoder.configure(
    lookup: :amazon_location_service,
    amazon_location_service: {
      index_name: 'senpai_geocoder',
      api_key: {
        access_key_id: Rails.application.credentials.aws_access_token,
        secret_access_key: Rails.application.credentials.aws_secret,
      }
    }
  )