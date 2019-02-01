defmodule Mix.Tasks.Echo do
  @moduledoc """
    Demo Mix Task
  """
    use Mix.Task

    def run(args) do
      Mix.shell().info(Enum.join(args, " "))
    end
  end
