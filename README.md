# The Verse

This project has two purposes.  First, I've long wanted to build a [TradeWars](https://wiki.classictw.com/index.php/Main_Page)-like game.  I want to fold in ideas from the [Bobiverse](https://www.goodreads.com/series/192752-bobiverse) turning the gameplay into strategic remote exploration and action.

The other goal of this project is to test out and refine a formal development process.  I want to challenge myself to design the best code I'm capable of designing.  The core of my iterative loop will be the [Red, Green, Refactor](https://www.codecademy.com/article/tdd-red-green-refactor) cycle of [Test-driven Development](https://www.agilealliance.org/glossary/tdd/), with some small tweaks.

The main change is that I want to add small research and documentation at a couple of key points in the process.  I want to lightly research ideas as I move into each new section.  I'll document those findings is the subsections of this document, inspired by [Readme Driven Development](https://tom.preston-werner.com/2010/08/23/readme-driven-development.HTML).

I will also try to document at least modules before I test or implement them.  The goal is to explore the role they are meant to fill, and to be able to search within for function names.  This does mean that the module will usually exit before the failing test, but I want to see if it improves outcomes.

Finally, I'm going to try to lean heavily on [the four rules of simple design](https://blog.thecodewhisperer.com/permalink/putting-an-age-old-battle-to-rest) for a strictly followed refactoring step after each test goes green.  I want to see how far that can take me.

Given all of that, my process will be:

1. Perform and document light research, if starting new functionality
2. Document abstractions and design decisions, if starting a new module
3. Write a failing test:  testing behavior instead of state or implementation
4. Write code to make the test pass
5. Refactor with the rules of simple design
    1. Minimize knowledge, not code, duplication
    2. Improve the communication of intent:  includes naming, types, and docs
    3. Minimize programming constructs, if needed

I plan to keep these rules in front of me while I work, or at least until they are forever burned into my brain.  I also plan to have my tests watch for changes as they occur with the following code constantly running:

```elixir
fswatch lib test | mix test --listen-on-stdin --stale
```

## Map Generation

My research for this section has involved finding old maps from TradeWars games to study and considering the challenges around using TDD on random generation code.  My thinking and findings are summarized in [this thread](https://elixirforum.com/t/how-best-to-use-tdd-for-random-generation/48620).

I will probably build a map visualizer so I can see what I've created, but I will only do that after test-driving the first working version.  If the visualizer shows significant flaws, I test-drive refinements based on what I learn.

…
