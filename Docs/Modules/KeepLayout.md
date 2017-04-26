# Keep Layout

Keep Layout is project **under active development** whose purpose is to make _Auto Layout_ much easier to use _from code_! No more _Interface Builder_ or _Visual Format_. _Keep Layout_ provides **simple, more readable and powerful API for creating and _accessing existing_ constraints**.


Before you start, you should be familiar with _Auto Layout_ topic. [How it works and what's the point?][1]



## Attributes

Every view has several _attributes_ that are represented by `KeepAttribute` class.

  - Dimensions: **width**, **height**, **aspect ratio**
  - Insets to superview: **top**, **bottom**, **left**, **right**
  - Position in superview: **horizontal** and **vertical**
  - Offsets to other views: **top**, **bottom**, **left**, **right**
  - Alignments with other views: **top**, **bottom**, **left**, **right**, **horizontal**, **vertical**, **baseline**
 
They can be accessed by calling methods on `UIView` object with one of these format:

```objc
- (KeepLayout *)keep<AttributeName>;
- (KeepLayout *(^)(UIView *))keep<AttributeName>To; // Returns block taking another view.
```

Example:

```objc
KeepAttribute *width = view.keepWidth;
KeepAttribute *topOffset = view.keepTopOffsetTo(anotherView); // Invoking the block that returns the actual attribute.
```

Calling such method for the first time creates the attribute object and any subsequent calls will return the same object. For attributes related to other views this is true for each pair of views. Sometimes even in inversed order or direction:

```objc
// aligns are the same regardless of order
viewOne.keepLeftAlign(viewTwo) == viewTwo.keepLeftAlign(viewOne)
// left offset from 1 to 2 is right offset from 2 to 1
viewOne.keepLeftOffset(viewTwo) == viewTwo.keepRightOffset(viewOne)
```

See [`UIView+KeepLayout.h`][2] for more.



## Values

Attributes have three properties: **equal**, **min** and **max**. These are not just plain scalar values, but rather a `struct` representing **value with priority**.

They can be created with one of four convenience functions, one for every basic layout priority:

```objc
KeepValue value = KeepRequired(42);
value = KeepHigh(42);
value = KeepLow(42);
value = KeepFitting(42);

// Arbitrary priority:
value = KeepValueMake(42, 800);
```

Priorities are redeclared as `KeepPriority` enum using `UILayoutPriority` values and they use similar naming:

```objc
Required > High > Low > Fitting
1000       750    250   50
```

See [`KeepTypes.h`][3] for more.



## Putting it together – Examples

Keep width of the view to be equal to 150 with High priority:

```objc
view.keepWidth.equal = KeepHigh(150);
```

Keep top inset to superview of the view to be at least 10, no excuses:

```objc
view.keepTopInset.min = KeepRequired(10);

```

Don't let the first view to get closer than 10 to the second from the left:

```objc
firstView.keepLeftOffsetTo(secondView).min = KeepRequired(10);
```

#### See the _Examples_ app included in the project for more.



---



## Grouped Attributes

You will often want to set multiple attributes to the same value. For this we have **grouped attributes**.

You can create groups at your own:

```objc
KeepAttribute *leftInsets = [KeepAttribute group:
                             viewOne.keepLeftInset,
                             viewTwo.keepLeftInset,
                             viewThree.keepLeftInset,
                             nil];
leftInsets.equal = KeepRequired(10);
```

However there are already some accessors to few of them:

```objc
view.keepSize    // group of both Width and Height
view.keepInsets  // group of all four insets
view.keepCenter  // group of both axis of position
```

See [`UIView+KeepLayout.h`][2] or [`KeepAttribute.h`][4] for more .



## Removable Groups

_Removable Groups_ is a way to remove multiple attributes (or their values) at once. With this you can quickly change one desired set of constraints (= layout) to another.

```objc
// Create removable group
removableLayout = [KeepAttribute removableChanges:^{
    self.view.keepWidth.min = KeepHigh(320); // Set minimum width limit.
    self.view.keepVerticalInsets.equal = KeepRequired(0); // Vertically stretch to fit.
}];
// Group now contains all attributes that were changed in the block.

[removableLayout remove];
// self.view no longer has minimum width of 320 and is no longer stretched vertically.
```

You can also remove these manually using:

```objc
self.view.keepWidth.min = KeepNone; // Removes minimum width constraint.
[self.view.keepWidth remove]; // Removes all constraints for width.
```

See [`KeepAttribute.h`][4] for details.


## Convenience Methods

For the most used cases there are convenience methods. Nothing you could write yourself, but simplify your code and improve readability. Some of them:

```objc
[view keepSize:CGSizeMake(100, 200)];
[view keepInsets:UIEdgeInsetsMake(10, 20, 30, 40)];
[view keepCentered];
```

See [`UIView+KeepLayout.h`][2] for more.



## Array Attributes – What?

Most of the methods added to `UIView` class can also be called on any **array on views**. Such call creates grouped attribute of all contained view attributes:

```objc
NSArray *views = @[ viewOne, viewTwo, viewThree ];
views.keepInsets.min = KeepRequired(10);
```

**The above code creates and configures 12 layout constraints!**

In addition, arrays allow you to use related attributes more easily, using another convenience methods:

```objc
NSArray *views = @[ viewOne, viewTwo, viewThree ];
[views keepWidthsEqual];
[views keepHorizontalOffsets:KeepRequired(20)];
[views keepTopAligned];
```

See [`NSArray+KeepLayout.h`][5] for more.



## Animations

Constraints can be animated. You can use simple `UIView` block animation, but you need to call `-layoutIfNeeded` at the end of animation block. That triggers `-layoutSubviews` which applies new constraints.

Or you can use one of the provided methods so you don't need to care:

```objc
view.keepWidth.equal = KeepRequired(100);

[view.superview keepAnimatedWithDuration:1 layout:^{
    view.keepWidth.equal = KeepRequired(200);
}];
```

These are instance methods and must be called on parent view of all affected subviews. At the end of layout block this view receives `-layoutIfNeeded` method. Any changes to views out of the receiver's subview tree will not be animated.

Spring animation from iOS 7 included.

See [`UIView+KeepLayout.h`][2] for more.


## Debugging

Keep Layout uses its own `NSLayoutConstraint` subclass that overrides `-debugDescription` method. Once you get error message **_`Unable to simultaneously satisfy constraints.`_**, you will see nicely readable description of every constraint you have created. Example:

```objc
"<KeepLayoutConstraint:0xc695560 left offset of <YourView 0xc682cf0> to <YourAnotherView 0xc681350> equal to 20 with required priority>",
"<KeepLayoutConstraint:0xc695560 left offset of <YourView 0xc682cf0> to <YourAnotherView 0xc681350> equal to 50 with required priority>",
```

With this you can very easily find the wrong attribute and fix it.

See [`KeepLayoutConstraint.h`][10] for details.

---


## Implementation Details

Once the attribute is accessed it is created and associated with given view (runtime asociation). In case of related attribbutes, the second view is used as weak key in `NSMapTable`.  
See [`UIView+KeepLayout.m`][6] for details.

Each attribute manages up to three constraints (`NSLayoutConstraint`) that are created, updated and removed when needed. One constraint for each of three relations (`NSLayoutRelation` enum) and setting `equal`, `min` or `max` properties modifies them.  
See [`KeepAttribute.m`][7] for details.

`KeepAttribute` class is a class cluster with specific subclasses. One that manages constraints using `constant` value, one for constraints using `multiplier` and one grouping subclass that forwards primitive methods to its contained children.  
See [`KeepAttribute.m`][7] for details.

Array methods usually call the same selector on contained views and return group of returned attributes.  
See [`NSArray+KeepLayout.m`][8] for details.

Animation delay is implemented as real execution delay, not just delay for animating the changes. This differs from `UIView` block animations and allows you to set up animations in the same update cycle as your initial layout.  
See [`UIView+KeepLayout.m`][6] for details.



---
_Version 1.2.2_

MIT License, Copyright © 2013 Martin Kiss

`THE SOFTWARE IS PROVIDED "AS IS", and so on...` see [`LICENSE.md`][9] more.





[1]: https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/Articles/Introduction.html

[2]: Sources/UIView+KeepLayout.h
[3]: Sources/KeepTypes.h
[4]: Sources/KeepAttribute.h
[5]: Sources/NSArray+KeepLayout.h
[10]: Sources/KeepLayoutConstraint.h

[6]: Sources/UIView+KeepLayout.m
[7]: Sources/KeepAttribute.m
[8]: Sources/NSArray+KeepLayout.m
[9]: LICENSE.md
