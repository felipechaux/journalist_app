import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:journalist_app/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:journalist_app/features/daily_news/presentation/bloc/article/remote/remote_article_cubit.dart';
import 'package:journalist_app/features/daily_news/presentation/bloc/article/local/local_article_cubit.dart';

import 'package:journalist_app/core/network_info/bloc/network_cubit.dart';
import 'package:journalist_app/l10n/app_localizations.dart';
import 'package:journalist_app/core/localization/bloc/locale_cubit.dart';
import '../../../domain/entities/article.dart';
import '../../widgets/article_tile.dart';

class DailyNews extends StatelessWidget {
  const DailyNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppbar(context),
      body: BlocListener<NetworkCubit, NetworkStatus>(
        listener: (context, state) {
          if (state == NetworkStatus.disconnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.offlineMessage),
                backgroundColor: Colors.redAccent,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state == NetworkStatus.connected) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.onlineMessage),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            // Force sync data from server when back online
            context.read<RemoteArticlesCubit>().getArticles(refresh: true);
            context
                .read<LocalArticleCubit>()
                .syncSavedArticlesWithRemote()
                .then((_) {
                  if (context.mounted) {
                    context.read<RemoteArticlesCubit>().getArticles(
                      refresh: true,
                    );
                  }
                });
          }
        },
        child: Column(
          children: [
            _buildOfflineBanner(),
            Expanded(child: _buildPage()),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.dailyNewsTitle.split(' ')[0],
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 26,
              letterSpacing: -1,
            ),
          ),
          if (AppLocalizations.of(context)!.dailyNewsTitle.contains(' '))
            Text(
              AppLocalizations.of(context)!.dailyNewsTitle.split(' ')[1],
              style: TextStyle(
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                height: 0.8,
                letterSpacing: 2,
              ),
            ),
        ],
      ),
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () => context.read<LocaleCubit>().toggleLanguage(),
          icon: const Icon(
            Ionicons.language_outline,
            color: Colors.black87,
            size: 24,
          ),
          splashRadius: 20,
        ),
        IconButton(
          onPressed: () => _onShowSavedArticlesViewTapped(context),
          icon: const Icon(
            Ionicons.bookmarks_outline,
            color: Colors.black87,
            size: 24,
          ),
          splashRadius: 20,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildPage() {
    return BlocBuilder<RemoteArticlesCubit, RemoteArticlesState>(
      builder: (context, state) {
        if (state is RemoteArticlesLoading) {
          return const Center(child: CupertinoActivityIndicator(radius: 16));
        }
        if (state is RemoteArticlesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Ionicons.refresh_circle_outline,
                  color: Colors.grey.shade400,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load news',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }
        if (state is RemoteArticlesDone) {
          if (state.articles == null || state.articles!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Ionicons.newspaper_outline,
                    color: Colors.grey.shade400,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No articles yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }
          return _buildArticlesList(context, state.articles!);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildArticlesList(
    BuildContext context,
    List<ArticleEntity> articles,
  ) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ArticleWidget(
            article: articles[index],
            onArticlePressed: (article) => _onArticlePressed(context, article),
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final result = await Navigator.pushNamed(context, '/PublishArticle');
        if (result == true) {
          if (context.mounted) {
            context.read<RemoteArticlesCubit>().getArticles(refresh: true);
          }
        }
      },
      backgroundColor: Colors.black87,
      elevation: 4,
      icon: const Icon(Ionicons.create_outline, color: Colors.white, size: 20),
      label: Text(
        AppLocalizations.of(context)!.publishArticleFab,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildOfflineBanner() {
    return BlocBuilder<NetworkCubit, NetworkStatus>(
      builder: (context, state) {
        if (state == NetworkStatus.disconnected) {
          return Container(
            width: double.infinity,
            color: Colors.redAccent,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.offlineMessage,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
  }

  void _onShowSavedArticlesViewTapped(BuildContext context) {
    Navigator.pushNamed(context, '/SavedArticles');
  }
}
