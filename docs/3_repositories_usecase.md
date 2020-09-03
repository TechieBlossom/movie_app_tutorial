# Repositories and Usecases

Hello, Welcome back.

We are building a Movie App with best coding practices and tools out there. In previous article, datasource doc, I have explained how to create data source and how to make API calls.

In this article, I will show how you can create repositories and usecases to separate data layer with UI layer by introducing domain layer, with the help of abstraction.

## Problem
You have seen in previous article, that we were calling data source from **main.dart**, which is your UI layer. In a long run, this is not right and certainly needs a layer in between. Also, what this does is, it tighly couples the UI layer with API responses, which can change over the time and you'll end up making changes to data layer as well as UI layer.

## Solution
We will create repositories in domain layer and they will make decisions to fetch data either from remote data source or local data source. We will also create usecases, basically one usecase for one API or one feature. We'll also create common error classes which will be returned from repository layer and used by UI layer. I'll show you how you can use **dartz** package to reduce some of the boilerplate code while dealing with common error messages and also clean up some logic written in the repository.

Well, a lot being said, let's get into action.

## Create Abstract Repository
> In **domain/repositories** folder, create a file **movie_repository.dart**

Create an abstract class `MovieRespository`

```dart
abstract class MovieRepository {
  Future<List<MovieEntity>> getTrending();
}
```

This class will have one method to return Future of List of Movies.

## Implement The Repository
> In **data/repositories** folder, create a file **movie_repository_impl.dart**

Create a class `MovieRepositoryImpl` that extends `MovieRepository`

```dart
class MovieRepositoryImpl extends MovieRepository {
  //1
  final MovieRemoteDataSource remoteDataSource;

  //2
  MovieRepositoryImpl(this.remoteDataSource);

  //3
  @override
  Future<List<MovieModel>> getTrending() async {
    //4
    try {
      //5
      final movies = await remoteDataSource.getTrending();
      return movies;
    } on Exception {
      return null;
    }
  }
}
```

1. You'll need remote data source to make the API calls that we discussed in the previous article. Additionally, you can have local data source as well, that will fetch data from local DB. 
2. A constructor with the remote data source as its parameter.
3. Since, you've extended this class from `abstract` class, you will implement the methods here. Notice, you can change the MovieEntity to MovieModel in the implementation, to separate the layers. Also, add async in the function definition.
4. In `try/catch` block, you'll make API call to handle any error that is thrown by the API.
5. Fetch the trending movies and return them.

## Call the Repository Method
Open **main.dart** and create instance of MovieRepository and call the getTrending method. You already have `ApiClient` and `MovieRemoteDataSource`.

```dart
MovieRepository movieRepository = MovieRepositoryImpl(dataSource);
movieRepository.getTrending();
```

Run the app. This will work as it worked before when we used data source. But, doing so will not be scalabale. Your UI will have to decide which repository to call to perform certain action. And sometimes, it can be 2-3 calls to perform certain actions, so UI will have to decide to make those calls. 

And, UI will always have too many widgets to deal with, so putting this logic in UI is not good. Thatswhy, we'll have usecases to simplify code at UI layer.

## UseCase

As I mentioned in the Pilot article, usecases are the features that the app will work on. Like, fetching popular movies, trending movies, movie details, etc. UseCases are simple classes that directly pass the input parameters to fetch details to the repository. UseCase will directly interact with the blocs.

> In **domain/usecases**, create a file **get_trending.dart**

Create a class `GetTrending`.

```dart
class GetTrending {
  //1
  final MovieRepository repository;

  //2
  GetTrending(this.repository);

  //3 
  Future<List<MovieEntity>> call() async {
    //4
    return await repository.getTrending();
  }
}
```

1. This class will accept `MovieRepository` as final variable
2. Create constructor, that will have `MovieRepository`.
3. `call` method is already present in all dart objects. So, creating a method with **call** name, allows you to call this method just with the instance of the class. We'll see this in just a moment.
4. You'll call getTrending method from repository here. This returns the list of movies.

Open **main.dart** and this time instead of calling `getTrending()` from repository, instantiate `GetTrending` class with `movieRepository` as its parameter. Then, simply call the instance of `GetTrending`:

```dart
GetTrending getTrending = GetTrending(movieRepository);
getTrending();
```

