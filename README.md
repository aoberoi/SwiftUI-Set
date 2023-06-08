# Set

#### A [Stanford CS193p](https://cs193p.sites.stanford.edu/) Spring 2021 project

This repo contains the codebase for the Set game implementation as it evolves for several
assignments. This README is currently a work in progress, so it is not an exhaustive description.

## Assignment 3

[Description](resources/assignment_3_0.pdf)

All tasks are complete.

## Assignment 4

[Description](resources/assignment_4_0.pdf)

1. New game animations need to be divided into 2 or 3 non overlapping transactions. There are some
   issues observed which might all be solved by this kind of division. Examples of observed issues:

    * Cards from the discardPile that end up in the playArea animate directly, instead of first
      animating to the deck. The two animations happen completely in serial, with no apparent
      overlap. Ideally, there are two separate serial transactions so that all cards return to the
      deck before cards are dealt. Maybe you can even see a shuffle happen in the deck?

      Removing the ShakeEffect implicit animation (which also had the effect of changing the
      animation timing of the border color on selectionState to partOfMatch and partOfMismatch from
      instant to 1 second long) has mitigated this issue. It briefly made another issue, where the
      placeholderView at the bottom of the deck was visible during the reset animation, visible.
      That issue was also corrected using an explicit zIndex on the placeholderView.

      Just to clean things up, every place cards show up are now given an explicit zIndex.

      There must be some kind of modifier on cards in the playArea that is "overriding" the
      matchedGeometryEffect. This could potentially explain why the animation for inserting card
      views into the playArea seem wrong. One example of a modifier that could override is .frame()
      but in theory, the .aspectRatio() modifier would override geometry changes. In general, let's
      look for these kinds of modifiers on all containers of animated card views. A common solution
      might be to move the geometry impacting modifiers to outside the matchedGeometryEffect. EDIT:
      there doesn't seem to be any modifiers that are overriding the geometry effects.

      I'm pretty much out of theories for why this issue is occurring. I know how to pretty reliably
      reproduce the issue. Here are some experiments I could try, that would hopefully allow me to
      learn more:
      * try using a Grid instead to of a LazyVGrid. better yet, try using a simple VStack or HStack
        container to remove as much complexity as possible. i don't see why this would have an
        impact, given the reproduction i've observed doesn't involve the column sizes changing (or
        any noticeable layout changes).
      * try implementing the animatable card flip transition anyway. not sure what this would do,
        but maybe something new will be visually noticable since there wouldn't be as many opacity
        transitions overlapping.

    * When pressing the new game button interrupts an animation of cards from the playArea moving
      to the discard pile, some issues have been observed. One or more cards may animate into the
      playArea from some place other than the deck and matchedCards, such as off to the right side
      of the playArea or just fading into place. It seems like cards that are just fading into place
      were part of the matched set that was interrupted in flying to the discard pile. However cards
      that were moving from a place that wasn't expected were not necessarily in the matched
      selection. No conclusive link yet found to whether or not the card layout reflows.

      The insertion animation into the deck, specifically the cards coming from the playArea, is
      separated from the removal animation of cards from the playArea. This is best captured in
      video, but the former animation shows cards that are moving from the original position in
      playArea and fading in as the move towards the deck. The latter animation shows cards that
      are positioned where they got during the interrupted animation (matched cards on their way
      to the discard pile and unmatched cards reflowing in the grid) and fading out as they change
      direction to go towards the deck. I don't think this will be fixed by implementing the card
      flipping transition. I think the issue will become a lot less noticeable because the cards
      in the insertion animation will not be visible for the first half of the animation and by
      the time it is visible it will likely be very close to meeting the views in the removal
      animation. However, ideally the geometry should be matched. I think this issue can be
      recreated in a simpler sample app, and that can be used to investigate what's happening.

      The layering order of the cards changes as soon as the New Game button is pressed. This most
      likely has to do with the fact that game.reset() will initialize a new deck with the cards
      shuffled into a new order. It seems like the best way to fix this might be to split
      game.reset() into two methods (one that pulls all the cards back in their existing order back
      to the deck and another that generates a new shuffled deck). Another way might be to use some
      view-specific @State. This seems lower priority and might also look find one the card flipping
      transition is implemented.

    * Related to above, when the playArea is scrollable and some of the top rows are not visible,
      and then pressing the new game button interrupts an animation of cards from the playArea
      moving to the discard pile, more issues are observed. Some cards animate into the playArea
      from the top during the time that all the cards are supposed to be animating to the deck. Then
      another animation occurs for dealing. Since there's so much going on here, the best way to
      capture it is with a video. There's a couple included in `resources`.

      NOTE: since the change where implicit animations for ShakeEffect were removed, the cards
      animating into the playArea from the top do not occur. However, the subset of cards that
      should be animating into the deck actually animate to some place below the deck instead. The
      subset is the cards that will are being dealt into the playArea for the new game. All of those
      cards animate to the space below the deck (coming from the deck before new game, the playArea,
      and the discard pile).

      That same animation (cards moving into the deck) also has another issue. The animation of
      cards coming from the playArea is split into two animations (like all matched geometry effect
      transitions): the cards in playArea being removed and the cards in deck being inserted. It
      seems like the cards in deck being inserted has a starting point back where the cards started
      in the playArea after the matched cards were removed, as if the remaining cards had reflowed
      into the grid. However the cards in the playArea being removed start animating from a place
      mid reflow (that animation wasn't complete when the New Game button was pressed). The two
      animations seem to meet at some point before flowing back to the deck.

      There's a layering order problem like the one above.

      Can this be reproduced in the portrait orientation? It was reproduced, but there's some new
      and interesting issues that became apparent.
      
      Nothing is flying out into random places off screen (like it was when the ShakeEffect was
      still present), but there were two cards that animated into the playArea while the rest of the
      cards were animating into the deck. These two cards came from some off screen area above, and
      they came in at the size and animated to the place they would be after the new game was dealt,
      just before the rest of the cards were dealt for the new game. One of these two cards started
      in the discard pile and the other in the play area. The card from the playArea just suddenly
      disappeared instead of animating like the surrounding cards. Perhaps this issue is actually
      related to the lazy grid.

      In addition, when reproduced in the portrait orientation the cards had a significant sudden
      jump in the animation position. And on top of that during the animation the zIndex of cards
      in the grid were changing on nearly every frame. These were the cards that were reflowing when
      the New Game button was pressed and it was only the half of the transition animation of the
      cards being removed from the play area.

      what does this all look like in the debugger?

      maybe we should add explicit source: true to the matchedGeometryEffect and see if that makes
      any difference.

      i think it may be time to prototype an implementation using a Grid (or a simpler container)
      to see if we can narrow the issues down to the LazyVGrid

1. Dealing 3 more card animations should be one transaction. When the existing selection contains a
   match, moving the matched cards to the discard pile should be in the same transaction and result
   in a two sequenced overlapping animations. They can be completely overlapping. In this case, the
   cards being dealt should move into the indexes of the cards being discarded. See notes for more.

1. When the orientation changes (or more specifically the space offered to AspectVGrid), and the
   size of item views needs to change (or more specifically the number of columns), then the update
   should be animated.

   NOTE: since the change where implicit animations for ShakeEffect were removed, the layout changes
   are animated.

1. Fix the animation for choosing a card. No matter what duration is used, the change is immediate.

   NOTE: since the change where the implicit animations for ShakeEffect were removed, the duration
   is now whatever was set in the withAnimation block for the choose() method. That duration effects
   all kinds of UI changes that can occur on a choose(), such as the movement of cards to the
   discardPile. Ideally the durations of various kinds of updates are separated, but that might
   require some more view-specific @State, or may be very complex. The selection state change
   should feel immediate.

2. Replace the animation for a complete selection of matched cards and a complete selection of
   unmatched cards. The color change is too subtle and it's not obvious what the colors mean.

   NOTE: since the change where the implicit animations for ShakeEffect were removed, this became
   even more subtle. The feedback should be immediate, and right now the duration is dictated by
   the withAnimation block for the choose() method (similar to above).

3. When dealing cards into the bottom of the ScrollView, make sure the ScrollView bottom is
   completely visible. Animate the scrolling at the same time as the cards being dealt.

4. Factor out views so that `SetGameView` isn't so huge. Prime examples are the placeholder views,
   cardView, etc. This should done after animation issues are sorted out because refactoring before
   that point would probably be undone and redone.

5. Implement card-by-card movement animations. This can be applied to the initial dealing of cards,
   each time 3 new cards and dealt, when a match is moved to the discard pile, and when a new game
   is started. One technique is to use view @State to keep track of which cards are not yet moved.
   This technique is demonstrated in Lecture 8 around 36:45.

6. Make the card piles have depth and messy looking. Show the number of cards left in the deck, and
   possibly the number of matched cards.

7.  Implement a constraint on the card size in `playArea` by reading the width of cards in
   `controls` and using that as the minimum width. Prototype using `LayoutValueKey` and custom
   layout.

8. Nice-to-have iOS 16 updates
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
