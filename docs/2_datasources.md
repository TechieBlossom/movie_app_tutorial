# Data Source

Hello, Welcome back.

We are building a Movie App with best coding practices and tools out there. In previous video, I have explained how our folder structure is going to be and we will use Clean architecture concepts.

### Create TMDb API Key

Since, we are using TMDb API to fetch the movies, let's first create TMDb API Key. Open [https://www.themoviedb.org/login](https://www.themoviedb.org/login) and register or login on the website.

Once logged in, you can go to settings by visiting [https://www.themoviedb.org/settings/account](https://www.themoviedb.org/settings/account). From left side menu, open **API** section and copy the value under **API Key \(v3 auth\)**. Also, read the URL of **Example API Request** because you'll need the base url while making the API calls.

Open project and create a file **api\_constants.dart** in **data/core folder** and place the below code:   


```dart
class ApiConstants { 
  //1
  ApiConstants._();
  
  //2
  static const String BASE_URL = "https://api.themoviedb.org/3/";
  //3
  static const String API_KEY = "f33521953035af3fc3162fe1ac22e60c";
  //4
  static const String BASE_IMAGE_URL = "https://image.tmdb.org/t/p/w500";
}
```

1. Since this class should not be instantiated from outside, you should declare its constructor as private.
2. This URL will always be prepended before specific URLs.
3. You'll also put the API key in this file. I recommend, that you create your own because I may turn it down after this series.
4. The image paths that you get from TMDb API are in this format **zuW6fOiusv4X9nnW3paHGfXcSll.jpg.** In order to load images you've to prepend the `BASE_IMAGE_URL`.

### TMDb API Response

Head on to [https://developers.themoviedb.org/3/](https://developers.themoviedb.org/3/) and select **TRENDING** from left menu. On the right side, you can see the details. You can explore more on this, but 2 things that are very important are `media_type` and `time_window`. As this is a movie app, media type will be movie and you can select time window as day. Open **Try It Out** tab and select movie as `media_type`, day as `time_window` and put the API key in the API field. Now, you can press **SEND REQUEST** button and you'll see the request and response. You can read the whole URL and verify the **BASE\_URL**. 

Let's copy this response and create dart model from it. Open [https://javiercbk.github.io/json\_to\_dart/](https://javiercbk.github.io/json_to_dart/) and paste the response in the text box. Name the class as **MoviesResultModel.**

Create a dart file **movies_result_model.dart** in **data/models** folder and paste the code generated from jsonToDart. Have a look at the fields that are created. The class generated has a list of movies. As I will not be showing you pagination, so you can delete fields related to pagination like **page**, **totalPages** and **totalResults**. To further simplify code, you can take out `Results` class out of this file and create a separate file named **movie_model.dart** in **data/models**. Here are the two classes that you'll have:


```dart
class MoviesResultModel {
  final List<MovieModel> movies;

  MoviesResultModel({this.page, this.movies});

  factory MoviesResultModel.fromJson(Map<String, dynamic> json) {
    List tempMovies = new List<MovieModel>();
    if (json['results'] != null) {
      json['results'].forEach((v) {
        tempMovies.add(MovieModel.fromJson(v));
      });
    }

    return MoviesResultModel(movies: tempMovies);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.movies != null) {
      data['results'] = this.movies.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
```

```dart
class MovieModel extends MovieEntity {
  int id;
  bool video;
  int voteCount;
  double voteAverage;
  String title;
  String releaseDate;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String backdropPath;
  bool adult;
  String overview;
  String posterPath;
  double popularity;
  String mediaType;
  
  const MovieModel({
    this.popularity,
    this.voteCount,
    this.video,
    this.posterPath,
    this.id,
    this.adult,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.title,
    this.voteAverage,
    this.overview,
    this.releaseDate,
    this.mediaType,
  });

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    video = json['video'];
    voteCount = json['vote_count'];
    voteAverage = json['vote_average'];
    title = json['title'];
    releaseDate = json['release_date'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    genreIds = json['genre_ids'].cast<int>();
    backdropPath = json['backdrop_path'];
    adult = json['adult'];
    overview = json['overview'];
    posterPath = json['poster_path'];
    popularity = json['popularity'];
    mediaType = json['media_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['popularity'] = this.popularity;
    data['vote_count'] = this.voteCount;
    data['video'] = this.video;
    data['poster_path'] = this.posterPath;
    data['id'] = this.id;
    data['adult'] = this.adult;
    data['backdrop_path'] = this.backdropPath;
    data['original_language'] = this.originalLanguage;
    data['original_title'] = this.originalTitle;
    data['genre_ids'] = this.genreIds;
    data['title'] = this.title;
    data['vote_average'] = this.voteAverage;
    data['overview'] = this.overview;
    data['release_date'] = this.releaseDate;
    data['media_type'] = this.mediaType;
    return data;
  }
}
```

Add 2 dependencies - http and equatable

```yaml
equatable: ^1.2.0
http: ^0.12.1
```

In dart, comparison of objects is easier when you use equatable plugin. http plugin is used to make network calls.

Now, think of the fields you'll need in the application because no way you're using all of the fields together at a time on screen. The fields that will be required will be mostly id, posterPath, backdropPath, title, voteAverage, releaseDate, overview. Some fields are still extra but you'll have to use them later in the series, when we do favorite movies.

  
Now, In **domain/entities** folder create **MovieEntity** class and declare the above fields as final. Extend this class with Equatable. Override `props` method with id and title fields. Also override `stringify` method, so that you can see id and title when you print the object.  
Your **MovieEntity** class should look like this:

```dart
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class MovieEntity extends Equatable {
  final String posterPath;
  final int id;
  final String backdropPath;
  final String title;
  final num voteAverage;
  final String releaseDate;
  final String overview;

  const MovieEntity({
    @required this.posterPath,
    @required this.id,
    @required this.backdropPath,
    @required this.title,
    @required this.voteAverage,
    @required this.releaseDate,
    this.overview,
  }) : assert(id != null, 'Movie id must not be null');

  @override
  List<Object> get props => [id, title];

  @override
  bool get stringify => true;
}
```

To properly tie `MovieModel` and MovieEntity and execute Clean architecture, extend `MovieModel` with `MovieEntity`. This will help in separating out Domain and Data Layer.

Now that `MovieModel` is extending `MovieEntity`, there are some changes that has to be done to `MovieModel`. 

* Make all the fields as `final`.
* Update `fromJson` method to factory method and instead of assigning values directly return `MovieModel` object with new values.
* Use `super` constructor to assign the values to `MovieEntity`. This way whenever you convert `MovieModel` to `MovieEntity` instance you can get the requierd fields with correct non-null values.

Here is how updated `MovieModel` will look.

```dart
import '../../domain/entities/movie_entity.dart';

class MovieModel extends MovieEntity {
  final double popularity;
  final int voteCount;
  final bool video;
  final String posterPath;
  final int id;
  final bool adult;
  final String backdropPath;
  final String originalLanguage;
  final String originalTitle;
  final List<int> genreIds;
  final String title;
  final num voteAverage;
  final String overview;
  final String releaseDate;
  final String mediaType;

  const MovieModel({
    this.popularity,
    this.voteCount,
    this.video,
    this.posterPath,
    this.id,
    this.adult,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.title,
    this.voteAverage,
    this.overview,
    this.releaseDate,
    this.mediaType,
  }) : super(
          id: id,
          title: title,
          backdropPath: backdropPath,
          posterPath: posterPath,
          releaseDate: releaseDate,
          voteAverage: voteAverage,
          overview: overview,
        );

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      popularity: json['popularity'],
      voteCount: json['vote_count'],
      video: json['video'],
      posterPath: json['poster_path'],
      id: json['id'],
      adult: json['adult'],
      backdropPath: json['backdrop_path'],
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      genreIds: json['genre_ids'].cast<int>(),
      title: json['title'],
      voteAverage: json['vote_average'],
      overview: json['overview'],
      releaseDate: json['release_date'],
      mediaType: json['media_type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['popularity'] = this.popularity ;
    data['vote_count'] = this.voteCount;
    data['video'] = this.video;
    data['poster_path'] = this.posterPath;
    data['id'] = this.id;
    data['adult'] = this.adult;
    data['backdrop_path'] = this.backdropPath;
    data['original_language'] = this.originalLanguage;
    data['original_title'] = this.originalTitle;
    data['genre_ids'] = this.genreIds;
    data['title'] = this.title;
    data['vote_average'] = this.voteAverage;
    data['overview'] = this.overview;
    data['release_date'] = this.releaseDate;
    data['media_type'] = this.mediaType;
    return data;
  }
}
```


> When you're declaring any field as double in models, be completely sure that it'll always be returned as double. If it is returned as int, **convert** library fails to parse it. Either you can declare this as **num** or use **toDouble** function with safe operators.
> ```dart
> json['popularity']?.toDouble() ?? 0.0
>```
>
>This will parse `int` to `double` if `int` is returned from **API**. As well as, if it is returned as `null`, 0.0 will be the default value of `popularity`.  
>  
> Additionally, you can assign more default values to all the model fields.
>

### **Create DataSource**

Let's focus on making network call now to fill up the models and entities.

Create a file **movie\_remote\_data\_source.dart** in **data/data\_sources** folder.

Create and abstract class **MovieRemoteDataSource** with one function as of now. This method will call TMDb API for trending movies by day.

```dart
abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getTrending();
}
```

In the same file add the implementation of the abstract class

```dart
class MovieRemoteDataSourceImpl extends MovieRemoteDataSource {
  @override
  Future<List<MovieModel>> getTrending() async {
    //TODO: Fetch Trending Movies
  }
}

```

Declare a final field `_client` at the top and  create constructor of `MovieRemoteDataSource` with instance of `Client` from http package.

```dart
class MovieRemoteDataSourceImpl extends MovieRemoteDataSource {
  final Client _client;

  MovieRemoteDataSourceImpl(this._client);
}
```

### GetTrending Movies

Now, we will use `_client` to make **get** API call for trending movies.

```dart
@override
Future<List<MovieModel>> getTrending() async {
  final response = await _client.get(
    //1
    '${ApiConstants.BASE_URL}trending/movie/day?api_key=${ApiConstants.API_KEY}',
    //2
    headers: {
      'Content-Type': 'application/json',
    },
  );
  
  //3
  if (response.statusCode == 200) {
    //4
    final responseBody =  json.decode(response.body);
    //5
    final movies = MoviesResultModel.fromJson(responseBody).movies;
    print(movies);
    //6
    return movies;
  } else {
    //7
    throw Exception(response.reasonPhrase);
  }
}
```

1. Create the get URL Path - [https://api.themoviedb.org/3/trending/movie/day?api\_key=f33521953035af3fc3162fe1ac22e60c](https://api.themoviedb.org/3/trending/movie/day?api_key=f33521953035af3fc3162fe1ac22e60c).
2. Keep headers as json because TMDb API will result in JSON format.
3. Check whtether service has given success response.
4. Parse the json reponse and get the body. Body will have the exact json that we copied and pasted in json2Dart tool to create models.
5. You'll now use `fromJson` factory method to parse the JSON response to the model. Notice, we only require list of movies, hence after parsing you'll only get movies from the `MovieResultModel`
6. Finally, return the movies.
7. In case service has responded with error results, you'll throw exception from data layer itself. 

### **Call the GetTrending Function**

Till the time I don't create UI, I can show you that our network calls are working fine and giving us desired results by directly calling from **main.dart.**

Open main.dart and before calling `runApp(MyApp())` you can call `getTrending()` function by below snippet:

```dart
//1
MovieRemoteDataSource dataSource = MovieRemoteDataSourceImpl(Client());
//2
dataSource.getTrending();
```

1. Instantiate DataSource and pass the `Client` from http package.
2. Call the function. Once you run the app, in the console you can see the movies list with each movie's `id` and `title`, because in `props` we passed id and title.

### GetPopular Movies

Let's add one more API call quickly. Create another function getPopular which will call different API to fetch popular movies. Add `getPopular()` in abstract class as below:

```dart
abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getTrending();
  Future<List<MovieModel>> getPopular();
}
```

Implement `getPopular()` method as below. Fortunately, there is only URL Path change, which is now **movie/popular.**

```dart
@override
Future<List<MovieModel>> getPopular() async {
  final response = await _client.get(
    '${ApiConstants.BASE_URL}movie/popular?api_key=${ApiConstants.API_KEY}',
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final responseBody =  json.decode(response.body);
    final movies = MoviesResultModel.fromJson(responseBody).movies;
    print(movies);
    return movies;
  } else {
    throw Exception(response.reasonPhrase);
  }
}
```

You can run this method as well, in the same manner as you called `getTrending()` from **main.dart.**

### Core API Client

Even though till now we have added 2 methods only, but already you might have seen repeated code. So, let's move out common code to a separate file.   
Create **api\_client.dart** in **data/core.**

In ApiClient class add Client as its only final field and also create the constructor with it.

```dart
class ApiClient {
  final Client _client;

  ApiClient(this._client);
}
```

Create a **get** method with dynamic as return type, because this can return any type of model.

```dart
dynamic get(String path) async {
  final response = await _client.get(
    '${ApiConstants.BASE_URL}$path?api_key=${ApiConstants.API_KEY}',
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception(response.reasonPhrase);
  }
}
```

We've moved most of the code to this method and now we can update the data source implementation with very simple code. You'll now use **ApiClient** instead of Client.

```dart
class MovieRemoteDataSourceImpl extends MovieRemoteDataSource {
  //1
  final ApiClient _client;

  MovieRemoteDataSourceImpl(this._client);

  @override
  Future<List<MovieModel>> getTrending() async {
    //2
    final response = await _client.get('trending/movie/day');
    return MoviesResultModel.fromJson(response).movies;
  }

  @override
  Future<List<MovieModel>> getPopular() async {
    //3
    final response = await _client.get('movie/popular');
    return MoviesResultModel.fromJson(response).movies;
  }

}
```

1. Instead of **Client**, use **ApiClient** now.
2. Call the `get` method from ApiClient with the path required to fetch trending movies.
3. Call the `get` method from ApiClient with the path required to fetch popular movies.

This was all about making network calls.
