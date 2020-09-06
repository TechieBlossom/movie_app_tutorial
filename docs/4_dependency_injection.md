## Dependency Injection
Welcome back,

We are building a Movie App with the best coding practices and tools out there. In previous articles, [Datasources](https://medium.com/p/91e3a38ae525) and [Repositories & UseCase](https://medium.com/p/795df9a6a02e), we've created many classes and instantiated them directly in **main.dart**.

In this article, we'll see what is **Dependency Injection(DI)**, why we need DI and how can we introduce DI in Flutter application.

## What is Dependency Injection?
Before we understand DI, let's see what is a **Dependency** first. In very simple terms, when a class A needs class B to perform its operations, then class A is dependent on class B and class B acts as a dependency for class A.

Let's see what is dependency and what is dependant in our code so far. Look at the below code:
```dart
ApiClient apiClient = ApiClient(Client());
MovieRemoteDataSource dataSource = MovieRemoteDataSourceImpl(apiClient);
MovieRepository movieRepository = MovieRepositoryImpl(dataSource);
GetTrending getTrending = GetTrending(movieRepository);
```

Here are the dependencies and dependants:
1. `ApiClient` depends on `Client`
2. `MovieRemoteDataSource` depends on `ApiClient`
3. `MovieRepository` depends on `MovieRemoteDataSource`
4. `GetTrending` depends on `MovieRepository`

For every usecase call, you'll have to instantiate all its dependencies like above. This is an overhead and a waste of productive hours for any developer. Not only this is a waste of time, but it might also lead to creating some objects multiple times at multiple places which can lead to consume more memory.

How good it will be if we can rely on some separate dependency provider to provide us with the correct type of dependency whenever required? This dependency provider will also maintain lazy initializations as well as single instances throughout the application.

There are many plugins in Flutter created by the open source contributors for the exact same purpose. We'll use the **get_it** plugin in this series.

### GET_IT
> Open **pubspec.yaml**, add the below dependency and run `flutter pub get` command

```yaml
get_it: ^4.0.2
```

> In the **di** folder, create a new file **get_it.dart**

Import `get_it` library, and get the static instance of GetIt in a variable:
```dart
import 'package:get_it/get_it.dart';

final getItInstance = GetIt.I;
```

For the rest of the code in the application, we'll now use `getItInstance`. In our second article/video, we made network calls, so let's start with that first.

Add the below code in the **get_it.dart** to initialize `Client` from **http**:

```dart
getItInstance.registerLazySingleton<Client>(() => Client());
```

1. `<Client>` tells **GetIt**, what type of object to register.
2. `()` is the factory function, that returns the type `Client`
3. `=> Client()` actually initialises the data source. This is the way, we tell **GetIt** what to initialize.
4. `registerLazySingleton` will initialize the instance of `Client` when it is first used in the app.

`ApiClient` depends on `Client`, so let's add that too in **get_it.dart**:

```dart
getItInstance.registerLazySingleton<ApiClient>(() => ApiClient(getItInstance()));
```

1. `getInstance()` in `ApiClient(getItInstance())` resolves the dependency for ApiClient.

> As, we've asked **GetIt** to initialize `Client` for us, so we rely on `getItInstance()` to provide `Client` to `ApiClient` instance.

`MovieRemoteDataSource` depends on `ApiClient`, so let's add that in **get_it.dart**:

```dart
getItInstance.registerLazySingleton<MovieRemoteDataSource>(
  () => MovieRemoteDataSourceImpl(getItInstance()));
```

Till now, I've shown only the `registerLazySingleton()` method of **GetIt**, but there are other methods too. We'll see them in the coming articles. Since, the `Client`, `ApiClient`, and `MovieRemoteDataSource` are used throughout the application, so they should have only one instance throughout the application.

## Remaining Instances
Let's declare Repository and UseCases. Open **get_it.dart** and declare:

```dart
//1
getItInstance.registerLazySingleton<GetTrending>(() => GetTrending(getItInstance()));
getItInstance.registerLazySingleton<GetPopular>(() => GetPopular(getItInstance()));
getItInstance.registerLazySingleton<GetPlayingNow>(() => GetPlayingNow(getItInstance()));
getItInstance.registerLazySingleton<GetComingSoon>(() => GetComingSoon(getItInstance()));

//2
getItInstance.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(getItInstance()));
```

1. All UseCases are dependent on `MovieRepository`, that will be resolved by **GetIt**.
2. `MovieRepository` depends on `MovieRemoteDataSource`, that will be resolved by **GetIt**.

We're done with adding all the objects in **get_it.dart**, let's use them in **main.dart**.
Open **main.dart** and instead of a lot of initialisations we did in the previous articles, this time only use `GetTrending` from `getItInstance` now:

```dart
//1
import 'package:pedantic/pedantic.dart';
//2
import 'di/get_it.dart' as getIt;
//3
unawaited(getIt.init());
//4
GetTrending getTrending = getItInstance<GetTrending>();
```

1. With the help of Pedantic package, you can use `unawaited` that will allow the app to not wait for GetIt initialisation to happen before launching its first frame.
2. Import get_it file that we created.
3. Use `unawaited` and call the `init()` method to initialize **GetIt**
4. Give the type of instance you need, like we need `<GetTrending>` here.

Now run the app and again there is no difference in the output. You'll see list of trending movies in the console.

GetIt injects the dependency required for us. This was all about using GetIt for Dependency Injection. See you in the next part of the series.