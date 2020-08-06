defmodule LiveViewStudioWeb.VehiclesLive.Index do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Vehicles

  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [vehicles: []]}
  end

  def handle_params(params, _url, socket) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "5")

    sort_by = (params["sort_by"] || "id") |> String.to_atom()
    sort_order = (params["sort_order"] || "asc") |> String.to_atom()

    sort_options = %{sort_by: sort_by, sort_order: sort_order}
    options = %{page: page, per_page: per_page}

    vehicles = Vehicles.list_vehicles(paginate: options, sort: sort_options)

    socket =
      assign(
        socket,
        options: Map.merge(options, sort_options),
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
            per_page: per_page,
            page: socket.assigns.options.page,
            sort_by: socket.assigns.options.sort_by,
            sort_order: socket.assigns.options.sort_order
          )
      )

    {:noreply, socket}
  end

  defp page_link(socket, text, page, options, class) do
    live_patch(
      text,
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          page: page,
          per_page: options.per_page,
          sort_by: options.sort_by,
          sort_order: options.sort_order
        ),
      class: class
    )
  end

  defp sort_link(socket, text, sort_by, options) do
    live_patch(
      text,
      to:
        Routes.live_path(
          socket,
          __MODULE__,
          sort_by: sort_by,
          sort_order: toggle_sort(options.sort_order),
          page: options.page,
          per_page: options.per_page
        )
    )
  end

  defp toggle_sort(:asc), do: :desc
  defp toggle_sort(:desc), do: :asc
end
