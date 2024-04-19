import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/movie_model.dart';
import '../services/http_manager.dart';
import 'movie_repository.dart';

class MovieRepositoryImpl extends MovieRepository {
  final HttpManager httpManager;

  MovieRepositoryImpl({required this.httpManager});

  final String apiKey = dotenv.env['API_KEY'] ?? '';
  final String apiToken = dotenv.env['API_TOKEN'] ?? '';

  @override
  Future<List<MovieModel>> getUpcoming() async {
    final url = 'https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey&language=pt-BR&page=1';

    var response = await httpManager.sendRequest(
      url: url,
      method: HttpMethod.get,
    );

    if (response.containsKey('results')) {
      List<dynamic> results = response['results'];
      return results.map<MovieModel>((json) => MovieModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  @override
  Future<bool> addRating(String id, double rate) async {
    final url = 'https://api.themoviedb.org/3/movie/$id/rating?api_key=$apiKey';
    final headers = {
      'Content-Type': 'application/json;charset=utf-8',
      'Authorization': 'Bearer $apiToken',
    };
    final body = {'value': rate};

    var response = await httpManager.sendRequest(
      url: url,
      method: HttpMethod.post,
      headers: headers,
      body: body,
    );

    if (response.containsKey('success') && response['success']) {
      return true;
    } else {
      return false;
    }
  }
}
