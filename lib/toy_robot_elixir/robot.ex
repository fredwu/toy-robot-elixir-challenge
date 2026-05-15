defmodule ToyRobotElixir.Robot do
  @moduledoc """
  Robot data and low-level movement helpers for the fleet simulator.
  """

  @type direction :: ToyRobotElixir.Command.direction()
  @type id :: String.t()

  @type t :: %__MODULE__{
          id: id(),
          x: non_neg_integer(),
          y: non_neg_integer(),
          direction: direction(),
          energy: non_neg_integer()
        }

  defstruct id: nil,
            x: nil,
            y: nil,
            direction: nil,
            energy: 0

  @doc """
  Builds a robot value after placement validation has succeeded.
  """
  @spec new(id(), non_neg_integer(), non_neg_integer(), direction(), non_neg_integer()) ::
          t() | :not_implemented
  def new(_id, _x, _y, _direction, _energy), do: not_implemented()

  @doc """
  Returns the coordinate one step ahead of the robot without changing state.
  """
  @spec forward_coordinate(t()) :: {non_neg_integer(), non_neg_integer()} | :not_implemented
  def forward_coordinate(_robot), do: not_implemented()

  @doc """
  Rotates the robot left by the requested number of quarter turns.
  """
  @spec left(t(), pos_integer()) :: t() | :not_implemented
  def left(_robot, _turns \\ 1), do: not_implemented()

  @doc """
  Rotates the robot right by the requested number of quarter turns.
  """
  @spec right(t(), pos_integer()) :: t() | :not_implemented
  def right(_robot, _turns \\ 1), do: not_implemented()

  @doc """
  Formats a report line as `id:x,y,DIRECTION,energy`.
  """
  @spec report(t()) :: String.t() | :not_implemented
  def report(_robot), do: not_implemented()

  defp not_implemented do
    Process.get(:toy_robot_elixir_skeleton_result, :not_implemented)
  end
end
