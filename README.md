
# TabBarCircle3DView

Swipe view inspired by Tinder

Run in phyical device for better clarity

## Screenshot

![Alt text](/playback.gif?raw=true "Optional Title")

```swift
@objc func longPressAction(gesture : UILongPressGestureRecognizer){

switch gesture.state {
case .began :
new.show(in: view)
case .changed:
new.panGestureForCircle(pan: gesture)
case .ended:
new.panGestureForCircle(pan: gesture)
new.dismiss()
case .cancelled,
.possible,
.failed: break
}
}
}
```

## Requirements

```
* Swift 4
* XCode 9
* iOS 9.0 (Min SDK)
```

## Author

Nicky Patson

[HomePage](http://about.me/nickypatson)

<mail.nickypatson@gmail.com>


## License

GradientSlider is available under the MIT license. See the LICENSE file for more info.

