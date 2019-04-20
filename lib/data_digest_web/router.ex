defmodule DataDigestWeb.Router do
  use DataDigestWeb, :router

  require Ueberauth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_auth
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :load_auth
  end

  scope "/", DataDigestWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/auth", DataDigestWeb do
    pipe_through :api

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    post "/logout", AuthController, :delete
  end

  scope "/api", DataDigestWeb do
    pipe_through :api

    get "/schedule", DigestController, :schedule

    resources "/digests", DigestController do
      resources "/subscribers", Digest.SubscriberController
    end
  end
end
