import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/home/home_cubit.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import 'movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchHomeMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Movies Hub',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          } else if (state is HomeError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (state is HomeLoaded) {
            if (state.popularMovies.isEmpty && state.topRatedMovies.isEmpty) {
              return const Center(
                child: Text(
                  'No Movies Available',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Popular Movies',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // GridView بدلاً من ListView لعرض فيلمين بالصف بشكل طولي
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.62,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: state.popularMovies.length,
                    itemBuilder: (context, index) {
                      final movie = state.popularMovies[index];
                      return MovieCard(
                        title: movie['title'] ?? '',
                        posterPath: movie['posterPath'] ?? '',
                        rating: (movie['rating'] ?? 0.0).toDouble(),
                        onTap: () {
                          final selectedMovie = Movie(
                            id: movie['id'] ?? 0,
                            name: movie['title'] ?? movie['name'] ?? '',
                            description:
                                movie['overview'] ?? movie['description'] ?? '',
                            ReleaseDate:
                                movie['release_date'] ??
                                movie['releaseDate'] ??
                                '',
                            rating:
                                (movie['vote_average'] ??
                                        movie['rating'] ??
                                        0.0)
                                    .toDouble(),
                            posterPath:
                                movie['poster_path'] ??
                                movie['posterPath'] ??
                                '',
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailsScreen(movie: selectedMovie),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
