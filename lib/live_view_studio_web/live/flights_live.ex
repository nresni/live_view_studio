defmodule LiveViewStudioWeb.FlightsLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Flights
  alias LiveViewStudio.Airports

  def mount(_params, _, socket) do
    socket =
      assign(
        socket,
        number: "",
        airport: "",
        flights: [],
        matches: [],
        loading: false
      )

    {:ok, socket}
  end

  def handle_event("search-flight", %{"number" => number}, socket) do
    send(self(), {:search, number})

    socket = assign(socket, number: number, flights: [], loading: true)

    {:noreply, socket}
  end

  def handle_event("search-airport", %{"airport" => airport}, socket) do
    send(self(), {:run_search_airport, airport})

    socket = assign(socket, airport: airport, flights: [], loading: true)

    {:noreply, socket}
  end

  def handle_event("suggest-airport", %{"airport" => prefix}, socket) do
    socket =
      assign(socket,
        matches: Airports.suggest(prefix)
      )

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

  def handle_info({:run_search_airport, airport}, socket) do
    case Flights.search_by_airport(airport) do
      [] ->
        socket =
          socket
          |> put_flash(:info, "No matching flights for number: \"#{airport}\"")
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

      <form phx-submit="search-airport" phx-change="suggest-airport">
        <input
          type="text"
          autocomplete="off"
          name="airport"
          value="<%= @airport %>"
          list="matches"
          phx-debounce="1000"
          <%= if @loading, do: "readonly" %>
        />
        <button type="submit">
          <img src="images/search.svg" />
        </button>
      </form>

      <datalist id="matches">
        <%= for match <- @matches do %>
          <option value="<%= match %>"><%= match %></option>
        <% end %>
      </datalist>

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
