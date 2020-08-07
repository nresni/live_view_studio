defmodule LiveViewStudio.Volunteers do
  @moduledoc """
  The Volunteers context.
  """

  import Ecto.Query, warn: false
  alias LiveViewStudio.Repo

  alias LiveViewStudio.Volunteers.Volunteer

  @topic inspect(__MODULE__)

  def subscribe() do
    Phoenix.PubSub.subscribe(LiveViewStudio.PubSub, @topic)
  end

  def create_volunteer(attrs \\ %{}) do
    %Volunteer{}
    |> Volunteer.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:volunteer_created)
  end

  def update_volunteer(%Volunteer{} = volunteer, attrs) do
    volunteer
    |> Volunteer.changeset(attrs)
    |> Repo.update()
    |> broadcast(:volunteer_updated)
  end

  def broadcast({:ok, volunteer}, event) do
    Phoenix.PubSub.broadcast(
      LiveViewStudio.PubSub,
      @topic,
      {event, volunteer}
    )

    {:ok, volunteer}
  end

  def broadcast({:error, _reason} = error, _event), do: error

  def list_volunteers do
    Repo.all(from v in Volunteer, order_by: [desc: v.id])
  end

  def get_volunteer!(id), do: Repo.get!(Volunteer, id)

  @doc """
  Deletes a volunteer.

  ## Examples

      iex> delete_volunteer(volunteer)
      {:ok, %Volunteer{}}

      iex> delete_volunteer(volunteer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_volunteer(%Volunteer{} = volunteer) do
    Repo.delete(volunteer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking volunteer changes.

  ## Examples

      iex> change_volunteer(volunteer)
      %Ecto.Changeset{data: %Volunteer{}}

  """
  def change_volunteer(%Volunteer{} = volunteer, attrs \\ %{}) do
    Volunteer.changeset(volunteer, attrs)
  end
end
