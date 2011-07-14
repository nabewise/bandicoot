Bandicoot 
=========

"I get knocked down, but I get up again. You're never gonna keep me down" --
Chumbawumba

Wouldn't video games suck without levels and save points?  I can't even tell
you the number of times I've been playing Pokemon, forgetting to save
regularly, only to get in a trainer battle right when my mom calls me down to
dinner.  I was angry for the rest of the day thinking about how all that
effort getting the Magikarp enough XP to evolve was wasted in that one flick
of the power switch.

I feel similarly about my long running, data intensive tasks in Ruby.  If I'm
loading in a file with 200,000 records, some jackass has probably put a
Windows-1252 character in record 195,095 or so.  Restarting this process from
the beginning would throw me into a rage.

Bandicoot lets you set save points from which future computation can resume.
Have a boss battle with some complicated data 5 hours into a process? No
problem! Bandicoot will let you try and fix the bugs and start again.

Warning
-------

Bandicoot is a work in progress. Bandicoot is not currently thread (or Fiber)
safe.  I'm working on a way to make it work while maintaining decent
semantics, but it is not there yet.  It may destroy your computer and force
you to lightly blow on your cartridges.

Usage
-----

Basic usage involves setting Bandicoot up and defining save_points

    Bandicoot.start do
      5.times do |i|
        the_meaning_of_life = 0
        the_meaning_of_life += Bandicoot.save_point(["outer", i]) do
          result = 0
          10.times do |j|
            result += Bandicoot.save_point(["inner", j]) do
              expensive_computation(j)
            end
          end
          result
        end
        the_meaning_of_life
      end
    end

Save points have a key and take a block.  The return value of
Bandicoot.save_point is the return of the block.  Save points can be nested
arbitrarily and proper scoping will be maintained.

This example will always run all of the code, writing its progress out to a
save file.  If the program crashes, you can continue from where it left off by
changing the first line to

    Bandicoot.start(:continue => "path_to_save_file.save") do

It will then load in that file and whenever a save_point is encountered, it
will check whether that save_point was completed.  If it has been, the return
value it gave last time will be returned and the block will not be run.  If it
has not been, it will be run and upon successful completion that save point
will be recorded as well.  In this manner, you can keep trying until you get
it right.

Caveats and Considerations
--------------------------

1) Bandicoot uses msgpack for serialization of keys and return values;
therefore, keys and return values must be primitives where item ==
deserialize(serialize(item)).  Practically, this means primitives and NO
SYMBOLS.  Arbitrarily nested arrays/hashes, numbers, and strings will work
fine.

2) The whole point of Bandicoot is to skip over already run blocks, so
obviously any side effects in that block are not guaranteed to occur.
Oftentimes this is fine and desired (e.g. inserting a row into a database),
but if later code depends on side effects from earlier code, you may have a
bad day.

3) Your code could fail at any point in the save point block.  Bandicoot will
rerun the entire failing block, a bit of idempotence would probably be a good
idea.

