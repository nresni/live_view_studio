defmodule LiveViewStudioWeb.FlightsLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Flights

  def mount(_params, _, socket) do
    socket =
      assign(
        socket,
        number: "",
        flights: [],
        loading: false
      )

    {:ok, socket}
  end

  def handle_event("search-flight", %{"number" => number}, socket) do
    send(self(), {:search, number})

    socket = assign(socket, number: number, flights: [], loading: true)

    {:noreply, socket}
  end

  def handle_info({:search, number}, socket) do
    case Flights.search_by_number(number) do
      [] ->
        socket =
          socket
          |> put_flash(:info, "No matching flights for number: \"#{number}\"")
          |> assign(
            loading: false,
            flights: []
          )

        {:noreply, socket}

      flights ->
        socket =
          socket
          |> clear_flash()
          |> assign(
            loading: false,
            flights: flights
          )

        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~L"""
    <h1>Find a Flight</h1>
    <div id="search">

      <form phx-submit="search-flight" action="#">
        <input
          type="text"
          autocomplete="off"
          name="number"
          value="<%= @number %>"
          autofocus=true
          <%= if @loading, do: "readonly" %>
        />
        <button type="submit">
          <img src="images/search.svg" />
        </button>
      </form>

      <%= if @loading do %>
        <div class="loader">Loading...</div>
      <% end %>

      <div class="flights">
        <ul>
          <%= for flight <- @flights do %>
            <li>
              <div class="first-line">
                <div class="number">
                  Flight #<%= flight.number %>
                </div>
                <div class="origin-destination">
                  <img src="images/location.svg">
                  <%= flight.origin %> to
                  <%= flight.destination %>
                </div>
              </div>
              <div class="second-line">
                <div class="departs">
                  Departs: <%= flight.departure_time %>
                </div>
                <div class="arrives">
                  Arrives: <%= flight.arrival_time %>
                </div>
              </div>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end
end
