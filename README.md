# Set

#### A [Stanford CS193p](https://cs193p.sites.stanford.edu/) Spring 2021 project

This repo contains the codebase for the Set game implementation as it evolves for several
assignments.

## Assignment 3

[Description](resources/assignment_3_0.pdf)

## Assignment 4

[Description](resources/assignment_4_0.pdf)

### Misc Notes

Lazy containers are different when it comes to SwiftUI layout. Write down some of those differences.
I think they behave a certain way in the axis they expand on and another way in the other axis.
Based on this, the current use of LazyVStack is probably wrong, because it wants to behave that way
on both axes (and that's why the resize calculation is done). Use this information to consider
whether implementing a Layout (from iOS 16) is actually a better solution to my use case. You can
actually borrow behavior from the built-in layouts to compose a new Layout. Some of the container
views themselves actually conform to Layout.

Since the change where implicit animations for ShakeEffect were removed, the layout changes are
animated as expected. However with ShakeEffect still on, when AspectVGrid needed to change number
of columns, the change was not animated. Watch out for this in case the card flip transition or
the animation to show matched selections or unmatched selections makes this issue reappear.

Some details for reproducing #5: If a matched selection is animating to the matchedCards pile and
then interrupted by the new game button being pressed, it's possible for card to animate into the
playArea from some place other than the shown cards in the deck, playArea, and matchedCards (such as
off to the right side of the playArea, or just fading into place). This was reproduced by clicking
on one of the matched cards in the playArea to start the first animation and then quickly tapping
the new game button. At least one time, the card that appeared without an animation was one of the
cards in the matching selection before the new game was created. None of the other cards in that
selection were in the playArea after the new game was created. That card goes from only in the
discard pile, then only in the deck, then only in the play area. Maybe the new game animation just
needs to be two completely separate non-overlapping transactions. In another instance, two cards
animated as appearing and sliding in from the right but neither of them were in the matched
selection before new game was pushed. In this case, there was a different number of cards before and
after, so the movement might have had to do with reflow. In another instance, this happened with two
cards. The first was not in the matched selection and flew in from the right. The second was in the
matched selection and just appeared. There was no reflow as the number of cards was the same in
before and after.

For sequenced animations, the calculation for groupOfCards probably needs a small constant added to
it.

Factor out views so that `SetGameView` isn't so huge. Prime examples are the placeholder views,
cardView, etc. This should done after animation issues are sorted out because refactoring before
that point would probably be undone and redone.

Evaluate how the views perform in different dynamic type sizes, maybe even on an iPad sized screen.

Scratch this idea: Implement a constraint on the card size in `playArea` by reading the width of
cards in `controls` and using that as the minimum width. Prototype using `LayoutValueKey` and custom
layout.

The selection is not related to the game itself, it's more of a user interface concern. What if the
selection was part of the ViewModel? In order for this to work, Model methods such as `choose()`
would need to somehow communicate back to the ViewModel. There's some other architectural model
that I could possibly learn about and see if its a better fit.