When you run, there is absolutely no difference in the output.

## Error Handling - Problem
What will happen when instead of proper list of movies, the API call has returned with error. As you recall from the call in `MovieRepositoryImpl`, I returned `null` in case of exception. There are two problems with this approach:

1. To show on UI based on null, you'll have to check null values wherever you call the usecase. This will be tedious when the app grows. 
2. Also, there will be only two possibilities of usecase to return, either `List<MovieEntity>` or `null`. With null, you can only show one generic message to the UI, so how you'll show different messages to UI based on the type of error from API. 

```dart
if (movies != null) {
  /// show UI widget to display list of movies
} else {
  /// show generic error message
  /// or
  /// do nothing
}
```

## Error Handling - Solution
Use **dartz** plugin. This plugin is awesome and at first it is hard to understand, but there is a very simple underlying concept.

> Return Left when error, Right when success. Left and Right are object/data holders.

Let's add **dartz** dependency in **pubspec.yaml**

```yaml
dartz: ^0.9.1
```

Run pub get command to update the dependencies.
```bash
flutter pub get
```

Now, update `MovieRepository`. Open **movie_repository.dart**.
Change the dependency of getTrending method to return `Either` type, with left as `AppError` and right as List of `MovieEntity`.

```dart
Future<Either<AppError, List<MovieEntity>>> getTrending();
```

AppError is a class that just holds a error message.
> In **domain/entities** folder, create a file **app_error.dart**

Create a class `AppError` and extend it with `Equatable`

```dart
class AppError extends Equatable {
  //1
  final String message;

  const AppError(this.message);

  //2
  @override
  List<Object> get props => [message];
}
```
1. Declare field with String type, that will hold any error message.
2. Override `props` method to hold `message`, if required to compare at later stage.

Let's get back to repositories. We've updated the declaration of `getTrending()` in abstract class, so by this time implementation of `MovieRepository` has errors. Let's correct them by updating the signature.

```dart
@override
//1
Future<Either<AppError, List<MovieModel>>> getTrending() async {
  try {
    final movies = await remoteDataSource.getTrending();
    //2
    return Right(movies);
  } on Exception {
    //3
    return Left(AppError('Something went wrong'));
  }
}
```

1. Update the method signature same as `MovieRepository`'s and again change `MovieEntity` to `MovieModel` to maintain level of abstraction.
2. When API has returned with success, wrap the response with `Right`, in this case wrap movies in `Right`.
3. In case of Exception, you can return `AppError` with wrapping with `Left`.

Last thing before we run this is, update the UseCase as well.
You only have to change the signature of the `GetTrending`'s `call` method.

```dart
Future<Either<AppError, List<MovieEntity>>> call() async {
  return await repository.getTrending();
}
```

Open **main.dart** and read the response of `getTrending()`. As you'll read the response of a Future returning method, you need to right await. Also, add async to the main function.

```dart
void main() async {
  ApiClient apiClient = ApiClient(Client());
  MovieRemoteDataSource dataSource = MovieRemoteDataSourceImpl(apiClient);
  MovieRepository movieRepository = MovieRepositoryImpl(dataSource);
  GetTrending getTrending = GetTrending(movieRepository);
  //1
  final Either<AppError, List<MovieEntity>> eitherResponse = await getTrending();
  //2
  eitherResponse.fold(
    (l) {
      //3
      print('error');
      print(l);
    },
    (r) {
      //4
      print('list of movies');
      print(r);
    },
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //5
      home: Container(),
    );
  }
}
```

1. Create a final variable to hold the response of `GetTrending`'s `call` method.
2. Use `fold` operator to get either of left or right value. Only, one will be returned at a time.
3. When its an error, `left` will be called and print the message.
4. When its a success, `right` will be called and prints the movies.
5. Since, **dartz** plugin also contains `State` class, you'll have error using it with in a file having stateful widget. This is not a problem, because you'll call usecases from **Blocs** only.

## More UseCases
As in our last part, we had created 3 more methods in the data source, let's create usecases for all of them and methods to repositories as well.

Open **movie_repository.dart** and add 3 more methods for popular, playing now and coming soon movies:

```dart
Future<Either<AppError, List<MovieEntity>>> getPopular();
Future<Either<AppError, List<MovieEntity>>> getPlayingNow();
Future<Either<AppError, List<MovieEntity>>> getComingSoon();
```

