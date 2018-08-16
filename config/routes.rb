Rails.application.routes.draw do
  root 'pages#index'

  get '/_health', to: 'pages#health', defaults: { format: :json }
end
