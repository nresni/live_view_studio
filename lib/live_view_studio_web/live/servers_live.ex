defmodule LiveViewStudioWeb.ServersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Servers
  alias LiveViewStudio.Servers.Server

  def mount(_params, _session, socket) do
    servers = Servers.list_servers()

    socket =
      assign(socket,
        servers: servers,
        selected_server: hd(servers)
      )

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    id = String.to_integer(id)

    server = Servers.get_server!(id)

    socket =
      assign(socket,
        selected_server: server,
        page_title: "What's up #{server.name}?"
      )

    {:noreply, socket}
  end

  def handle_params(_, _url, socket) do
    if socket.assigns.live_action == :new do
      changeset = Servers.change_server(%Server{})

      socket =
        assign(socket,
          selected_server: nil,
          changeset: changeset
        )

      {:noreply, socket}
    else
      socket =
        assign(
          socket,
          selected_server: hd(socket.assigns.servers)
        )

      {:noreply, socket}
    end
  end

  def handle_event("save", %{"server" => params}, socket) do
    case Servers.create_server(params) do
      {:ok, server} ->
        socket =
          update(
            socket,
            :servers,
            fn servers -> [server | servers] end
          )

        socket = assign(socket, selected_server: server)

        {:noreply,
         push_redirect(
           socket,
           to:
             Routes.live_path(
               socket,
               __MODULE__
             )
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          assign(socket,
            changeset: changeset
          )

        {:noreply, socket}
    end
  end

  def handle_event("toggle-status", %{"id" => id}, %{assigns: %{servers: servers}} = socket) do
    server = Servers.get_server!(id)

    new_status = if server.status == "down", do: "up", else: "down"

    {:ok, selected_server} = Servers.update_server(server, %{status: new_status})

    servers =
      List.update_at(
        servers,
        Enum.find_index(servers, &(&1.id == selected_server.id)),
        fn _server ->
          selected_server
        end
      )

    socket =
      assign(
        socket,
        selected_server: selected_server,
        servers: servers
      )

    {:noreply, socket}
  end

  defp link_body(server) do
    assigns = %{name: server.name, status: server.status}

    ~L"""
    <span class="status <%= @status %>"></span>
    <img src="/images/server.svg">
    <%= @name %>
    """
  end
end
