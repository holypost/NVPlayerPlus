import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_app/pages/widgets/movie_item_card.dart';
import 'package:movie_app/pages/widgets/progress_view.dart';
import 'package:movie_app/utils/sliver_grid_delegate.dart';
import 'package:movies_data/movies_data.dart';

class MoviesSeeAll extends StatefulWidget {
  const MoviesSeeAll({Key? key, required this.type}) : super(key: key);

  final MovieType type;

  static Route<void> route(MovieType type) =>
      MaterialPageRoute(builder: (_) => MoviesSeeAll(type: type));

  @override
  State<MoviesSeeAll> createState() => _MoviesSeeAllState();
}

class _MoviesSeeAllState extends State<MoviesSeeAll> {
  static const _pageSize = 20;
  late PagingController<int, MovieItem> _pagingController;

  @override
  void initState() {
    _pagingController = PagingController<int, MovieItem>(
      getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
      fetchPage: _fetchPage,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<List<MovieItem>> _fetchPage(int pageKey) async {
    try {
      final repository = RepositoryProvider.of<MoviesRepository>(context);

      final data = await repository.getMoviesByType(
        page: pageKey,
        type: widget.type,
      );

      final result = data.getValueOrNull();

      final movies = result?.movies ?? [];
      return movies;
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_sharp),
        ),
        title: Text(widget.type.getTypeText),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: RefreshIndicator(
          color: Theme.of(context).colorScheme.onPrimary,
          onRefresh: () async {
            _pagingController.refresh();
          },
          child: PagingListener(
            controller: _pagingController,
            builder: (context, state, fetchNextPage) => PagedGridView<int, MovieItem>(
              state: state,
              fetchNextPage: fetchNextPage,
              showNewPageProgressIndicatorAsGridChild: false,
              showNewPageErrorIndicatorAsGridChild: false,
              showNoMoreItemsIndicatorAsGridChild: false,
              gridDelegate: gridDelegate(context),
              builderDelegate: PagedChildBuilderDelegate<MovieItem>(
                itemBuilder: (context, movie, index) =>
                    MovieItemCard(movie: movie),
                firstPageErrorIndicatorBuilder: (_) => _FirstPageErrorIndicator(
                  error: state.error ?? 'Unknown error',
                  onTryAgain: () => _pagingController.refresh(),
                ),
                newPageErrorIndicatorBuilder: (_) => _FirstPageErrorIndicator(
                  error: state.error ?? 'Unknown error',
                  onTryAgain: () => fetchNextPage(),
                ),
                firstPageProgressIndicatorBuilder: (_) => Container(
                  margin: const EdgeInsets.all(16.0),
                  child: const ProgressView(),
                ),
                newPageProgressIndicatorBuilder: (_) => Container(
                  margin: const EdgeInsets.all(16.0),
                  child: const ProgressView(),
                ),
                // noItemsFoundIndicatorBuilder: (_) => NoItemsFoundIndicator(),
                // noMoreItemsIndicatorBuilder: (_) => NoMoreItemsIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FirstPageErrorIndicator extends StatelessWidget {
  final Object error;
  final void Function() onTryAgain;

  const _FirstPageErrorIndicator({
    required this.error,
    required this.onTryAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            child: Text(
              '$error',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          ElevatedButton(onPressed: onTryAgain, child: const Text('Tyr again')),
        ],
      ),
    );
  }
}
