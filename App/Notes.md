

# The Self App - IOS
Some documentation (technical and detailed) and ongoing notes by the author during the development of this project.

## Quick Summary ##
[**Skip to full documentaiton (ongoing)**](#full-documentation)
- The app project is built in XCode 10.2 and Swift 5.
- The project requires devices to be running at least IOS 12.
- The project uses CocoaPods for Dependency Management
- Current Dependencies are available in the pods file at the root of the App Directory in this GitHub Project.
- Firebase is used for dataManagement.
- This project **Does Not** use Storyboards.
- SnapKit is used for, when possible, onveniently creating constrains programatically.
- The project is split up into a M-MC-VC-V pattern (explained below) - however this is currently inconsistent.
- The project is currently being converted to use a dependency injection system and rely more on the protocol-delegate pattern to reduce coupling between objects.
- The project allows for anonymous users ot sign up initially, only requesting registration information once they complete the tutorial.
- The project uses Lottie for animations
- For static offline messages the project stores most messages in one file, allowing for easy updating.
- Daily challenges are selected for all users by a Cron job

## Full Documentation
- [**Methodology**](#programming-design--methodology)
- [**Project Structure**](#project-structure)
  - [**Overview**](#programming-design--methodology)
  - [**M-MC-VC-V**](#m-mc-vc-v)
  - [**Models**](#models-m)
  - [**Model Controllers**](#model-controllers-mc)
  - [**View Controllers**](#view-controllers-vc)
  - [**Views**](#views-v)
- [**ScreenSliderViewController**](#screensliderviewcontroller)
- [**ViewSliderViewController**](#viewsliderviewcontroller)

# Project Structure
**How the project is laid out in Xcode**

### /
The root folder, where this notes file is found, includes 6 files.
- README (quick overview, tldr - Need to know)
- Notes (This file)
- Podfile (Contains the required dependencies, used by cocoapods)
- Podfile.lock (Marks the current dependency versions the project uses)
- Self App/ (The project source files)
- Self.xcodeproj (The base Xcode project file - **Don't work from this file!**)
- Self.xcworkspace (The Xcode project file)

### /Self App/
The folder contains the app's source files. The source files are broken down into folders with a certain strucure.
- **Key files.** Files stored directly in this directory are the projects key files. This includes the AppDelegate, AppManager and initial ViewController (AppContainerViewController). 
- **Assets.**  This is where the static content of the app is stored. This contains everything from visual assets to static copy to configuratin files.
- The rest of the folders break down the source files by what they define. Within each of these folders they are broken down further.
  -  **Reusables.** Reusable files are files with generic base code that can be reused to form a specific aspect of the app. None of these files should be *final* and generally they would't be used directly in the app without being subclassed or extended. Theoretically most of this code can be reused in other projects.
  - **Final.** The files stored in the Final subdirectory are files with code that is responsible for specific parts of the app. These generally build ontop of reusables or generic imported frameworks by subclassing or extending them. They should be *final* as they shouldn't need to be subclassed or extended. If files need to be broken down further inside then they should be done so inside xcode (wiithout an actual reference folder), this helps prevent the project getting too deep.

# Programming Design + Methodology
**Overview**
This isn't necessarily "the correct" methodology or even a real methodology, but it'll help explain how this app has been developed and how the project is structured.

The chosen design pattern "M-MC-VC-V" is built on the popular MVC design and around various other design patterns (there are lots out there). 

In M-MC-VC-V, code is distinguished into 2 categories: It either concerns handling **Data** *(Model)* or handling **Interaction** *(View)*. These sections are then distinguished again as either **Defining Code** *(Itself)* or **Method Code** *(Controller)*.

## "M-MC-VC-V"
**What's what?**
*Model* -- If the code is defining the structure, properties or type of an object the user won't see or directly interact with then it is Model code. An example would be code that defines an object called "Message" with a property called sender and a property called messageText. You could also think of the Model as being brain cells that each hold some information.

*Model Controller* -- If the code is defining how to process or create something the user won't directly see or interact with then it is Model Controller Code. This code manages the model, it creates the model themselves and contains methods that make the data it holds useful. An example might be code that defines a method called sendMessage, which requires a Message parameter. You could also think of this as being the brain itself, which makes use of brain cells to do stuff.

*View Controller* -- If the code is defining how to navigate, display or what to do when the user interacts with something then it is View Controller code. This code manages views, first creating it but also defining methods to give the views content, control what they do, user interactions and navigation. An example might be code that creates a screen where the user types out a message, this holds a textboxView and a buttonView as well as an instance of the messageController so that when the user clicks the button it can create a message and access the sendMessage method. You could also think of this as being the body's muscles, which control the muscles *(Views)* themselves and also tells the brain *(Model Controller)* what it detects.

*View* --  If the code is defining the structure, properties or type of something the user will see or directly interact with then it is View code. This code is 100% of what the user sees, and is created and initialised by View Controllers. An example would be the button and textbox described above. The views have no methods, when you tap on them they have no idea what to do, they just tell the View Controller that they got tapped on. As described above, you can think of Views as being the individual parts of the body themselves, which are useless without muscles and the brain.

**There's more...**
The Model and View rely on their respective controllers to create them and bring them into the context. They cannot talk to each other, and would have no way of doing so without methods. Within the app, the Controllers are where most of the talking happens, View Controllers tell the Model Controllers what they need and what to do and Model Controllers can tell the View Controllers when to do something.

However whereas the View Controller is required to have an instance of the Model Controller, the Model Controller never has an instance of the View Controller. This means that the View Controller is still the heart of the front-end program, because it's the origin of most processes and what the user interacts with. The View Controller is in charge of bringing together the Views it needs as well as holding in instance of the Model Controller so that it can access the Model it needs.

The View Controller also handles displaying the next appropriate View Controller and passing on the required Model Controller (but not the model itself, the model can't exist without the controller).

Where the View Controller is the front-line for the user, the Model Controller is the back-end for the Data. It is responsible for connecting, retrieving and setting data from sources such as databases as well as observing remote API's and listening for updates and notifications. The View Controller can never connect directly to a database. Just like how The Model Controller has no awareness of what the user is doing aside form what the View Controller tells it, the View Controller doesn't know or care where the data is coming from. This is also great for testing as it means Models and Views can be tested independently.


## "Why distinguish them"

Distinguishing your code in this way helps you break down the responsibilities of each part, providing safety and guarentees.

### Models (M)
**'The Data'** -- A Model is an object containing multiple types of data that, when combined, describe something more significant.

**-- Key points**
- The Model is absolute, it doesn't know or care about the context around itself (such as what's asking for it or how it's going to be used), all it knows is what data it contains.
-- *This means it's more versatile and can be used in different contexts.*

- Models can guarantee it has a valid type for each of its properties.
-- *This means methods and views that use the model's properties won't have to perform any checks, making the code cleaner.*

- Model properties can't be optional.
-- *This helps keep the model valid for all use cases. (see above).*
-- *Models can define appropriate defaults for missing data.*
-- *If a context can only provide partial data for the model then either:
-- -  A) The data should be stored as a Dictionary or Tuple until it is valid and can instantiate the model, 
-- - B) If it's a recurring problem, a new model should be built to store the partial version of the model.*

- Models contain no methods.
-- *Functionality and processing of the data is kept with Model Controllers.*

- Models are Dry and convenient
-- *Grouping data into models makes it more convenient to pass them around the various methods and views that might need them. It also helps make your code DRYer and therefore safer (because you're less likely to forget a property or miss-type something) and cleaner (because you don't need to retype everything constantly.) *


**Model Example:**
```swift
struct Emotion {
    var name: String
    var adj: String=
    var valence: Double
    var arousal: Double
}

extension Emotion {
    init(_ emotionDictionary: [String:Any]) {
        self.name  = emotionDictionary["name"] as! String
        self.adj = emotionDictionary["adj"] as! String
        self.valence = emotionDictionary["valence"] as! Double
        self.arousal = emotionDictionary["arousal"] as! Double
    }
}
```

### Model Controllers (MC)
**'Handling Data'** --
- Model Controllers

### View Controllers (VC)
**'User Interaction'** -- 
- Controls the View
- Child View Controllers

### Views (V)
**'What you see'** -- 
- A View is any physical object on the screen.
- The view will explain how to present the data it's given.
- Views know nothing about anything except what it is.

## "Expanding M-MC-VC-V"

As well as their basic forms, each part of the M-MC-VC-C model can be buil as collection flavours of themselves. Most of the time collections will be used.

Collections group together objects of the same type and help seperate code out. This increases usability, for example views and models can be built into smaller, generic objects that can be reused in different contexts.

For example a tag model could include only a name and uid property. This Model remains generic which means it could then be used in a StatusUpdate Model and also a Product Model, where they could then be used as-is or expanded.

The Model Controller can also be used in this way. For example in this project a class exists that manages Actions, this class includes methods that retrieve actions from the database 

## "Structs and Classes in Self"

Structs are value types and classes are reference types.

What this means is that when a class is initialised as a property, a reference is created to the original class. From then on when it can be set and passed around and if a reference to that class instance is ever updated, every other reference of the same instance is also updated.

By contrast when structs are initialised and set as a properties, if they are then mutated (such as updating a name) or set as new properties (when injecting into a view controller) a new copy of the steuct is created. This means that if a struct is created that stores the users name, and the user then updates that name in settings, it won't automatically update on the home page as that page still holds the values of the original struct.

Value types such as structs can be useful for storing objects that represent physical, generally immutable, obajects. It means that when you update a struct it isn't updated everywhere, making it easier to keep track of responsibilities. If a struct does need to change the value of its instances then a mitating method can be used.

Another advantage of using structs is that they come with built in initialisers, which makes smaller, more 'raw' objects easier to initialise. Although generally another initialiser is needed to create the instance from a dictionary or Firebase Snapshot.

By contrast if a class is responsible for keeping track of and maintaining state or needs to capture updates from a delegate or controller then it makes more sense to use classes as these can be more flexible and easier to manage without every method needing to be specified as mutating.

# ScreenSliderViewController
**Subclass of UIPageViewController**

This class is used to create the slide onboarding screens. *It is one of the more extensive viewcontrollers and currently considered a "Massive view Controller". It needs to be refactored.* 

It is designed to be subclassed for it's various uses (For example currently it is subclassed as an OnboardingSliderViewController for the onboarding flow and as a MoodLoggingSliderViewController for the mood logging flow). After being subclassed and set up alongside a protocol to send it the data collected during the flow it is more or less plug and play.

The screens of the Slider are only required to be UIViewControllers, so most existing ViewControllers cna be easily used withint he Slider.

The UIPageviewController comes with a built in Scrollview and UIPageController which can be configured using it's properties. Any children can configure these to show or hide them as or before their *viewDidAppear/viewWillAppear* override methods. This allows them to be hidden when they aren't neccesary or when they can't be used (for example until data is entered, as seen int he mood logging sequence)

The children can also enable or disable forward and backward navigation (disabling any attempt to manually scroll or send the user to the screen using the *goForward* method. This can be used to disable progression when data isn't valid, as seen on the Onboarding and Mood logging flows.

Alternatively you can also configure the *gestureSwipingEnabled* property to just enable or disable the users ablity to swipe to the next screen. You can then manually send the user to screens.

The SliderViewController will also automatically position the UIPageIndicator and buttons for if you set it's navigationDirection to horizontal or vertical.

## ViewSliderViewController
If you wish to only include views in a slider format (for example if their only function is to present information and not be interactive) then you might consider using the *ViewSliverViewcontroller* instead. As oppose to being built ontop of the UIPageViewController this class is a subclass of UIView with an included paged ScrollView and UIPageIndicator. It has similar functionality to the ScreenSliderviewController but it more lightwait and accepts an array of UIVIews as it's screen property. 

You might consider enabling looping on this, adding a gestureRecogniser on the last screen or making use of it's delegates scrolledPastLasSlide method to process and action when the user gets to the end. This is done on the onboarding screen int he app to send the user to the next ScreenSlider screen when the ViewSlider is finished (and most of the time works pretty seemlessly).
