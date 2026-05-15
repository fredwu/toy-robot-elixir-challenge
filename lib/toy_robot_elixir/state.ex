defmodule ToyRobotElixir.State do
  @moduledoc """
  Arena, robots, obstacles, and transaction state for the simulator.

  This module is intentionally only a skeleton. Candidates may keep this shape
  or refactor it, provided the public API from `ToyRobotElixir` and
  `ToyRobotElixir.Command` remains compatible with the tests and problem
  statement.
  """

  alias ToyRobotElixir.{Command, Robot}

  @type coordinate :: {non_neg_integer(), non_neg_integer()}
  @type arena :: {pos_integer(), pos_integer()}

  @type transaction :: %{
          base: t(),
          working: t(),
          outputs: [String.t()],
          failure: nil | {pos_integer(), String.t()}
        }

  @type t :: %__MODULE__{
          arena: arena() | nil,
          obstacles: MapSet.t(coordinate()),
          robots: %{optional(Robot.id()) => Robot.t()},
          transaction: transaction() | nil
        }

  defstruct arena: nil,
            obstacles: MapSet.new(),
            robots: %{},
            transaction: nil

  @doc """
  Returns the initial simulator state.
  """
  @spec new() :: t()
  def new, do: %__MODULE__{}

  @doc """
  Applies one parsed command to the simulator state.
  """
  @spec apply_command(t(), Command.parsed(), pos_integer()) ::
          {:ok, t(), [String.t()]} | {:error, t(), String.t()} | :not_implemented
  def apply_command(_state, _command, _line_number), do: not_implemented()

  @doc """
  Returns all report lines for all robots in deterministic id order.
  """
  @spec report_all(t()) :: [String.t()] | :not_implemented
  def report_all(_state), do: not_implemented()

  defp not_implemented do
    Process.get(:toy_robot_elixir_skeleton_result, :not_implemented)
  end
end
