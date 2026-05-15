defmodule ToyRobotElixir.Command do
  @moduledoc """
  Parser for the Robot Fleet Simulator command language.

  See `PROBLEM.md` for the full grammar and the exact parsed command shapes.
  """

  @type direction :: :north | :east | :south | :west
  @type robot_id :: String.t()

  @type parsed ::
          {:arena, pos_integer(), pos_integer()}
          | {:block, non_neg_integer(), non_neg_integer()}
          | {:unblock, non_neg_integer(), non_neg_integer()}
          | {:place, robot_id(), non_neg_integer(), non_neg_integer(), direction(),
             non_neg_integer()}
          | {:move, robot_id(), pos_integer()}
          | {:left, robot_id(), pos_integer()}
          | {:right, robot_id(), pos_integer()}
          | {:march, [robot_id()], pos_integer()}
          | {:path, robot_id(), non_neg_integer(), non_neg_integer()}
          | {:report, robot_id() | :all}
          | :begin
          | :commit

  @type parse_result :: {:ok, parsed()} | :ignore | {:error, String.t()}

  @doc """
  Parses a single command line.

  The parser must handle comments, mixed comma/space separators, default counts,
  and stable syntax error reasons.
  """
  @spec parse(String.t()) :: parse_result() | :not_implemented
  def parse(_line), do: not_implemented()

  defp not_implemented do
    Process.get(:toy_robot_elixir_skeleton_result, :not_implemented)
  end
end
