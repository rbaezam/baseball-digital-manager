defmodule BaseballDigitalManagerWeb.Router do
  use BaseballDigitalManagerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BaseballDigitalManagerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BaseballDigitalManagerWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/library/:id", LibraryLive.Index, :index
    live "/team/:library_id/:id", TeamLive.Show, :show
    live "/game/:library_id/new", GameLive.New, :new
    live "/game/:library_id/edit/:id", GameLive.Edit, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", BaseballDigitalManagerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:baseball_digital_manager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BaseballDigitalManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