Open **movie_repository_impl.dart** and override the 3 methods:

```dart
@override
Future<Either<AppError, List<MovieEntity>>> getComingSoon() async {
  try {
    final movies = await remoteDataSource.getComingSoon();
    return Right(movies);
  } on Exception {
    return Left(AppError('Something went wrong'));
  }
}

@override
Future<Either<AppError, List<MovieEntity>>> getPlayingNow() async {
  try {
    final movies = await remoteDataSource.getPlayingNow();
    return Right(movies);
  } on Exception {
    return Left(AppError('Something went wrong'));
  }
}

@override
Future<Either<AppError, List<MovieEntity>>> getPopular() async {
  try {
    final movies = await remoteDataSource.getPopular();
    return Right(movies);
  } on Exception {
    return Left(AppError('Something went wrong'));
  }
}
```

The other 3 methods are carbon copy of the `getTrending()`, only change will be what method they will invoke from the data source. And, in this case, it's no brainer, because names of the methods in data source and repository are same.

You can change what message to return in case of error in each of the methods.

Duplicate the `GetTrending` UseCase 3 times and name them `GetPopular`, `GetPlayingNow` and `GetComingSoon`.
In `call()` call the respective methods from repository:

For `GetPopular` call `getPopular()`

For `GetPlayingNow` call `getPlayingNow()`

For `GetComingSoon` call `getComingSoon()`

***

## Caveat
Imagine you're the sole developer in this project and you know everything about how to create UseCase and what does the `call()` method in usecase does. But, months later or years later, another couple of developers join you and they want to create UseCase. Will they remember to make `call()` method in the usecase. Probably not. They could end up creating a method with different name and start calling the method instead in the Blocs. This will bring 2 different set of ways for implementing exact same thing. This is not good for code consistency in a long term.

## UseCase Abstract Class
> In **domain/usecases** folder, create a file **usecase.dart**.

Create an abstract class `UseCase`

```dart
//1
abstract class UseCase<Type, Params> {
  //2
  Future<Either<AppError, Type>> call(Params params);
}
```

1. UseCase class takes 2 generics - `Type` that says **what will be the success response type** and `Params` that says **what are the parameters to make API calls**.
2. You can relate this signature, as it is same as `GetTrending`'s. Except that, now it is generic for any returned object and any type of parameters.

This type of code is very important in bigger projects for maintainability.

> It is difficult to future proof code with assumptions, so it might be hard for you to completely understand the things right now. Let me explain with the help of  examples.
>
> Till now we've created 4 usecases all returning `List<MovieEntity>`. In future, you'll return `MovieDetail`, `List<CastEntity>`, etc. So, specifying in the UseCase definition itself, what it will return will be good.
>
> Till now we've called APIs without any extra parameter other than TMDb API Key. In future, you'll search movies by query text and call movie detail api with Movie ID, then you'll require the `Params` as well. 
>
> For calling APIs with Params, you'll create separate classes to hold Params for APIs that require query parameters. For those API's that don't require query parameters, we'll create `NoParams` class.

> In **domain/entities** folder, create a file **no_params.dart**.

Create a class `NoParams` extending `Equatable`:
```dart
class NoParams extends Equatable {

@override
  List<Object> get props => [];
}
```

## Update Usecases
> Extend all the usecases with `UseCase` class

```dart
//1
class GetTrending extends UseCase<List<MovieEntity>, NoParams> {
  final MovieRepository repository;

  GetTrending(this.repository);

  //2
  @override
  //3
  Future<Either<AppError, List<MovieEntity>>> call(NoParams noParams) async {
    return await repository.getTrending();
  }
}
```

1. Define the Type that `GetTrending` will return and Parameters that it takes(if any)
2. Add `@override` annotation as now it is declared in parent `UseCase` class.
3. `call()` now takes in `NoParams`, as explained before, this will change based on type of API call being made.

> Repeat these steps for the other 3 usecases. Absolutely, no brainer in that.

You can try running after making these changes, absolutely nothing will change as far as output is concerned. But, you need to now change the `getTrending()` in **main.dart** to `getTrending(NoParams())`:

```dart
final Either<AppError, List<MovieEntity>> eitherResponse = await getTrending(NoParams());
```

This was all about creating repository and usecases.
