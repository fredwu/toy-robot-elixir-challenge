Robot Fleet Simulator
=====================

Description
-----------

Build an Elixir application that simulates a fleet of named robots moving inside
a rectangular arena. The original toy robot exercise is intentionally too small
for this challenge: this version adds parsing rules, multiple robots, obstacles,
energy, simultaneous movement, transactions, diagnostics, and path queries.

The simulator reads a sequence of command lines and returns every output line
produced by reports, path queries, rollbacks, and errors.

The solution must be deterministic. Given the same input, it must always produce
the same output, regardless of map iteration order, process scheduling, or test
execution order.

Input
-----

Input may be either:

- a newline-delimited string, or
- a list of strings, one command per entry.

Line numbers are 1-based physical input line numbers. Blank lines and comments
still count as physical lines.

Whitespace before and after a command is insignificant. A `#` starts a comment;
everything from the first `#` to the end of the line is ignored. Empty and
comment-only lines are ignored.

Arguments may be separated by spaces, commas, or both. These examples are
equivalent:

    PLACE scout 1,2,EAST,9
    PLACE scout 1, 2, EAST, 9
    PLACE scout 1 2 EAST 9

Command names and directions are uppercase. Robot ids are case-sensitive and
must match:

    [A-Za-z][A-Za-z0-9_]{0,15}

Command names and the `ALL` report target are reserved words and cannot be used
as robot ids.

Coordinates, dimensions, counts, and energy values are base-10 integers. Leading
zeroes are allowed. A plus sign is not allowed.

Parser Contract
---------------

Expose `ToyRobotElixir.Command.parse/1`.

It must return one of:

- `{:ok, parsed_command}` for valid command syntax
- `:ignore` for blank or comment-only lines
- `{:error, reason}` for invalid syntax

Parsed command values must use these exact shapes:

    {:arena, width, height}
    {:block, x, y}
    {:unblock, x, y}
    {:place, id, x, y, direction, energy}
    {:move, id, steps}
    {:left, id, turns}
    {:right, id, turns}
    {:march, ids, steps}
    {:path, id, x, y}
    {:report, id}
    {:report, :all}
    :begin
    :commit

Directions must be atoms: `:north`, `:east`, `:south`, `:west`.

Stable parser error reasons required by the public tests:

- `invalid robot id`
- `invalid step count`
- `unknown command`

You may add more specific reasons for other invalid input, but they must remain
stable and human-readable.

Commands
--------

### ARENA

    ARENA width,height

Creates a new arena with valid coordinates:

    0 <= x < width
    0 <= y < height

`width` and `height` must be between 1 and 1,000 inclusive.

Creating a new arena resets all robots, obstacles, and any active transaction
state.

Every command except `ARENA` before the first valid arena must produce:

    ERROR line: arena has not been initialized

### BLOCK and UNBLOCK

    BLOCK x,y
    UNBLOCK x,y

`BLOCK` adds an obstacle at a valid unoccupied cell.

`UNBLOCK` removes an obstacle from a valid cell. Removing an obstacle from an
empty cell is valid and has no effect.

Blocking a cell occupied by a robot is invalid.

### PLACE

    PLACE id x,y,direction[,energy]

Places a robot at the given cell and direction. If the robot already exists,
`PLACE` moves and reorients it.

`energy` is optional and defaults to 100. Energy must be between 0 and 1,000
inclusive.

Placement is invalid if the cell is outside the arena, blocked by an obstacle,
or occupied by another robot.

### MOVE

    MOVE id [steps]

Moves one robot forward up to `steps` times. `steps` is optional and defaults to
1. It must be between 1 and 1,000 inclusive.

Each successful one-cell move consumes 1 energy. A robot with 0 energy cannot
move. Rotations do not consume energy.

For each requested step, the robot moves if the target cell is inside the arena,
not blocked, and not occupied by another robot. The command stops at the first
failed step. Failed movement does not consume energy.

### LEFT and RIGHT

    LEFT id [turns]
    RIGHT id [turns]

Rotates one robot by 90 degrees per turn. `turns` is optional and defaults to 1.
It must be between 1 and 1,000 inclusive. Turns wrap modulo 4.

### MARCH

    MARCH id1,id2,... steps

Moves the listed robots forward simultaneously for `steps` ticks. `steps` must
be between 1 and 1,000 inclusive. Robot ids may appear in any order in the
command, but the outcome must not depend on the listed order.

For each tick:

1. Each listed robot with energy proposes its next forward cell.
2. A proposal is rejected if the target is outside the arena or blocked.
3. If multiple robots propose the same target cell, all of those proposals are
   rejected.
