defmodule LittlechatWeb.Room.ShowLive do
  @moduledoc """
  A LiveView for creating and joining chat rooms.
  """

  use LittlechatWeb, :live_view

  alias Littlechat.Organizer
  alias Littlechat.ConnectedUser

  alias LittlechatWeb.Presence
  alias Littlechat.PubSub
  alias Phoenix.Socket.Broadcast

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    track_key = "room:" <> slug
    user = create_connected_user()

    Phoenix.PubSub.subscribe(PubSub,track_key)
    {:ok, _} = Presence.track(self(), track_key, user.uuid, %{})

    case Organizer.get_room(slug) do
      nil ->
        {:ok,
          socket
          |> put_flash(:error, "That room does not exist.")
          |> push_redirect(to: Routes.new_path(socket, :new))
        }
      room ->
        {:ok,
          socket
          |> assign(:room, room)
          |> assign(:user, user)
          |> assign(:slug, slug)
          |> assign(:connected_users, [])
        }
    end
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff"}, socket) do
    {:noreply,
      socket
      |> assign(:connected_users, list_present(socket))}
  end

   defp list_present(socket) do
     Presence.list("room:" <> socket.assigns.slug)
     |> Enum.map(fn {k, _} -> k end) # Phoenix Presence provides nice metadata, but we don't need it.
   end

  defp create_connected_user do
    %ConnectedUser{uuid: UUID.uuid4()}
  end
end
