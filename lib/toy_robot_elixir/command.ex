defmodule ToyRobotElixir.Command do
  @moduledoc """
  Parser for commands from the Toy Robot problem statement.
  """

  @doc """
  Parses a command line such as `PLACE 1,2,EAST` or `MOVE`.
  """
  def parse(_line), do: not_implemented()

  defp not_implemented do
    Process.get(:toy_robot_elixir_skeleton_result, :not_implemented)
  end
end
