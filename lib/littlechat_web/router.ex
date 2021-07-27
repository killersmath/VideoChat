defmodule LittlechatWeb.Router do
  use LittlechatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LittlechatWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LittlechatWeb do
    pipe_through :browser

    live "/", PageLive, :index

    scope "/room", Room do
      live "/new", NewLive, :new
      live "/show/:slug", ShowLive, :show
    end
  end



  # Other scopes may use custom stacks.
  # scope "/api", LittlechatWeb do
  #   pipe_through :api
  # end


  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: LittlechatWeb.Telemetry
    end
  end
end
