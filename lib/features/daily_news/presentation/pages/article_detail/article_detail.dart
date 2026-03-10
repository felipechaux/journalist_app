import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../../injection_container.dart';
import '../../../domain/entities/article.dart';
import '../../bloc/article/local/local_article_bloc.dart';
import '../../bloc/article/local/local_article_event.dart';

class ArticleDetailsView extends HookWidget {
  final ArticleEntity? article;

  const ArticleDetailsView({Key? key, this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (article == null) {
      return const Scaffold(body: Center(child: Text('Article not found.')));
    }

    return BlocProvider(
      create: (_) => sl<LocalArticleBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButton(),
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
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: Colors.grey.shade100, height: 1),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildArticleTitleAndDate(),
          if (article!.urlToImage != null && article!.urlToImage!.isNotEmpty)
            _buildArticleImage(),
          _buildArticleDescription(),
        ],
      ),
    );
  }

  Widget _buildArticleTitleAndDate() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            article!.title ?? 'Unknown Title',
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
                article!.publishedAt ?? 'Unknown Date',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 16), // Spacing between time and author
              if (article!.author != null && article!.author!.isNotEmpty) ...[
                Icon(
                  Ionicons.person_outline,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    article!.author!,
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

  Widget _buildArticleImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Image.network(
        article!.urlToImage!,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
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

  Widget _buildArticleDescription() {
    final bodyContent =
        '${article!.description ?? ''}\n\n${article!.content ?? ''}';
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 100), // Space for FAB
      child: Text(
        bodyContent.trim().isEmpty
            ? 'No content available.'
            : bodyContent.trim(),
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black87,
          height: 1.6,
          fontWeight: FontWeight.w400,
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
    BlocProvider.of<LocalArticleBloc>(context).add(SaveArticle(article!));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        content: Text('Article saved successfully!'),
      ),
    );
  }
}
