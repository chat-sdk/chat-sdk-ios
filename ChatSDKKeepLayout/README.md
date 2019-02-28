# Keep Layout <a href="http://flattr.com/thing/1767350/iMartinKissKeepLayout-on-GitHub" target="_blank"><img src="http://api.flattr.com/button/flattr-badge-large.png" alt="Flattr this" title="Flattr this" border="0" /></a>

Keep Layout makes _Auto Layout_ much easier to use _from code_! No more _Interface Builder_ or _Visual Format_. _Keep Layout_ provides **simple, more readable and powerful API for creating and _accessing existing_ constraints**.


Before you start, you should be familiar with _Auto Layout_ topic. [How it works and what's the point?][1]


_**Project Status**: All planned features are implemented and functional. Project is maintained and kept up to date with latest iOS/OS X. Feel free to submit Issues or Pull Requests._

_**Swift Adopters**: Swift is fully supported, the usage syntax is the mostly the same._

_**Origins:** This library was originally made for [this app](https://itunes.apple.com/app/geography-of-the-world/id391081388?mt=8&ct=KeepLayout), especially for its iPad interface._


## Attributes

Every view has several _attributes_ that are represented by `KeepAttribute` class.

  - Dimensions: **width**, **height**, **aspect ratio**
  - Insets to superview: **top**, **bottom**, **left**, **right**
  - Insets to superview margins: **top**, **bottom**, **left**, **right**
  - Position in superview: **horizontal** and **vertical**
  - Offsets to other views: **top**, **bottom**, **left**, **right**
  - Alignments with other views: **top**, **bottom**, **left**, **right**, **horizontal**, **vertical**, **first & last baselines**
 
They can be accessed by calling methods on `UIView`/`NSView` object with one of these format:

```objc
@property (readonly) KeepLayout *keep<AttributeName>;
@property (readonly) KeepLayout *(^keep<AttributeName>To)(UIView *)); // Returns block taking another view.
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

See [`KeepView.h`][2] for more.



## Values

Attributes have three properties: **equal**, **min** and **max**. These are not just plain scalar values, but may have associated a **priority**.

Priority is _Required_ by default, but you can specify arbitrary priority using provided macros:

```objc
KeepValue value = 42; // value 42 at priority 1000
value = 42 +keepHigh; // value 42 at priority 750
value = 42 +keepLow; // value 42 at priority 250
value = 42 +keepFitting; // value 42 at priority 50

// Arbitrary priority:
value = 42 +keepAt(800); // value 42 at priority 800
```

Priorities are redeclared as `KeepPriority` using `UILayoutPriority` values and they use similar naming:

```objc
Required > High > Low > Fitting
1000       750    250   50
```

See [`KeepTypes.h`][3] for more.



## Examples

Keep width of the view to be equal to 150:

```objc
view.keepWidth.equal = 150;
```

Keep top inset to superview of the view to be at least 10:

```objc
view.keepTopInset.min = 10;
```

Don't let the first view to get closer than 10 to the second from the left:

```objc
firstView.keepLeftOffsetTo(secondView).min = 10;
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
leftInsets.equal = 10;
```

However there are already some accessors to some of them:

```objc
view.keepSize    // group of both Width and Height
view.keepInsets  // group of all four insets
view.keepCenter  // group of both axis of position
view.keepEdgeAlignTo  // group of alignments to all four edges
```

See [`KeepView.h`][2] or [`KeepAttribute.h`][4] for more .



## Atomic Groups

_Atomic Groups_ are a way to deactivate multiple attributes at once. With atomic group you can quickly change one desired set of constraints (= layout) to another.

```objc
// Create atomic group
KeepAtomic *layout = [KeepAtomic layout:^{
    self.view.keepWidth.min = 320 +keepHigh; // Set minimum width limit.
    self.view.keepVerticalInsets.equal = 0; // Vertically stretch to fit.
}];

[layout deactivate];
// self.view no longer has minimum width of 320 and is no longer stretched vertically.
```

You can also deactivate them manually using:

```objc
self.view.keepWidth.min = KeepNone; // Removes minimum width constraint.
[self.view.keepWidth deactivate]; // Removes all constraints for width.
```

See [`KeepAttribute.h`][4] for details.


## Convenience Methods

For the most used cases there are convenience methods. Nothing you could write yourself, but simplify your code and improve readability. Some of them:

```objc
[view keepSize:CGSizeMake(100, 200)];
[view keepInsets:UIEdgeInsetsMake(10, 20, 30, 40)];
[view keepCentered];
```

See [`KeepView.h`][2] for more.



## Array Attributes – _What?_

Most of the methods added to `UIView`/`NSView` class can also be called on any **array on views**. Such call creates grouped attribute of all contained view attributes:

```objc
NSArray *views = @[ viewOne, viewTwo, viewThree ];
views.keepInsets.min = 10;
```

**The above code creates and configures 12 layout constraints!**

In addition, arrays allow you to use related attributes more easily, using another convenience methods:

```objc
NSArray *views = @[ viewOne, viewTwo, viewThree ];
[views keepWidthsEqual];
[views keepHorizontalOffsets:20];
[views keepTopAligned];
```

You just created 6 new layout constraints, did you notice?

See [`NSArray+KeepLayout.h`][5] for more.



## Animations

Constraints can be animated. You can use simple `UIView` block animation, but you need to call `-layoutIfNeeded` at the end of animation block. That triggers `-layoutSubviews` which applies new constraints.

Or you can use one of the provided methods so you don't need to care:

```objc
view.keepWidth.equal = 100;

[view.superview keepAnimatedWithDuration:1 layout:^{
    view.keepWidth.equal = 200;
}];
```

These are instance methods and must be called on parent view of all affected subviews. At the end of layout block this view receives `-layoutIfNeeded` method. Any changes to views out of the receiver's subview tree will not be animated.

Spring animation from iOS 7 included, animations on OS X are not supported yet.

See [`KeepView.h`][2] for more.



## Layout Guides

KeepLayout adds lazy-loaded invisible `.keepLayoutView` to every `UIViewController` in a category. This view is aligned with Top & Bottom Layout Guide and Left & Right Margins of the view controller, which means its size represents visible portion of the view controller. You can use this Layout View to align your views with translucent bars (navigation bar, toolbar, status bar or tab bar).

```objc
imageView.keepEdgeAlignTo(controller.keepLayoutView).equal = 0;
// imageView will not be covered by UINavigationBar or UITabBar
```

See [`UIViewController+KeepLayout.h`][11] for more.



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

`KeepValue` is declared as `_Complex double`, which allows seamless convertibility from and to `double`. The priority is stored as imaginary part.  
See [`KeepTypes.h`][3] for details.

Each attribute manages up to three constraints (`NSLayoutConstraint`) that are created, updated and removed when needed. One constraint for each of three relations (`NSLayoutRelation` enum) and setting `equal`, `min` or `max` properties modifies them.  
See [`KeepAttribute.m`][7] for details.

`KeepAttribute` class is a class cluster with specific subclasses. One that manages constraints using `constant` value, one for constraints using `multiplier` and one grouping subclass that forwards primitive methods to its contained children.  
See [`KeepAttribute.m`][7] for details.

Array methods usually call the same selector on contained views and return group of returned attributes.  
See [`NSArray+KeepLayout.m`][8] for details.

Animation delay is implemented as real execution delay, not just delay for animating the changes. This differs from `UIView` block animations and allows you to set up animations in the same update cycle as your initial layout.  
See [`KeepView.m`][6] for details.



---
_Version 1.7.0_

MIT License, Copyright © 2013-2016 Martin Kiss

`THE SOFTWARE IS PROVIDED "AS IS", and so on...` see [`LICENSE.md`][9] more.





[1]: https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG

[2]: Sources/KeepView.h
[3]: Sources/KeepTypes.h
[4]: Sources/KeepAttribute.h
[5]: Sources/NSArray+KeepLayout.h
[10]: Sources/KeepLayoutConstraint.h
[11]: Sources/UIViewController+KeepLayout.h

[6]: Sources/KeepView.m
[7]: Sources/KeepAttribute.m
[8]: Sources/NSArray+KeepLayout.m
[9]: LICENSE.md
