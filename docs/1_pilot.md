
# Complete Movie App — Pilot (1)



Hey, Glad that you’re here.

I am bringing a series of videos and articles for you to teach you how to build an **Industry Standard Flutter Application** from scratch. I am also putting up companion articles. 

In this series, you’ll learn basic as well advanced topics in Flutter. At the end of this series, you’ll have successfully built an industry standard application with **very good UI** and a **scalable code-base** with some excellent coding practices.

You’ll use some of the basic and most commonly used **Widgets** and **Plugins**, as well as you’ll also work on some useful animations, **complex** widgets and state management techniques, preferably **BLoC**.

Over the series of articles and videos, I’ll show you how to implement clean architecture, bloc, API calls, error handling, hive storage, dependency injection, language management and many more important things needed to create an application.

You’ll create a responsive mobile application that doesn’t pixel out on various mobiles of different densities and resolutions. Since, the design that I have in hand is for Mobile Portrait, hence this app will not support landscape and web versions. That means, this app can run on landscape mode and browser, but will render its components in a bad way.

Having said that, if you need to learn landscape and web version of this application, do let me know and I will try to create a design that works on landscape and web.

So, Let’s get started.

## What are we building?

It would be too verbose here to explain each and everything in the article, it would be much easier for you to see the final outcome yourself. Please visit the video and comeback again. **TODO — YOUTUBE LINK(EXACT MINUTES)**

## How are we building?

Developing apps in Flutter gives you free hand to choose the architecture and libraries. With so many options in your hand you’ll often donate a lot of your time in selecting a specific architecture. Most popular and trustworthy architecture is Clean architecture, where you’ve separate layers for Presentation, Domain and Data.

That’s why, I will also teach you how to build application using Clean architecture.

Let’s create some folders and files. First, you’ll go to terminal and run the command

<iframe src="https://medium.com/media/6171fb705d3e30b5085d56e767afeebe" frameborder=0></iframe>

This will create an empty Flutter project with **lib** folder.

![](https://cdn-images-1.medium.com/max/3328/1*esmoy-gRrDzrDr2f2MN_cg.png)

### Presentation Layer

We all love making UI in Flutter, and it wouldn’t be wrong to say that one of the primary reasons people have switched to Flutter is the ease with which you can create cool and flexible UIs. While, it is easy to write Flutter widgets, it is even easier to put business logic and taking critical decisions in your widgets.

Presentation Layer mainly consists of Widgets. Many widgets combine together to create a screen. A screen in Clean architecture is considered as **Journey.** For example, when user moves to Movie Detail Screen, he/she is supposed to be in Movie Detail Journey.
> Create **presentation** folder in **lib** directory. Inside **presentation** folder, create **journeys, widgets, blocs** and **themes** folders.

**Journeys** will contain user journeys like Home Screen, Movie Detail, Watch Trailers Screen, Favorite Movies Screen, Navigation Drawer, Loading Screen. Each of these journey will surely have a screen dart file and small widgets that will be used in making the screen.

**Widgets** folder in presentation folder will consist of small UI building blocks which will be used throughout your application across different screen like Button, Logo, App Bar, and so on. You’ll see more as we go in these series.

**Blocs** will be heart of your UI, where you’ll make decisions about what and when to show in the UI. For example, till the time movie details are fetched from API, UI will show a loader and once details are fetched from the API, you’ll see the movie details on the screen. More on that, when we go in depth of each of these things.

All the **themes**, be it Text styles, colors, button themes, dialog themes will go in Themes folder. So, there will be one place to maintain all theme related information.

### Data Layer
> Create **data** folder in **lib** directory. Inside **data** folder, create **data_sources, repositories, models, tables and core** folders.

Data Layer is exposed to outside world, whose sole responsibility is to bring data from Rest APIs, Local Database or Firebase, basically any service that gives data to your application.

Based on the application features, different APIs and local database that it has to fetch data from, you can have as many **DataSources** as required. Each of them will only interact with repositories.

**Repositories** will make decision whether to fetch data from remote data source or local data source, behaving as a single source of truth for the UI. UI should not know from where the data is fetched. In Data Layer, repositories will be implementations of repository abstract classes from the domain layer. More on that, in Domain Layer section.

**Models** and **Tables** are again extensions of the entities present in Domain Layer. Models are mapped directly with the API response and Tables are directly mapped with Database response. You’ll learn more about them, when we start actual coding.

You’ll create a **Core** folder as well, to segregate common code of fetching and parsing remote data.

### Domain Layer

Now, you’ve one layer for UI interaction and other for API interaction. Domain Layer acts as a communication channel between Data Layer and Presentation Layer.
> Create **domain** folder in **lib** directory. Inside **domain** folder, create **entities, repositories, usecases** folders.

**Entities** represent data that will be required by the UI. These entities will be extended by Models and Tables in Data Layer, to maintain a level of abstraction.

**Repositories** in domain layer are abstract classes which only tell what data has to fetched. But, the decision of how and from where data has to fetched, is made by the repository implementations in Data layer.

**UseCases** consists of the features that the app will work on. Like, fetching popular movies, trending movies, movie details, etc. UseCases are simple classes that directly pass the input parameters required to fetch details to the repository. UseCase will directly interact with the blocs. You’ll understand more when we actually start coding.

### DI
> Create **di** folder in **lib** directory.

Here you can keep the injectors which will be used throughout the application by any of the layers.

### Common
> Create **common** folder in **lib** directory.




