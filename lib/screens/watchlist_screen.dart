import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_hub_app/cubits/watchlist/watchlist_cubit.dart';
import 'package:movies_hub_app/cubits/watchlist/watchlist_state.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Watchlist',
          style: TextStyle(
            color: Colors.red,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<WatchlistCubit, WatchlistState>(
        builder: (context, state) {
          final watchlist = context.read<WatchlistCubit>().watchlistMovies;

          if (watchlist.isEmpty) {
            return Center(
              child: Text(
                'No movies added yet',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black87
                      : Colors.white70,
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: watchlist.length,
            itemBuilder: (context, index) {
              final movie = watchlist[index];
              final imageUrl = movie.posterPath.startsWith('http')
                  ? movie.posterPath
                  : 'https://image.tmdb.org/t/p/w500${movie.posterPath}';

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 50,
                    height: 75,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey, width: 50, height: 75),
                  ),
                ),
                title: Text(
                  movie.name,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '★ ${movie.rating.toStringAsFixed(1)}',
                  style: const TextStyle(color: Colors.amber),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    context.read<WatchlistCubit>().removeFromWatchlist(movie);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
