defmodule ToyRobotElixir do
  @moduledoc """
  Public entry point for the Robot Fleet Simulator.

  This project is intentionally a skeleton for a coding test. The tests describe
  representative behavior candidates should implement; `PROBLEM.md` is the
  source of truth for the complete challenge.
  """

  alias ToyRobotElixir.{Command, State}

  @type command_lines :: String.t() | [String.t()]
  @type output_line :: String.t()

  @doc """
  Runs a sequence of robot fleet commands.

  Returns every output line produced by `REPORT`, `PATH`, runtime errors, and
  transaction rollbacks. The simulator should not write these lines to standard
  output.
  """
  @spec run(command_lines()) :: [output_line()] | :not_implemented
  def run(_input), do: not_implemented()

  @doc """
  Applies one parsed command at a specific physical input line.
  """
  @spec execute(State.t(), Command.parsed(), pos_integer()) ::
          {State.t(), [output_line()]} | :not_implemented
  def execute(_state, _command, _line_number), do: not_implemented()

  defp not_implemented do
    Process.get(:toy_robot_elixir_skeleton_result, :not_implemented)
  end
end
