# # frozen_string_literal: true

# require 'roda'
# require_relative './app'

# module BackendApp
#   # Web controller for Credence API
#   class App < Roda
#     route do |routing|
#       routing.on 'account' do
#         # GET /account/
#         routing.get String do |username|
#           if @current_account && @current_account.username == username
#             view :account, locals: { current_account: @current_account }
#           else
#             routing.redirect '/auth/login'
#           end
#         end
#       end
#     end
#   end
# end
