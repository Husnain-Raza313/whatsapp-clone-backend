# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3001'
    resource '*', headers: :any, methods: %i[get put post patch delete options head]
  end
end
