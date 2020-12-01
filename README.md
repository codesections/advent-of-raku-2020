# Advent of Raku 2020 

This repo exists to give members of the [Raku](https://raku.org/) community a central
place to share their solutions to the [2020 Advent of Code](https://adventofcode.com/2020)
puzzles.  Because Rakoons are a friendly bunch, "member of the Raku community" is **very**
broad.  If you're here and thinking about doing at least one Advent of Code puzzle in
Raku, then you're a member of the Raku community.  Welcome!

(If you're here and _aren't_ considering doing at least one AoC puzzle in Raku, then you
might want to check out this repo's companion blog post, [Why Raku is the ideal language
for Advent of
Code](https://raku-advent.blog/2020/12/01/day-1-why-raku-is-ideal-for-advent-of-code/).)

## Participating

Adding your answers to this repo is very simple.  Simply fork the repo, clone your fork,
copy the `PLACEHOLDER_NAME` directory into a new directory with your username (or and
other name you would like to go by), and start adding puzzle solutions.  By default, the
repo is set up to ignore any files inside the `input` directory as well as any with the
string `input` in their filename, so you can keep input files in the same directory as
your answers.  Once you have an answer that you're happy with, push your changes upstream
and submit a pull request, which will likely be merged promptly.

Once you've submitted your answer, please feel free to discuss it in the [#raku IRC
channel](https://raku.org/community/irc), in this repo's issue tracker, and/or on the
[r/rakulang](https://www.reddit.com/r/rakulang/) subreddit – after all, comparing and
discussing our solutions is how we learn.

And if you _can't_ figure out an answer you're happy with, then you should _also_ feel
free to ask for help on IRC/the issues/the subreddit – there will almost certainly be
someone who can tell you how to get Raku to do what you want it to do!

## Getting started with Raku

The resources below may be helpful, especially if you are new to Raku.  If you have
trouble with anything, are stuck, or would like to discuss your solutions, please say hi
on the [#raku IRC channel](https://raku.org/community/irc).  Even if you've not used IRC
in the past, you join the channel through its [web
interface](https://webchat.freenode.net/#raku).

#### Installing Raku

* [Rakudo Star Source Bundle](https://rakudo.org/star/source) - This is probably the
  easiest way to get started with Raku: it includes a very up-to-date version of Raku and
  all of the ecosystem tools you may need as you are first getting started.
  
* [Other Rakudo Star Bundles](https://rakudo.org/star) - The binary bundles are not quite
  as up-to-date as the source bundle, but that shouldn't matter for AoC puzzles.  A great
  option if you have any trouble with the source bundle.
  
* [Non-Rakudo Star releases](https://rakudo.org/downloads) - Raku is available in a few
  other formats (including OS/distro package managers.  These generally aren't our first
  recommendation for new users – either because they require a bit more work to set up the
  ecosystem or because they are not as recent).  But, really, any should be fine for AoC.
  

#### Documentation & Guides

(roughly in increasing order of depth/length)

* [Raku 101](https://docs.raku.org/language/101-basics) - a **very** gentle introduction;
  it will make sense, but won't show you many of Raku's superpowers.
* [Raku Guide](https://raku.guide/) - A good, concise intro to Raku.
* [Learn Raku in Y minutes](https://learnxinyminutes.com/docs/raku/) - another concise
  overview, though a bit longer than the Raku Guide.
* [Raku Cheat
  Sheet](https://raw.githubusercontent.com/Raku/mu/master/docs/Perl6/Cheatsheet/cheatsheet.txt) -
  Raku in one page.  A good reference for when you're getting started, but not intended to
  teach a lot on its own.
* [docs.raku](https://docs.raku.org/) - The main Raku docs.  Very good, but mostly more of
  a reference than a tutorial (though it does have several tutorials).
* [To compute a constant of calculus (A treatise on multiple
  ways)](http://blogs.perl.org/users/damian_conway/2019/09/to-compute-a-constant-of-calculusa-treatise-on-multiple-ways.html) -
  Less a tutorial than an approachable demo of some of the neat tricks Raku can pull off.
  Don't read this when you're stuck; read it when you're looking for inspiration.
  
#### Community Spaces

* [#raku freenode IRC channel](https://raku.org/community/irc) - The main way to reach all
  the Raku community.  Always open for questions and always friendly.
* [r/rakulang](https://www.reddit.com/r/rakulang/) - The Raku subreddit.  A great place
  for general async discussion on a broad range of topics.
* [Raku StackOverflow](https://stackoverflow.com/questions/tagged/raku) - Home to all and
  sundry technical questions about the Raku language.  Most of the moderators who look at
  the Raku tag are members of our community and thus that corner of StackOverflow is a bit
  friendlier/less likely to abruptly close questions than some other corners are.
