Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  get '/begin_auth', to: 'sessions#begin_auth'
  get '/finish_auth', to: 'sessions#finish_auth'
end
