## The Floor is LAVA

The following scenario was taken by a TV game called "The Floor is LAVA", where players attempt to escape the room filled with lava.
The game is structured into different states and paths.
In every state there is a probability to take a certain path or fall into the lava and each path has a different time distribution (Erlang, Uniform or Exponential).

Whenever a player either wins or falls in the lava, the room requires a deterministic amount of time, with T = 5 min, to prepare for the next player to try.

Considering the game described above, the following metrics were computed:
- Winning probability
- Average duration of a game
- Throughput of the system, which means how many games per hour the room can accomodate

Moreover, a state machine of the system was designed, with all the details of the distributions considered for each path.
