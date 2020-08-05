defmodule LiveViewStudioWeb.VehiclesLive.Index do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Vehicles

  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [vehicles: []]}
  end

  def handle_params(params, _url, socket) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "5")

    options = %{page: page, per_page: per_page}

    vehicles = Vehicles.list_vehicles(paginate: options)

    socket =
      assign(
        socket,
        options: options,
        vehicles: vehicles
      )

    {:noreply, socket}
  end

  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    socket =
      push_patch(
        socket,
        to:
          Routes.live_path(
            socket,
            __MODULE__,
            per_page: per_page
          )
      )

    {:noreply, socket}
  end
end
