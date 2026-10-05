class Trailer {
  final String title;
  Trailer({required this.title});
}

class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<Trailer> trailers;

  Movie({required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,}

  );
}
final List<Movie> sampleMovies = [
  Movie(
    id: '1',
    title: 'Dune: Part Two',
    posterUrl: 'https://picsum.photos/id/1015/600/400', // Đường dẫn ảnh minh họa
    overview: 'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.',
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    rating: 8.6,
    trailers: [
      Trailer(title: 'Official Trailer #1'),
      Trailer(title: 'IMAX Sneak Peek'),
    ],
  ),
  Movie(
    id: '2',
    title: 'Deadpool & Wolverine',
    posterUrl: 'https://picsum.photos/id/1025/600/400',
    overview: 'The multiverse gets messy when Wade Wilson teams up with Wolverine for a not-so-family-friendly mission.',
    genres: ['Action', 'Comedy'],
    rating: 8.3,
    trailers: [
      Trailer(title: 'Red Band Trailer'),
      Trailer(title: 'Behind the Scenes'),
    ],
  ),
];
