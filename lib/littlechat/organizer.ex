defmodule Littlechat.Organizer do
  import Ecto.Query, warn: false

  alias Littlechat.Repo
  alias Littlechat.Organizer.Room
  def list_rooms do
    Repo.all(Room)
  end

  def get_room(slug) when is_binary(slug) do
    from(room in Room, where: room.slug == ^slug)
    |> Repo.one()
  end
end
