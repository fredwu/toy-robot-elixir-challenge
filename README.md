# Robot Fleet Simulator

An Elixir coding challenge based on a much harder version of the classic toy
robot problem. See [PROBLEM.md](PROBLEM.md) for the full specification.

## Prerequisites

- Erlang
- Elixir

## Expected API

```elixir
ToyRobotElixir.run("""
ARENA 5,5
PLACE scout 0,0,NORTH,2
MOVE scout 1
REPORT scout
""")

# => ["scout:0,1,NORTH,1"]
```

The parser is also part of the public contract:

```elixir
ToyRobotElixir.Command.parse("PLACE scout 1,2,EAST,9")
# => {:ok, {:place, "scout", 1, 2, :east, 9}}
```

## Run Tests

```bash
mix test
```

The repository is intentionally a skeleton. The public tests describe a subset
of the required behavior and will fail until the simulator is implemented.
