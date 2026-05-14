defmodule ToyRobotElixir.Robot do
  @moduledoc """
  Robot state and movement operations for the Toy Robot simulator.
  """

  @type direction :: :north | :east | :south | :west
  @type t :: %__MODULE__{
          x: integer() | nil,
          y: integer() | nil,
          direction: direction() | nil
        }

  defstruct x: nil, y: nil, direction: nil

  @doc """
  Returns a robot that has not yet been placed on the table.
  """
  @spec new() :: t()
  def new, do: %__MODULE__{}

  @doc """
  Places the robot on the table when the coordinates and direction are valid.
  """
  def place(_robot, _x, _y, _direction), do: not_implemented()

  @doc """
  Moves the robot one unit forward, ignoring moves that would leave the table.
  """
  def move(_robot), do: not_implemented()

  @doc """
  Rotates the robot 90 degrees to the left.
  """
  def left(_robot), do: not_implemented()

  @doc """
  Rotates the robot 90 degrees to the right.
  """
  def right(_robot), do: not_implemented()

  @doc """
  Reports the robot as `X,Y,DIRECTION`, or `nil` when it is not on the table.
  """
  def report(_robot), do: not_implemented()

  defp not_implemented do
    Process.get(:toy_robot_elixir_skeleton_result, :not_implemented)
  end
end
