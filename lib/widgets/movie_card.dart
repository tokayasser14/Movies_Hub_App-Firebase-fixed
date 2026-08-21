import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String posterPath;
  final double rating;
  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.title,
    required this.posterPath,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String fullImageUrl = posterPath.isNotEmpty
        ? (posterPath.startsWith('http')
              ? posterPath
              : 'https://image.tmdb.org/t/p/w500$posterPath')
        : '';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[200]
              : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: fullImageUrl.isNotEmpty
                    ? Image.network(
                        fullImageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey,
                          child: Center(
                            child: Icon(
                              Icons.movie,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey,
                        child: const Center(
                          child: Icon(Icons.movie, color: Colors.white),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? Colors.grey[700]
                              : Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
