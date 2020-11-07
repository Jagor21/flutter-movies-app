import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/depen_injec/get_it.dart';
import 'package:movies_app/presentation/blocs/movie_backdrop/movie_backdrop_bloc.dart';
import 'package:movies_app/presentation/blocs/movie_carousel/movie_carousel_bloc.dart';
import 'package:movies_app/presentation/blocs/movie_tabbed/movie_tabbed_bloc.dart';
import 'package:movies_app/presentation/journeys/home/movie_carousel/movie_carousel_widget.dart';
import 'package:movies_app/presentation/journeys/home/movie_tabbed/movie_tabbed_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MovieCarouselBloc _movieCarouselBloc;
  MovieBackdropBloc _movieBackdropBloc;
  MovieTabbedBloc _movieTabbedBloc;

  @override
  void initState() {
    super.initState();
    _movieCarouselBloc = getIt<MovieCarouselBloc>();
    _movieBackdropBloc = _movieCarouselBloc.movieBackdropBloc;
    _movieTabbedBloc = getIt<MovieTabbedBloc>();
    _movieCarouselBloc.add(MovieCarouselLoadEvent(initialIndex: 0));
  }

  @override
  void dispose() {
    _movieCarouselBloc?.close();
    _movieBackdropBloc?.close();
    _movieTabbedBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => _movieCarouselBloc),
          BlocProvider(create: (_) => _movieBackdropBloc),
          BlocProvider(create: (_) => _movieTabbedBloc),
        ],
        child: BlocBuilder<MovieCarouselBloc, MovieCarouselState>(
          builder: (_, state) {
            if (state is MovieCarouselLoaded) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  FractionallySizedBox(
                    alignment: Alignment.topCenter,
                    heightFactor: 0.6,
                    child: MovieCarouselWidget(
                      initialIndex: state.initialIndex,
                      movies: state.movies,
                    ),
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 0.4,
                    child: MovieTabbedWidget(),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}