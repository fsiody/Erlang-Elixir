defmodule GenstageExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    import Supervisor.Spec, warn: false

    children = [
      worker(GenstageExample.Prod, [0]),
      worker(GenstageExample.ProdCons, []),
      worker(GenstageExample.Cons, [], id: 1),
      worker(GenstageExample.Cons, [], id: 2)
    ]

    opts = [strategy: :one_for_one, name: GenstageExample.Supervisor]
    Supervisor.start_link(children, opts)


  end
end
