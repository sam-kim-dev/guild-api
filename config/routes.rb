Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :messages, only: %i[index create]
      get "messages/:sender_id", to: "messages#show", as: "sender_messages"
    end
  end
end
