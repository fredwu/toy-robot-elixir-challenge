defmodule ToyRobotElixirTest do
  use ExUnit.Case

  alias ToyRobotElixir.{Command, Robot}

  describe "Command.parse/1" do
    test "parses place commands" do
      assert Command.parse("PLACE 1,2,EAST") == {:place, 1, 2, :east}
    end

    test "parses movement commands" do
      assert Command.parse("MOVE") == :move
      assert Command.parse("LEFT") == :left
      assert Command.parse("RIGHT") == :right
      assert Command.parse("REPORT") == :report
    end
  end

  describe "Robot" do
    test "places a robot on the table and reports its position" do
      robot =
        Robot.new()
        |> Robot.place(1, 2, :east)

      assert Robot.report(robot) == "1,2,EAST"
    end

    test "moves one unit in the direction it is facing" do
      robot =
        Robot.new()
        |> Robot.place(0, 0, :north)
        |> Robot.move()

      assert Robot.report(robot) == "0,1,NORTH"
    end

    test "turns left and right without changing position" do
      left_turn =
        Robot.new()
        |> Robot.place(0, 0, :north)
        |> Robot.left()

      right_turn =
        Robot.new()
        |> Robot.place(0, 0, :north)
        |> Robot.right()

      assert Robot.report(left_turn) == "0,0,WEST"
      assert Robot.report(right_turn) == "0,0,EAST"
    end

    test "ignores an invalid placement" do
      robot =
        Robot.new()
        |> Robot.place(9, 9, :north)

      assert Robot.report(robot) == nil
    end

    test "ignores moves that would fall off the table" do
      robot =
        Robot.new()
        |> Robot.place(0, 0, :south)
        |> Robot.move()

      assert Robot.report(robot) == "0,0,SOUTH"
    end
  end

  describe "ToyRobotElixir.run/1" do
    test "runs the problem statement example a" do
      commands = [
        "PLACE 0,0,NORTH",
        "MOVE",
        "REPORT"
      ]

      assert ToyRobotElixir.run(commands) == "0,1,NORTH"
    end

    test "runs the problem statement example b" do
      commands = [
        "PLACE 0,0,NORTH",
        "LEFT",
        "REPORT"
      ]

      assert ToyRobotElixir.run(commands) == "0,0,WEST"
    end

    test "runs the problem statement example c" do
      commands = [
        "PLACE 1,2,EAST",
        "MOVE",
        "MOVE",
        "LEFT",
        "MOVE",
        "REPORT"
      ]

      assert ToyRobotElixir.run(commands) == "3,4,NORTH"
    end

    test "ignores commands before the first valid PLACE" do
      commands = [
        "MOVE",
        "LEFT",
        "REPORT",
        "PLACE 2,2,WEST",
        "MOVE",
        "REPORT"
      ]

      assert ToyRobotElixir.run(commands) == "1,2,WEST"
    end
  end
end
