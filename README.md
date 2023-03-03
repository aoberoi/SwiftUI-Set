# Set

#### A [Stanford CS193p](https://cs193p.sites.stanford.edu/) Spring 2021 project

This repo contains the codebase for the Set game implementation as it evolves for several
assignments. This README is currently a work in progress, so it is not an exhaustive description.

## Assignment 3

[Description](resources/assignment_3_0.pdf)

All tasks are complete.

## Assignment 4

[Description](resources/assignment_4_0.pdf)

1. Fix layout issues. There's an incomplete understanding right now.
    a. How do we solve for card size? Two approaches taken so far:
        - Start with a constant aspect ratio. Allow `controls` to lay itself out first. In
          `controls`, given a certain proposed size and aspectRatio, find out if we're width-limited
          or height-limited. In the width-limited case, use the height we get from using all the
          offered space. In the height-limited case, the height is the max of the hieght we get
          from using all the offered space and some maxHeight. (There might be another way to solve
          for this by measuring subviews and using custom layout). Now `controls` is done. The card
          size in `controls` is the minimum card size the cards in `playArea`. There is no maximum
          card size. The logic in AspectVGrid uses spacing constraints and the number of items to
          calculate the size of those cards. Note: `ViewThatFits` might be helpful in switching on
          height-limited versus width-limited layouts.
        - Philosophically, we want to limit the size of cards in `controls` to be no bigger than
          the cards in the `playArea`. The implementation was iterative, involving many
          recomputations that hopefully converged on a value which met the constraint. This sort of
          iterative implementation is dangerous because it might result in an infinite loop if the
          values don't converge (which we have not really seen). It's also wasteful. A custom layout
          can help solve this more efficiently because it knows how to measure subviews without
          relying on PreferenceKeys to bubble up the geometry info. Even with a custom layout, we
          might still need an iterative solution (unless we can imperatively solve for the layout).
          Maybe the other problems were warnings and unwanted recalcuations once animations were
          added.
          
    a. LazyVGrid may be complicating the computation of card sizes. The new Grid might be a better
       fit because it can size cells in both dimensions. In fact, we never use the laziness of the
       view. On the other hand, the LazyVGrid has a special relationship with ScrollView, and it's
       not well understood how ScrollView interacts with Grid.
       
    a. Factor out views so that SetGameView isn't so huge. Prime examples are the placeholder views,
       cardView, etc.
       
    a. See if we can reproduce this issue (even though the animation namespaces have been merged):
       A warning is logged where the matchedGeometryEffect complains that there's two views with
       `source: true` related to the discardNamespace. This is most easily reproduced by selecting a
       set, choosing a selected card to move it to discard, and then drawing again. The warning
       specifically mentions the 3 cards that were most recently discarded, not the new cards that
       were drawn (seems odd).
    
2. Fix animation issues.
    a. The animation for choosing a card doesn't seem to be working. No matter how I adjust the
       duration, it is not effected.
    a. Sequencing animations: When dealing a new game, cards animate back to the deck and then cards
       animate from the deck to the playArea. When a match is selected and the deck is used to deal
       3 more cards, the selected cards animate to the matchedCards and then the cards animate from
       the deck to the playArea. Side note: the calculation for groupOfCards probably needs a small
       constant added to it.
    a. There seems to be issues in AspectVGrid, especially when the number of columns change (such
       as when there's a new game or when orientation changes). This may be tied up with view
       identity.
    a. Replace the animation for a complete selection of matched cards and a complete selection of
       unmatched cards.

3. Extra embellishments
    a. Put debugging code behind some flags. (This might need to be done while working on previous
       issues)
    a. Card flipping animation (including choosing, dealing, and starting a new game)
    a. Make the piles have depth and messy looking. Show the number of cards left in the deck, and
       possible the number of matched cards.

4. Nice-to-have iOS 16 updates
    a. Update minimum iOS target (if not done already)
    a. Remove landspace previews
    a. Evaluate how the views perform in different dynamic type sizes

5. Curiosity
    a. The selection is not related to the game itself, it's more of a user interface concern.
       What if the selection was part of the ViewModel? In order for this to work, Model methods
       such as `choose()` woould need to somehow communicate back to the ViewModel.
