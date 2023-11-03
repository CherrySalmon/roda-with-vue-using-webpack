# frozen_string_literal: true

def require_app(folders = %w[controllers repositories services models])
  app_list = Array(folders).map { |folder| "backend_app/#{folder}" }
  full_list = ['config', app_list].flatten.join(',')

  Dir.glob("./{#{full_list}}/**/*.rb").each do |file|
    require file
  end
end
