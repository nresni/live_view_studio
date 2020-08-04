# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LiveViewStudio.Repo.insert!(%LiveViewStudio.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias LiveViewStudio.GitRepos.GitRepo
alias LiveViewStudio.Repo

%GitRepo{
  name: "elixir",
  url: "https://github.com/elixir-lang/elixir",
  owner_login: "elixir-lang",
  owner_url: "https://github.com/elixir-lang",
  fork: false,
  stars: 16900,
  language: "elixir",
  license: "apache"
}
|> Repo.insert!()

%GitRepo{
  name: "phoenix",
  url: "https://github.com/phoenixframework/phoenix",
  owner_login: "phoenixframework",
  owner_url: "https://github.com/phoenixframework",
  fork: false,
  stars: 15200,
  language: "elixir",
  license: "mit"
}
|> Repo.insert!()

%GitRepo{
  name: "phoenix_live_view",
  url: "https://github.com/phoenixframework/phoenix_live_view",
  owner_login: "phoenixframework",
  owner_url: "https://github.com/phoenixframework",
  fork: false,
  stars: 3000,
  language: "elixir",
  license: "mit"
}
|> Repo.insert!()

%GitRepo{
  name: "phoenix_live_view",
  url: "https://github.com/clarkware/phoenix_live_view",
  owner_login: "clarkware",
  owner_url: "https://github.com/clarkware",
  fork: true,
  stars: 0,
  language: "elixir",
  license: "mit"
}
|> Repo.insert!()

%GitRepo{
  name: "rails",
  url: "https://github.com/rails/rails",
  owner_login: "rails",
  owner_url: "https://github.com/rails",
  fork: false,
  stars: 45600,
  language: "ruby",
  license: "mit"
}
|> Repo.insert!()

%GitRepo{
  name: "ruby",
  url: "https://github.com/ruby/ruby",
  owner_login: "ruby",
  owner_url: "https://github.com/ruby",
  fork: false,
  stars: 16800,
  language: "ruby",
  license: "bsdl"
}
|> Repo.insert!()
