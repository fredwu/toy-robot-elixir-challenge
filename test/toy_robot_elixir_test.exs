defmodule ToyRobotElixirTest do
  use ExUnit.Case

  alias ToyRobotElixir.Command

  describe "Command.parse/1" do
    test "parses arena, placement, movement, reporting, and comments" do
      assert Command.parse("ARENA 7,4") == {:ok, {:arena, 7, 4}}

      assert Command.parse("PLACE scout 1, 2, EAST, 9  # inline comments are ignored") ==
               {:ok, {:place, "scout", 1, 2, :east, 9}}

      assert Command.parse("MOVE scout 03") == {:ok, {:move, "scout", 3}}
      assert Command.parse("LEFT scout 2") == {:ok, {:left, "scout", 2}}
      assert Command.parse("MARCH scout,backup 4") == {:ok, {:march, ["scout", "backup"], 4}}
      assert Command.parse("PATH scout 6,3") == {:ok, {:path, "scout", 6, 3}}
      assert Command.parse("REPORT ALL") == {:ok, {:report, :all}}
      assert Command.parse("  # comment-only lines are ignored") == :ignore
    end

    test "rejects malformed commands with stable reasons" do
      assert Command.parse("PLACE 1bad 0,0,NORTH") == {:error, "invalid robot id"}
      assert Command.parse("MOVE scout -1") == {:error, "invalid step count"}
      assert Command.parse("SPIN scout") == {:error, "unknown command"}
    end
  end

  describe "ToyRobotElixir.run/1 reports and diagnostics" do
    test "runs a single robot through comments, obstacles, energy, and reports" do
      commands = [
        "# no arena has been created yet",
        "MOVE scout",
        "ARENA 6,5",
        "BLOCK 1,1",
        "PLACE scout 0,0,EAST,5",
        "MOVE scout 3",
        "REPORT scout",
        "LEFT scout",
        "MOVE scout 2",
        "REPORT scout"
      ]

      assert ToyRobotElixir.run(commands) == [
               "ERROR 2: arena has not been initialized",
               "scout:3,0,EAST,2",
               "scout:3,2,NORTH,0"
             ]
    end

    test "resolves simultaneous movement collisions deterministically" do
      commands = [
        "ARENA 5,3",
        "PLACE alpha 1,1,EAST,3",
        "PLACE beta 3,1,WEST,3",
        "MARCH beta,alpha 1",
        "REPORT ALL"
      ]

      assert ToyRobotElixir.run(commands) == [
               "alpha:1,1,EAST,3",
               "beta:3,1,WEST,3"
             ]
    end

    test "rolls back an invalid transaction and suppresses buffered reports" do
      commands = [
        "ARENA 5,5",
        "PLACE alpha 1,1,NORTH,3",
        "BEGIN",
        "MOVE alpha 1",
        "PLACE beta 1,2,EAST,4",
        "REPORT ALL",
        "COMMIT",
        "REPORT ALL"
      ]

      assert ToyRobotElixir.run(commands) == [
               "ROLLBACK 7: line 5: cell occupied",
               "alpha:1,1,NORTH,3"
             ]
    end

    test "calculates shortest command paths without mutating robot state" do
      commands = [
        "ARENA 5,5",
        "BLOCK 2,1",
        "BLOCK 2,2",
        "PLACE scout 1,1,EAST,10",
        "PATH scout 3,1",
        "REPORT scout"
      ]

      assert ToyRobotElixir.run(commands) == [
               "PATH scout 7",
               "scout:1,1,EAST,10"
             ]
    end
  end

  describe "ToyRobotElixir.run/1 input forms" do
    test "accepts a newline-delimited string as well as a list of lines" do
      input = """
      ARENA 3,3
      PLACE tiny 0,0,NORTH,1
      MOVE tiny 2
      REPORT tiny
      """

      assert ToyRobotElixir.run(input) == ["tiny:0,1,NORTH,0"]
    end
  end
end
