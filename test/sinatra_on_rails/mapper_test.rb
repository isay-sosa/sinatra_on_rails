# frozen_string_literal: true

require 'test_helper'

module SinatraOnRails
  class MapperTest < ApplicationTest
    def setup
      @app = ApplicationTest::DummyApplication
      @subject = SinatraOnRails::Mapper.new(@app)
    end

    def teardown
      @app.reset!
    end

    def test_post_route
      @subject.post('/cards', to: { controller: :cards, action: :create })

      post '/cards', {}.to_json
      assert_equal 'CardsController#create', last_response.body
    end

    def test_get_route
      @subject.get('/cards', to: { controller: :cards, action: :index })

      get '/cards'
      assert_equal 'CardsController#index', last_response.body
    end

    def test_put_route
      @subject.put('/cards/:id', to: { controller: :cards, action: :update })

      put '/cards/1', {}.to_json
      assert_equal 'CardsController#update', last_response.body
    end

    def test_delete_route
      @subject.delete('/cards/:id', to: { controller: :cards, action: :destroy })

      delete '/cards/1'
      assert_equal 'CardsController#destroy', last_response.body
    end

    def test_resources
      @subject.resources(:cards)

      get '/cards'
      assert_equal 'CardsController#index', last_response.body

      post '/cards', {}.to_json
      assert_equal 'CardsController#create', last_response.body

      get '/cards/new'
      assert_equal 'CardsController#new', last_response.body

      get '/cards/1/edit'
      assert_equal 'CardsController#edit', last_response.body

      get '/cards/1'
      assert_equal 'CardsController#show', last_response.body

      put '/cards/1', {}.to_json
      assert_equal 'CardsController#update', last_response.body

      delete '/cards/1'
      assert_equal 'CardsController#destroy', last_response.body
    end

    def test_resources_only_option
      @subject.resources(:cards, only: %i[index])

      get '/cards'
      assert_equal 'CardsController#index', last_response.body

      post '/cards', {}.to_json
      refute_equal 'CardsController#create', last_response.body

      get '/cards/new'
      refute_equal 'CardsController#new', last_response.body

      get '/cards/1/edit'
      refute_equal 'CardsController#edit', last_response.body

      get '/cards/1'
      refute_equal 'CardsController#show', last_response.body

      put '/cards/1', {}.to_json
      refute_equal 'CardsController#update', last_response.body

      delete '/cards/1'
      refute_equal 'CardsController#destroy', last_response.body
    end

    def test_resources_except_option
      @subject.resources(:cards, except: %i[index])

      get '/cards'
      refute_equal 'CardsController#index', last_response.body

      post '/cards', {}.to_json
      assert_equal 'CardsController#create', last_response.body

      get '/cards/new'
      assert_equal 'CardsController#new', last_response.body

      get '/cards/1/edit'
      assert_equal 'CardsController#edit', last_response.body

      get '/cards/1'
      assert_equal 'CardsController#show', last_response.body

      put '/cards/1', {}.to_json
      assert_equal 'CardsController#update', last_response.body

      delete '/cards/1'
      assert_equal 'CardsController#destroy', last_response.body
    end

    def test_resources_path_and_path_names_options
      @subject.resources(:cards, path: 'cartas', path_names: { new: 'nueva', edit: 'editar' })

      get '/cartas'
      assert_equal 'CardsController#index', last_response.body

      post '/cartas', {}.to_json
      assert_equal 'CardsController#create', last_response.body

      get '/cartas/nueva'
      assert_equal 'CardsController#new', last_response.body

      get '/cartas/1/editar'
      assert_equal 'CardsController#edit', last_response.body

      get '/cartas/1'
      assert_equal 'CardsController#show', last_response.body

      put '/cartas/1', {}.to_json
      assert_equal 'CardsController#update', last_response.body

      delete '/cartas/1'
      assert_equal 'CardsController#destroy', last_response.body
    end

    def test_nested_resources
      @subject.resources(:users) do
        resources(:cards)
      end

      get '/users'
      assert_equal 'UsersController#index', last_response.body

      post '/users', {}.to_json
      assert_equal 'UsersController#create', last_response.body

      get '/users/new'
      assert_equal 'UsersController#new', last_response.body

      get '/users/1/edit'
      assert_equal 'UsersController#edit', last_response.body

      get '/users/1'
      assert_equal 'UsersController#show', last_response.body

      put '/users/1', {}.to_json
      assert_equal 'UsersController#update', last_response.body

      delete '/users/1'
      assert_equal 'UsersController#destroy', last_response.body

      get '/users/1/cards'
      assert_equal 'CardsController#index', last_response.body

      post '/users/1/cards', {}.to_json
      assert_equal 'CardsController#create', last_response.body

      get '/users/1/cards/new'
      assert_equal 'CardsController#new', last_response.body

      get '/users/1/cards/1/edit'
      assert_equal 'CardsController#edit', last_response.body

      get '/users/1/cards/1'
      assert_equal 'CardsController#show', last_response.body

      put '/users/1/cards/1', {}.to_json
      assert_equal 'CardsController#update', last_response.body

      delete '/users/1/cards/1'
      assert_equal 'CardsController#destroy', last_response.body
    end

    def test_nested_resources_path_and_path_names_options
      @subject.resources(:users, path: :usuarios, path_names: { new: 'nuevo', edit: 'editar' }) do
        resources(:cards, path: :cartas, path_names: { new: 'nueva', edit: 'editar' })
      end

      get '/usuarios'
      assert_equal 'UsersController#index', last_response.body

      post '/usuarios', {}.to_json
      assert_equal 'UsersController#create', last_response.body

      get '/usuarios/nuevo'
      assert_equal 'UsersController#new', last_response.body

      get '/usuarios/1/editar'
      assert_equal 'UsersController#edit', last_response.body

      get '/usuarios/1'
      assert_equal 'UsersController#show', last_response.body

      put '/usuarios/1', {}.to_json
      assert_equal 'UsersController#update', last_response.body

      delete '/usuarios/1'
      assert_equal 'UsersController#destroy', last_response.body

      get '/usuarios/1/cartas'
      assert_equal 'CardsController#index', last_response.body

      post '/usuarios/1/cartas', {}.to_json
      assert_equal 'CardsController#create', last_response.body

      get '/usuarios/1/cartas/nueva'
      assert_equal 'CardsController#new', last_response.body

      get '/usuarios/1/cartas/1/editar'
      assert_equal 'CardsController#edit', last_response.body

      get '/usuarios/1/cartas/1'
      assert_equal 'CardsController#show', last_response.body

      put '/usuarios/1/cartas/1', {}.to_json
      assert_equal 'CardsController#update', last_response.body

      delete '/usuarios/1/cartas/1'
      assert_equal 'CardsController#destroy', last_response.body
    end

    def test_resource
      @subject.resource(:profile)

      get '/profile'
      assert_equal 'ProfileController#show', last_response.body

      post '/profile', {}.to_json
      assert_equal 'ProfileController#create', last_response.body

      get '/profile/new'
      assert_equal 'ProfileController#new', last_response.body

      get '/profile/edit'
      assert_equal 'ProfileController#edit', last_response.body

      put '/profile', {}.to_json
      assert_equal 'ProfileController#update', last_response.body

      delete '/profile'
      assert_equal 'ProfileController#destroy', last_response.body
    end

    def test_resource_only_option
      @subject.resource(:profile, only: %i[destroy])

      get '/profile'
      refute_equal 'ProfileController#show', last_response.body

      post '/profile', {}.to_json
      refute_equal 'ProfileController#create', last_response.body

      get '/profile/new'
      refute_equal 'ProfileController#new', last_response.body

      get '/profile/edit'
      refute_equal 'ProfileController#edit', last_response.body

      put '/profile', {}.to_json
      refute_equal 'ProfileController#update', last_response.body

      delete '/profile'
      assert_equal 'ProfileController#destroy', last_response.body
    end

    def test_resource_except_option
      @subject.resource(:profile, except: %i[destroy create show])

      get '/profile'
      refute_equal 'ProfileController#show', last_response.body

      post '/profile', {}.to_json
      refute_equal 'ProfileController#create', last_response.body

      get '/profile/new'
      assert_equal 'ProfileController#new', last_response.body

      get '/profile/edit'
      assert_equal 'ProfileController#edit', last_response.body

      put '/profile', {}.to_json
      assert_equal 'ProfileController#update', last_response.body

      delete '/profile'
      refute_equal 'ProfileController#destroy', last_response.body
    end

    def test_resource_path_path_names_option
      @subject.resource(:profile, path: 'perfil', path_names: { new: 'nuevo', edit: 'editar' })

      get '/perfil'
      assert_equal 'ProfileController#show', last_response.body

      post '/perfil', {}.to_json
      assert_equal 'ProfileController#create', last_response.body

      get '/perfil/nuevo'
      assert_equal 'ProfileController#new', last_response.body

      get '/perfil/editar'
      assert_equal 'ProfileController#edit', last_response.body

      put '/perfil', {}.to_json
      assert_equal 'ProfileController#update', last_response.body

      delete '/perfil'
      assert_equal 'ProfileController#destroy', last_response.body
    end

    def test_namespace
      @subject.namespace(:admin) do
        resources :users
      end

      get '/admin/users'
      assert_equal 'Admin::UsersController#index', last_response.body

      post '/admin/users', {}.to_json
      assert_equal 'Admin::UsersController#create', last_response.body

      get '/admin/users/new'
      assert_equal 'Admin::UsersController#new', last_response.body

      get '/admin/users/1/edit'
      assert_equal 'Admin::UsersController#edit', last_response.body

      get '/admin/users/1'
      assert_equal 'Admin::UsersController#show', last_response.body

      put '/admin/users/1', {}.to_json
      assert_equal 'Admin::UsersController#update', last_response.body

      delete '/admin/users/1'
      assert_equal 'Admin::UsersController#destroy', last_response.body
    end
  end
