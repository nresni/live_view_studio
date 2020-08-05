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

alias LiveViewStudio.Repo
alias LiveViewStudio.Vehicles.Vehicle

for _i <- 1..1000 do
  %Vehicle{
    make: Faker.Vehicle.make(),
    model: Faker.Vehicle.model(),
    color: Faker.Color.name()
  }
  |> Repo.insert!()
end