4. If two robots propose swapping cells with each other, both proposals are
   rejected.
5. A proposal into an occupied cell is accepted only when the occupying robot
   also has an accepted proposal to leave that cell in the same tick.
6. Accepted proposals move simultaneously and consume 1 energy each.
7. Rejected proposals leave the robot in place and consume no energy.

The implementation must resolve these rules deterministically, including chains
of robots where each robot moves into a cell vacated by another accepted move.

### PATH

    PATH id x,y

Outputs the shortest command cost for the robot to reach the target coordinate
without mutating simulator state.

The path search must:

- include `LEFT`, `RIGHT`, and one-cell `MOVE` actions,
- count each action as cost 1,
- avoid arena edges, obstacles, and current robot positions,
- treat the queried robot's current cell as empty for the search,
- respect the robot's current energy as the maximum number of MOVE actions
  available, and
- allow any final direction.

If the robot can reach the target, output:

    PATH id cost

If it cannot, output:

    PATH id UNREACHABLE

### REPORT

    REPORT id
    REPORT ALL

`REPORT id` outputs one robot:

    id:x,y,DIRECTION,energy

`REPORT ALL` outputs one line per robot, sorted lexicographically by robot id.
If there are no robots, it produces no output.

### BEGIN and COMMIT

    BEGIN
    COMMIT

Commands between `BEGIN` and `COMMIT` run inside a transaction.

Rules:

- Nested transactions are invalid.
- A transaction uses a working copy of simulator state.
- Outputs inside a transaction are buffered.
- The first invalid command inside the transaction marks it as failed.
- Commands after the first failure are parsed but do not change the working copy.
- On `COMMIT`, a successful transaction replaces the outer simulator state and
  emits buffered outputs.
- On `COMMIT`, a failed transaction discards the working copy and buffered
  outputs, then emits exactly:

      ROLLBACK commit_line: line failure_line: reason

- End of input with an open transaction must roll it back and emit:

      ROLLBACK EOF: transaction left open

Diagnostics
-----------

Runtime errors outside a transaction must produce:

    ERROR line: reason

Runtime errors inside a transaction must not be emitted immediately. They are
reported only by the rollback line at `COMMIT`.

Stable runtime error reasons required by the public tests:

- `arena has not been initialized`
- `cell occupied`

You may add more specific reasons for other invalid runtime states, but they
must remain stable and human-readable.

Public API
----------

Expose:

    ToyRobotElixir.run(input)

It must return a list of output strings in the exact order they are produced.
It must never write simulator output directly to standard output.

Expose:

    ToyRobotElixir.Command.parse(line)

Use pure functions for the simulation core. The public tests will call the
parser and the top-level runner directly; hidden tests may call lower-level
modules if you provide them.

Examples
--------

### Single robot with comments, obstacles, energy, and reports

Input:

    # no arena has been created yet
    MOVE scout
    ARENA 6,5
    BLOCK 1,1
    PLACE scout 0,0,EAST,5
    MOVE scout 3
    REPORT scout
    LEFT scout
    MOVE scout 2
    REPORT scout

Output:

    ERROR 2: arena has not been initialized
    scout:3,0,EAST,2
    scout:3,2,NORTH,0

### Simultaneous collision

Input:

    ARENA 5,3
    PLACE alpha 1,1,EAST,3
    PLACE beta 3,1,WEST,3
    MARCH beta,alpha 1
    REPORT ALL

Output:

    alpha:1,1,EAST,3
    beta:3,1,WEST,3

### Transaction rollback

Input:

    ARENA 5,5
    PLACE alpha 1,1,NORTH,3
    BEGIN
    MOVE alpha 1
    PLACE beta 1,2,EAST,4
    REPORT ALL
    COMMIT
    REPORT ALL

Output:

    ROLLBACK 7: line 5: cell occupied
    alpha:1,1,NORTH,3

### Path query

Input:

    ARENA 5,5
    BLOCK 2,1
    BLOCK 2,2
    PLACE scout 1,1,EAST,10
    PATH scout 3,1
    REPORT scout

Output:

    PATH scout 7
    scout:1,1,EAST,10

Deliverables
------------

Provide source code and tests.

Engineer the solution to a standard you consider suitable for production:

- clear module boundaries,
- deterministic behavior,
- meaningful names,
- no hidden process state,
- no direct simulator output to standard output,
- useful parser and simulation tests,
- readable diagnostics, and
- reasonable performance for arenas up to 1,000 by 1,000 with thousands of
  commands.

No graphical output is required.
