We can describe the computational model of a match-action pipeline,
embodied by a control block: the body of the control block is executed,
similarly to the execution of a traditional imperative program:

  - At runtime, statements within a block are executed in the order they
    appear in the control block.
  - Execution of the `return` statement causes immediate termination of
    the execution of the current `control` block, and a return to the
    caller.
  - Execution of the `exit` statement causes the immediate termination
    of the execution of the current `control` block and of all the
    enclosing caller `control` blocks.
  - Applying a `table` executes the corresponding match-action unit, as
    described above.
