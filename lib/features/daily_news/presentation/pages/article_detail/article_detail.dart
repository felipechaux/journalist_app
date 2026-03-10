import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../injection_container.dart';
import '../../../domain/entities/article.dart';
import '../../bloc/article/local/local_article_cubit.dart';
import '../../bloc/article_detail/article_detail_cubit.dart';
import '../../bloc/article_detail/article_detail_state.dart';

class ArticleDetailsView extends StatelessWidget {
  final ArticleEntity? article;

  const ArticleDetailsView({Key? key, this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (article == null) {
      return const Scaffold(body: Center(child: Text('Article not found.')));
    }

    return BlocProvider(
      create: (_) => ArticleDetailCubit(article!, sl())..loadArticleDetails(),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(context),
          body: BlocBuilder<ArticleDetailCubit, ArticleDetailState>(
            builder: (context, state) {
              if (state is ArticleDetailLoading) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.black87),
                      SizedBox(height: 16),
                      Text(
                        "Preparing your story...",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return _buildBody(state.article!);
            },
          ),
          floatingActionButton: _buildFloatingActionButton(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Ionicons.chevron_back_outline,
          color: Colors.black87,
          size: 28,
        ),
        onPressed: () => _onBackButtonTapped(context),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      actions: [
        IconButton(
          icon: const Icon(
            Ionicons.share_social_outline,
            color: Colors.black87,
            size: 24,
          ),
          onPressed: () {
            context.read<ArticleDetailCubit>().shareArticle();
          },
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: Colors.grey.shade100, height: 1),
      ),
    );
  }

  Widget _buildBody(ArticleEntity article) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildArticleTitleAndDate(article),
          if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
            _buildArticleImage(article),
          _buildArticleDescription(article),
        ],
      ),
    );
  }

  Widget _buildArticleTitleAndDate(ArticleEntity article) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            article.title ?? 'Unknown Title',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              height: 1.3,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          // Category/Author & DateTime
          Row(
            children: [
              Icon(
                Ionicons.time_outline,
                size: 18,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Text(
                article.publishedAt ?? 'Unknown Date',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 16), // Spacing between time and author
              if (article.author != null && article.author!.isNotEmpty) ...[
                Icon(
                  Ionicons.person_outline,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    article.author!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArticleImage(ArticleEntity article) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CachedNetworkImage(
        imageUrl: article.urlToImage!,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: double.infinity,
          height: 250,
          color: Colors.grey.shade50,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.black12,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: double.infinity,
          height: 250,
          color: Colors.grey.shade100,
          child: const Center(
            child: Icon(Ionicons.image_outline, size: 64, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildArticleDescription(ArticleEntity article) {
    final bodyContent =
        '${article.description ?? ''}\n\n${article.content ?? ''}';

    if (bodyContent.trim().isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Text(
          'No content available.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        24,
        16,
        24,
        120,
      ), // Extra space for FAB
      child: MarkdownBody(
        data: bodyContent.trim(),
        styleSheet: MarkdownStyleSheet(
          p: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
            height: 1.6,
            fontWeight: FontWeight.w400,
          ),
          h2: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 1.4,
          ),
          strong: const TextStyle(fontWeight: FontWeight.bold),
          listBullet: const TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Builder(
      builder: (context) => FloatingActionButton.extended(
        onPressed: () => _onFloatingActionButtonPressed(context),
        backgroundColor: Colors.black87,
        elevation: 4,
        icon: const Icon(
          Ionicons.bookmark_outline,
          color: Colors.white,
          size: 20,
        ),
        label: const Text(
          'Save',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  void _onBackButtonTapped(BuildContext context) {
    Navigator.pop(context);
  }

  void _onFloatingActionButtonPressed(BuildContext context) {
    final article = context.read<ArticleDetailCubit>().state.article;
    if (article != null) {
      BlocProvider.of<LocalArticleCubit>(context).saveArticle(article);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          content: Text('Article saved successfully!'),
        ),
      );
    }
  }
}
