import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/movie.dart';
import '../models/comment.dart';
import '../models/movie_model.dart';
import '../cubits/watchlist/watchlist_cubit.dart';
import '../cubits/watchlist/watchlist_state.dart';
import '../cubits/profile/profile_state.dart';
import '../cubits/profile/profile_cubit.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late final Future<String> _trailerFuture;
  late final Future<List<Comment>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    final service = Service();
    _trailerFuture = service.gettrailer(widget.movie.id);
    _commentsFuture = service.getComments(widget.movie.id);
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl = widget.movie.posterPath.startsWith('http')
        ? widget.movie.posterPath
        : 'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}';

    return Scaffold(
      backgroundColor: const Color(0xFF0F111D),
      body: Stack(
        children: [
          // 1. صورة خلفية الفيلم
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: const Color(0xFF0F111D)),
            ),
          ),

          // 2. تدرج أسود خفيف لتوضيح النصوص ومنع الاحمرار
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.85),
                    const Color(0xFF0F111D),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),

          // 3. المحتوى الرئيسي
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.45),
                  Text(
                    widget.movie.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.movie.rating}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.movie.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Trailer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<String>(
                    future: _trailerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LinearProgressIndicator(
                          color: Color(0xFFFF2B57),
                          backgroundColor: Colors.white24,
                        );
                      }
                      if (snapshot.hasError || !snapshot.hasData) {
                        return const Text(
                          'Trailer unavailable',
                          style: TextStyle(color: Colors.white60),
                        );
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Watch trailer'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFFFF2B57)),
                          ),
                          onPressed: () async {
                            await launchUrl(
                              Uri.parse(snapshot.data!),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Comments',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<List<Comment>>(
                    future: _commentsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFF2B57),
                          ),
                        );
                      }
                      if (snapshot.hasError || snapshot.data!.isEmpty) {
                        return const Text(
                          'No comments available',
                          style: TextStyle(color: Colors.white60),
                        );
                      }
                      return Column(
                        children: snapshot.data!.map(_commentTile).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                    BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      final cubit = context.read<ProfileCubit>();
                      final isFav = cubit.isFavorite(widget.movie);
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF2B57),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () {
                            if (isFav) {
                              cubit.removeFromFavorites(widget.movie);
                            } else {
                              cubit.addToFavorites(widget.movie);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isFav
                                    ? 'Remove from favourite'
                                    : 'Add to favourite',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // 4. أزرار أعلى الشاشة (الرجوع والـ Bookmark)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    
                    BlocBuilder<WatchlistCubit, WatchlistState>(
                      builder: (context, state) {
                        final cubit = context.read<WatchlistCubit>();
                        final isSaved = cubit.isBookmarked(widget.movie);

                        return IconButton(
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: isSaved ? Colors.red : Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            if (isSaved) {
                              cubit.removeFromWatchlist(widget.movie);
                            } else {
                              cubit.addToWatchlist(widget.movie);
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _commentTile(Comment comment) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${comment.author}',
            style: const TextStyle(
              color: Color(0xFFFF6B83),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            comment.body,
            style: const TextStyle(color: Colors.white70, height: 1.35),
          ),
        ],
      ),
    );
  }
}
