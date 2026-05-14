defmodule ToyRobotElixir do
  @moduledoc """
  Public entry point for the Toy Robot simulator.

  This project is intentionally a skeleton for a coding test. The tests describe
  the behavior candidates should implement.
  """

  @type command_lines :: String.t() | [String.t()]

  @doc """
  Runs a sequence of toy robot commands and returns the latest report.
  """
  @spec run(command_lines()) :: String.t() | nil | :not_implemented
  def run(_commands), do: not_implemented()

  @doc """
  Applies a parsed command to the robot state.
  """
  @spec execute(ToyRobotElixir.Robot.t(), ToyRobotElixir.Command.parsed()) ::
          ToyRobotElixir.Robot.t() | :not_implemented
  def execute(_robot, _command), do: not_implemented()

  defp not_implemented do
    Process.get(:toy_robot_elixir_skeleton_result, :not_implemented)
  end
end
