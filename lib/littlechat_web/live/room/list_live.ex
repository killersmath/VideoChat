defmodule LittlechatWeb.Room.ListLive do
  use LittlechatWeb, :live_view

  alias Littlechat.Organizer

  # alias Littlechat.Repo
  # alias Littlechat.Room

  @impl true
  def mount(_params, _session, socket) do
    case Organizer.list_rooms() do
      nil ->
        {:ok,
          socket
          |> put_flash(:error, "That room does not exist.")
        }
      rooms ->
        {:ok,
          socket
          |> assign(:rooms, rooms)
        }
    end
  end

end
