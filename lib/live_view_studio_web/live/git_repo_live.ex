defmodule LiveViewStudioWeb.GitRepoLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.GitRepos

  def mount(_params, _session, socket) do
    socket =
      assign(
        socket,
        language: "",
        license: "",
        repos: GitRepos.list_git_repos()
      )

    {:ok, socket, temporary_assigns: []}
  end

  def render(assigns) do
    ~L"""
    <h1>Trending Git Repos</h1>
    <div id="repos">
      <form phx-change="filter">
        <div class="filters">
          <select name="language">
            <%= options_for_select(language_options(), @language) %>
          </select>
          <select name="license">
            <%= options_for_select(license_options(), @license)%>
          </select>
        </div>
        <a href="#" phx-click="clear">Clear all</a>
      </form>

      <div class="repos">
        <ul>
          <%= for repo <- @repos do %>
            <li>
              <div class="first-line">
                <div class="group">
                  <img src="images/terminal.svg">
                  <a href="<%= repo.owner_url %>">
                    <%= repo.owner_login %>
                  </a>
                  /
                  <a href="<%= repo.url %>">
                    <%= repo.name %>
                  </a>
                </div>
                <button>
                  <img src="images/star.svg">
                  Star
                </button>
              </div>
              <div class="second-line">
                <div class="group">
                  <span class="language <%= repo.language %>">
                    <%= repo.language %>
                  </span>
                  <span class="license">
                    <%= repo.license %>
                  </span>
                  <%= if repo.fork do %>
                    <img src="images/fork.svg">
                  <% end %>
                </div>
                <div class="stars">
                  <%= repo.stars %> stars
                </div>
              </div>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end

  def handle_event("filter", %{"language" => language, "license" => license}, socket) do
    params = [language: language, license: license]
    repos = GitRepos.list_git_repos(params)

    socket =
      assign(
        socket,
        params ++ [repos: repos]
      )

    {:noreply, socket}
  end

  def handle_event("clear", _, socket) do
    socket =
      assign(
        socket,
        language: "",
        license: "",
        repos: GitRepos.list_git_repos()
      )

    {:noreply, socket}
  end

  defp language_options() do
    [
      "All languages": "",
      Ruby: "ruby",
      "Elixir": "elixir",
      JavaScript: "javascript"
    ]
  end

  defp license_options() do
    [
      "All licenses": "",
      MIT: "mit",
      Apache: "apache",
      BSDL: "bsdl"
    ]
  end
end
