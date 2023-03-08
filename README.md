# Set

#### A [Stanford CS193p](https://cs193p.sites.stanford.edu/) Spring 2021 project

This repo contains the codebase for the Set game implementation as it evolves for several
assignments. This README is currently a work in progress, so it is not an exhaustive description.

## Assignment 3

[Description](resources/assignment_3_0.pdf)

All tasks are complete.

## Assignment 4

[Description](resources/assignment_4_0.pdf)

1. Take inventory of animation issues. It's important to know what is and isn't working so that
   we understand which changes may cause a regression.

    a. See if we can reproduce this issue (even though the animation namespaces have been merged):
       A warning is logged where the matchedGeometryEffect complains that there's two views with
       `source: true` related to the discardNamespace. This is most easily reproduced by selecting a
       set, choosing a selected card to move it to discard, and then drawing again. The warning
       specifically mentions the 3 cards that were most recently discarded, not the new cards that
       were drawn (seems odd).

    b. Check the sequencing of animations. (Side note: the calculation for groupOfCards probably
       needs a small constant added to it.) Two examples of when sequenced animations are used:

        i.  When dealing a new game, cards animate back to the `deck` first and then cards animate
            from the `deck` to the `playArea`.
        ii. When a match is selected and the deck is used to deal 3 more cards, the selected cards
            animate to the matchedCards and then the cards animate from the deck to the playArea.

    c. There seems to be issues in AspectVGrid, especially when the number of columns change (such
       as when there's a new game or when orientation changes). This may be tied up with view
       identity.

1. Fix the animation for choosing a card. No matter what duration is used, the change is immediate.

1. Replace the animation for a complete selection of matched cards and a complete selection of
   unmatched cards. The color change is too subtle and it's not obvious what the colors mean.

1. Factor out views so that `SetGameView` isn't so huge. Prime examples are the placeholder views,
   cardView, etc. This should done after animation issues are sorted out because refactoring before
   that point would probably be undone and redone.

1. Make the card piles have depth and messy looking. Show the number of cards left in the deck, and
   possibly the number of matched cards.

1. Implement a constraint on the card size in `playArea` by reading the width of cards in
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