end

module Admin
  class UsersController < SinatraOnRails::ActionController
    def create
      'Admin::UsersController#create'
    end

    def destroy
      'Admin::UsersController#destroy'
    end

    def edit
      'Admin::UsersController#edit'
    end

    def index
      'Admin::UsersController#index'
    end

    def new
      'Admin::UsersController#new'
    end

    def show
      'Admin::UsersController#show'
    end

    def update
      'Admin::UsersController#update'
    end
  end
end

class CardsController < SinatraOnRails::ActionController
  def create
    'CardsController#create'
  end

  def destroy
    'CardsController#destroy'
  end

  def edit
    'CardsController#edit'
  end

  def index
    'CardsController#index'
  end

  def new
    'CardsController#new'
  end

  def show
    'CardsController#show'
  end

  def update
    'CardsController#update'
  end
end

class ProfileController < SinatraOnRails::ActionController
  def create
    'ProfileController#create'
  end

  def destroy
    'ProfileController#destroy'
  end

  def edit
    'ProfileController#edit'
  end

  def new
    'ProfileController#new'
  end

  def show
    'ProfileController#show'
  end

  def update
    'ProfileController#update'
  end
end

class UsersController < SinatraOnRails::ActionController
  def create
    'UsersController#create'
  end

  def destroy
    'UsersController#destroy'
  end

  def edit
    'UsersController#edit'
  end

  def index
    'UsersController#index'
  end

  def new
    'UsersController#new'
  end

  def show
    'UsersController#show'
  end

  def update
    'UsersController#update'
  end
end
