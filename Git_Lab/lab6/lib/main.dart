import 'package:flutter/material.dart';

void main() {
  // Bước 1 & 3: Chạy ứng dụng và định nghĩa ResponsiveMovieApp.
  runApp(const ResponsiveMovieApp());
}

// Bước 2: Định nghĩa Movie Model
class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

// Dữ liệu mẫu (Sample Data)
final List<Movie> allMovies = [
  Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Action', 'Sci-Fi'],
    posterUrl: 'https://via.placeholder.com/150/0000FF/808080?Text=Inception',
    rating: 8.8,
  ),
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Drama'],
    posterUrl: 'https://via.placeholder.com/150/FF0000/FFFFFF?Text=Batman',
    rating: 9.0,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Sci-Fi', 'Drama'],
    posterUrl:
        'https://via.placeholder.com/150/000000/FFFFFF?Text=Interstellar',
    rating: 8.6,
  ),
  Movie(
    title: 'The Hangover',
    year: 2009,
    genres: ['Comedy'],
    posterUrl: 'https://via.placeholder.com/150/FFFF00/000000?Text=Hangover',
    rating: 7.7,
  ),
  Movie(
    title: 'Avengers: Endgame',
    year: 2019,
    genres: ['Action', 'Sci-Fi'],
    posterUrl: 'https://via.placeholder.com/150/800080/FFFFFF?Text=Endgame',
    rating: 8.4,
  ),
];

// Danh sách các thể loại phim và tiêu chí sắp xếp
final List<String> availableGenres = ['Action', 'Sci-Fi', 'Drama', 'Comedy'];
final List<String> sortOptions = ['A-Z', 'Z-A', 'Year', 'Rating']; //

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Browser',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GenreScreen(),
    );
  }
}

class GenreScreen extends StatefulWidget {
  const GenreScreen({Key? key}) : super(key: key);

  @override
  _GenreScreenState createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  // Biến trạng thái (State) lưu trữ thao tác của người dùng
  String searchQuery = ''; // Từ khóa tìm kiếm
  Set<String> selectedGenres = {}; // Các thể loại đang được chọn
  String selectedSort = 'A-Z'; // Tiêu chí sắp xếp hiện tại

  @override
  Widget build(BuildContext context) {
    // Bước 7: Lọc (Filter) và Sắp xếp (Sort) danh sách phim trước khi hiển thị[cite: 1]

    // 1. Lọc phim dựa trên Search và Genre
    List<Movie> visibleMovies = allMovies.where((movie) {
      // Lọc theo tên phim (không phân biệt hoa thường)[cite: 1]
      final matchSearch = movie.title.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      // Lọc theo thể loại: Nếu không chọn thể loại nào thì coi như hợp lệ,
      // nếu có chọn thì phim phải chứa ít nhất 1 thể loại đã chọn[cite: 1]
      final matchGenre =
          selectedGenres.isEmpty ||
          movie.genres.any((genre) => selectedGenres.contains(genre));

      return matchSearch && matchGenre;
    }).toList();

    // 2. Sắp xếp danh sách phim theo tiêu chí đã chọn[cite: 1]
    visibleMovies.sort((a, b) {
      if (selectedSort == 'A-Z') return a.title.compareTo(b.title);
      if (selectedSort == 'Z-A') return b.title.compareTo(a.title);
      if (selectedSort == 'Year')
        return b.year.compareTo(a.year); // Năm mới nhất xếp trước
      if (selectedSort == 'Rating')
        return b.rating.compareTo(a.rating); // Điểm cao xếp trước
      return 0;
    });

    // Xây dựng giao diện Base Scaffold[cite: 1]
    return Scaffold(
      body: SafeArea(
        // Sử dụng SafeArea để không bị lẹm vào tai thỏ / camera[cite: 1]
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề[cite: 1]
              const Text(
                'Find a Movie',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Bước 4: Thanh tìm kiếm (Search Bar)[cite: 1]
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search movies by title...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  // Cập nhật từ khóa và gọi setState để build lại giao diện[cite: 1]
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Bước 5: Danh sách thể loại (Genre Chips) dùng Wrap[cite: 1]
              Wrap(
                spacing: 8.0, // Khoảng cách ngang giữa các chip
                runSpacing: 4.0, // Khoảng cách dọc khi rớt dòng
                children: availableGenres.map((genre) {
                  final isSelected = selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        // Thêm hoặc xóa thể loại khỏi Set[cite: 1]
                        if (selected) {
                          selectedGenres.add(genre);
                        } else {
                          selectedGenres.remove(genre);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Bước 6: Thanh Dropdown để sắp xếp (Sort Bar)[cite: 1]
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sort by:', style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    value: selectedSort,
                    items: sortOptions.map((String sortType) {
                      return DropdownMenuItem<String>(
                        value: sortType,
                        child: Text(sortType),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedSort =
                              newValue; // Cập nhật tiêu chí sắp xếp[cite: 1]
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Bước 8: Responsive Movie List bằng LayoutBuilder & Expanded[cite: 1]
              Expanded(
                // Giúp danh sách chiếm hết phần không gian còn lại[cite: 1]
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Nếu chiều rộng < 800 (điện thoại), dùng ListView 1 cột[cite: 1]
                    if (constraints.maxWidth < 800) {
                      return ListView.builder(
                        itemCount: visibleMovies.length,
                        itemBuilder: (context, index) {
                          return _buildMovieCard(visibleMovies[index]);
                        },
                      );
                    }
                    // Nếu chiều rộng >= 800 (tablet/web), dùng GridView 2 cột[cite: 1]
                    else {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 2 Cột[cite: 1]
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio:
                                  2.5, // Tỷ lệ khung hình của thẻ phim
                            ),
                        itemCount: visibleMovies.length,
                        itemBuilder: (context, index) {
                          return _buildMovieCard(visibleMovies[index]);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget hiển thị từng thẻ phim chứa Ảnh Poster, Tiêu đề, Năm và Rating[cite: 1]
  Widget _buildMovieCard(Movie movie) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Poster bằng Image.network[cite: 1]
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomLeft: Radius.circular(4),
            ),
            child: Image.network(
              movie.posterUrl,
              width: 100,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // Thông tin phim
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title, // Tiêu đề[cite: 1]
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Year: ${movie.year}'), // Năm[cite: 1]
                const SizedBox(height: 4),
                Text('Rating: ${movie.rating} ⭐'),
                const SizedBox(height: 8),
                Text(
                  'Genres: ${movie.genres.join(", ")}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
