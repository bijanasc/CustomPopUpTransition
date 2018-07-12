# CustomPopUpTransition
Simple custom PopUp ViewController transition animations.

![Alt text](readme_assets/popup_demo.gif?raw=true "Title")

While developing my first iOS app [Rhythm](https://itunes.apple.com/us/app/rhythm-daily-fasting-tracker/id1377199450?) I wanted to be able to display a PopUp Controller modally from the Home ViewController. The app is using a TabBarController as its RootViewController. What I attempted at first was to just simply present the PopUp Controller from the Home ViewController using the default transition animation. When I presented the PopUp ViewController the Controller slid up from behind the TabBar. After some research I found the problem was that I wasn't setting the modalPresentationStyle proprty for the PopUp ViewController. Setting the modalPresentationStyle property to .overFullScreen and also setting the .definesPresentationContext property of the Home ViewController to true solved the sliding up behind the TabBar problem.

```swift
let vc = CustomPopUpController()
vc.modalPresentationStyle = .overFullScreen
self.definesPresentationContext = true
self.present(vc, animated: true, completion: nil)
```

Next I wanted to dim and blur the background behind the PopUp so I created a new view and added it as a subview to the main view and then added the PopUp view as its subview. I set the dimView background color to black with a alpha of 0.3 and added a BlurEffectView to dimView view as well. This dimmed and blurred the background but it doesn't look good when presenting since the dimmed and blurred view slides up with the PopUp as well. I wanted the background behind the PopUp to not slide up and to be visible immediately and just for the PopUp to slide up. So after some more research I realized I had to present the CustomPopUp ViewController without a transition animation. So withing the present() method I sent animated to false.

```swift
self.present(vc, animated: false, completion: nil)
```

Inside my CustomPopUp ViewController I needed to animate the the PopUp View when the ViewController is presented. The easiest way I've found to animating views is using NSLayoutConstraint variables. I created a NSLayoutConstraint class variable inside of the CustomPopUp ViewController. 

```swift
private var popUpViewCenterYAnchor: NSLayoutConstraint?
```
Inside of viewDidLoad() I set the popUpViewCenterYAnchor variable equal to the topAnchor for the PopUp view which was constrained to the main views bottomAnchor and I set the variable to active.

```swift
popUpViewCenterYAnchor = popUpView.topAnchor.constraint(equalTo: view.bottomAnchor)
popUpViewCenterYAnchor?.isActive = true
```
This way the PopUp view is initially totally constrained under the main view and not visible. Now I needed to determine where I wanted the PopUp view to animate to. So I set the popUpViewCenterYAnchor vartiable to inactive and then set the variable equal to the centerYAnchor of the PopUp view which was constrained to the centerYAnchor of the main view. I also added a constant of -25. This constrains the PopUp view slightly higher than vertically center which I think looks great.

```swift
popUpViewCenterYAnchor?.isActive = false
popUpViewCenterYAnchor = popUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25)
popUpViewCenterYAnchor?.isActive = true
```

Now to finally animate the PopUp view. I chose to attempt to animate the PopUp View inside of viewDidAppear() since this method is called after viewDidLoad() has been called and setup our initial view constraints. The magic happens when you place the self.view.layoutIfNeeded() function inside an animation block.

```swift
UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()          
}, completion: nil)
```
Awesome! The PopUp view now animates when presented but the dimView behind the PopUp view doesn't look good when the ViewController is presented because it appears immediately which is what we want but it would look much better if it faded when the PopUp is sliding up. To achive this I set the dimViews alpha to 0 before animating it and inside viewDidAppear() I animated the dimViews alpha back to 1 inside of a seperate animation block.

```swift
UIView.animate(withDuration: 0.3, animations: {
            self.dimView.alpha = 1
})
```

And that's it! Download the Xcode project to check it out for yourself. You will see how to properly dismiss the CustomPopUp Controller by reversing the animations inside a custom function and using one of the reversing animation completion blocks to call dismiss(). Also, you can change the slide up transition animation to whatever you like by modifying the NSLayoutContraint variable or add additional variables to make more complex transition animations.

I hope this project can help some of you out there. Happy coding :)
