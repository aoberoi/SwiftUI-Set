# Set

#### A [Stanford CS193p](https://cs193p.sites.stanford.edu/) Spring 2021 project

This repo contains the codebase for the Set game implementation as it evolves for several
assignments. This README is currently a work in progress, so it is not an exhaustive description.

## Assignment 3

[Description](resources/assignment_3_0.pdf)

All tasks are complete.

## Assignment 4

[Description](resources/assignment_4_0.pdf)

1. Cards appear to be dealt from the bottom of the deck (the way the deck view is drawn).

    It's not that they are dealt from the bottom, it's that the animation starting point has the
    cards as transparent, and then they fade in as they move into position in the playArea.

    Actually not sure about the above statement. The cards in the playArea are fading in (which
    is why the symbols appear to fade in). The cards from the deck should be fading out. In this
    case I'd expect to see the cards from the deck on top and the borders of those cards
    overlapping. Instead, nothing seems to obscure the back of the top card on the deck. This could
    be a zIndex() issue.

    Using explicit .transition()s didn't seem to solve anything. The animations became weird. The
    dealing animation completely went away and the new game animation didn't animate cards back
    to the deck if they were going to be back in the visible cards later.

    Found a solution that explicitly orders the cards in the deck by a zIndex. Would like to explore
    how the ForEach's natural ordering was not working. As far as I understand, PileView reversed
    the decks order so that the last card was correctly rendered underneath all the other cards.

1. New game animations need to be divided into 2 or 3 non overlapping transactions. There are some
   issues observed which might all be solved by this kind of division. Examples of observed issues:

    * Cards from the discardPile that end up in the playArea animate directly, instead of first
      animating to the deck. The two animations happen completely in serial, with no apparent
      overlap. Ideally, there are two separate serial transactions so that all cards return to the
      deck before cards are dealt. Maybe you can even see a shuffle happen in the deck?

    * When pressing the new game button interrupts an animation of cards from the playArea moving
      to the discard pile, some issues have been observed. One or more cards may animate into the
      playArea from some place other than the deck and matchedCards, such as off to the right side
      of the playArea or just fading into place. It seems like cards that are just fading into place
      were part of the matched set that was interrupted in flying to the discard pile. However cards
      that were moving from a place that wasn't expected were not necessarily in the matched
      selection. No conclusive link yet found to whether or not the card layout reflows.

    * Related to above, when the playArea is scrollable and some of the top rows are not visible,
      and then pressing the new game button interrupts an animation of cards from the playArea
      moving to the discard pile, more issues are observed. Some cards animate into the playArea
      from the top during the time that all the cards are supposed to be animating to the deck. Then
      another animation occurs for dealing. Since there's so much going on here, the best way to
      capture it is with a video. There's a couple included in `resources`.

1. Dealing 3 more card animations should be one transaction. When the existing selection contains a
   match, moving the matched cards to the discard pile should be in the same transaction and result
   in a two sequenced overlapping animations. They can be completely overlapping. In this case, the
   cards being dealt should move into the indexes of the cards being discarded. See notes for more.

1. When the orientation changes (or more specifically the space offered to AspectVGrid), and the
   size of item views needs to change (or more specifically the number of columns), then the update
   should be animated.

1. Fix the animation for choosing a card. No matter what duration is used, the change is immediate.

1. Replace the animation for a complete selection of matched cards and a complete selection of
   unmatched cards. The color change is too subtle and it's not obvious what the colors mean.

1. When dealing cards into the bottom of the ScrollView, make sure the ScrollView bottom is
   completely visible. Animate the scrolling at the same time as the cards being dealt.

1. Factor out views so that `SetGameView` isn't so huge. Prime examples are the placeholder views,
   cardView, etc. This should done after animation issues are sorted out because refactoring before
   that point would probably be undone and redone.

1. Make the card piles have depth and messy looking. Show the number of cards left in the deck, and
   possibly the number of matched cards.

1.  Implement a constraint on the card size in `playArea` by reading the width of cards in
   `controls` and using that as the minimum width. Prototype using `LayoutValueKey` and custom
   layout.

1. Nice-to-have iOS 16 updates
    a. Update minimum iOS target (if not done already)
    a. Remove landscape previews
    a. Evaluate how the views perform in different dynamic type sizes

Ideas and maybes:

1. Implement a card flipping animation used when choosing a card, dealing a card, and starting a new
   game.

1. Investigate replacing `LazyVGrid` with `Grid`. Although there's no layout reason why this
   should be done, its possible that `LazyVGrid` causes animation issues (since it is lazy and
   has a special relationship with `ScrollView` to only build views that will be visible on
   demand).

1. Put debugging code behind some flags.

1. The selection is not related to the game itself, it's more of a user interface concern. What if
   the selection was part of the ViewModel? In order for this to work, Model methods such as
   `choose()` would need to somehow communicate back to the ViewModel.

1. A tap in the empty space of playArea deselects any selected cards (unless there's a matched set).

Notes:

* For sequenced animations, the calculation for groupOfCards probably needs a small constant added
  to it.

* When a match is selected and the deck is used to deal 3 more cards, the selected cards animate to
  the matchedCards and then the cards animate from the deck to the playArea. There is some overlap
  in the two animations (it seems). It's a bit jarring to see the cards in the playArea change sizes
  as some cards leave and then reverse when some cards are dealt into the playArea. The reflow of
  columns is also quite distracting. Ideally the cards stay the same size since the number of cards
  will be the same. Maybe we need to insert the newly dealt cards into the indexes where the about
  to be discarded cards are removed. The hope is that if this is all done in one "transaction" then
  the cards in the playArea do not need to be reflowed.

* If a matched selection is animating to the matchedCards pile and then interrupted by the new game
  button being pressed, it's possible for card to animate into the playArea from some place other
  than the shown cards in the deck, playArea, and matchedCards (such as off to the right side of the
  playArea, or just fading into place). This was reproduced by clicking on one of the matched cards
  in the playArea to start the first animation and then quickly tapping the new game button. At
  least one time, the card that appeared without an animation was one of the cards in the matching
  selection before the new game was created. None of the other cards in that selection were in the
  playArea after the new game was created. That card goes from only in the discard pile, then only
  in the deck, then only in the play area. Maybe the new game animation just needs to be two
  completely separate non-overlapping transactions. In another instance, two cards animated as
  appearing and sliding in from the right but neither of them were in the matched selection before
  new game was pushed. In this case, there was a different number of cards before and after, so the
  movement might have had to do with reflow. In another instance, this happened with two cards. The
  first was not in the matched selection and flew in from the right. The second was in the matched
  selection and just appeared. There was no reflow as the number of cards was the same in before and
  after.
