import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:journalist_app/features/daily_news/presentation/bloc/article/publish/publish_article_bloc.dart';
import 'package:journalist_app/features/daily_news/presentation/bloc/article/publish/publish_article_event.dart';
import 'package:journalist_app/features/daily_news/presentation/bloc/article/publish/publish_article_state.dart';
import 'package:journalist_app/injection_container.dart';

class PublishArticlePage extends HookWidget {
  const PublishArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PublishArticleBloc>(),
      child: const _PublishArticleContent(),
    );
  }
}

class _PublishArticleContent extends HookWidget {
  const _PublishArticleContent();

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();
    final contentController = useTextEditingController();
    final imagePath = useState<String?>(null);

    final picker = ImagePicker();

    Future<void> pickImage() async {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        imagePath.value = image.path;
      }
    }

    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocConsumer<PublishArticleBloc, PublishArticleState>(
        listener: (context, state) {
          if (state is PublishArticleSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Article published successfully!')),
            );
            Navigator.pop(context);
          } else if (state is PublishArticleFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is PublishArticleLoading) {
            return const Center(child: CupertinoActivityIndicator());
          }
          return _buildBody(
            context,
            titleController,
            contentController,
            imagePath.value,
            pickImage,
          );
        },
      ),
      bottomNavigationBar: _buildPublishButton(
        context,
        titleController,
        contentController,
        imagePath.value,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Ionicons.chevron_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildBody(
    BuildContext context,
    TextEditingController titleController,
    TextEditingController contentController,
    String? currentImagePath,
    Future<void> Function() onPickImage,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'Write your title here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
            maxLines: 2,
            minLines: 1,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: onPickImage,
              icon: const Icon(
                Ionicons.camera_outline,
                size: 18,
                color: Colors.black,
              ),
              label: const Text(
                'Attach Image',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFFDCC8E4,
                ), // Similar to the purple button in the design
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
            ),
          ),
          if (currentImagePath != null) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(currentImagePath),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
          const SizedBox(height: 20),
          TextField(
            controller: contentController,
            decoration: InputDecoration(
              hintText: 'Add article here, ....',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ), // Removing border as in right edge case
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            maxLines: 15,
            minLines: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildPublishButton(
    BuildContext context,
    TextEditingController titleController,
    TextEditingController contentController,
    String? imagePath,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: const Color(0xFFDCC8E4),
      child: TextButton(
        onPressed: () {
          if (titleController.text.trim().isEmpty ||
              contentController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Title and content are required')),
            );
            return;
          }

          context.read<PublishArticleBloc>().add(
            PublishArticleSubmitted(
              title: titleController.text.trim(),
              content: contentController.text.trim(),
              imagePath: imagePath,
            ),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Ionicons.arrow_forward_outline, color: Colors.black),
            SizedBox(width: 10),
            Text(
              'Publish Article',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
