import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:journalist_app/features/publish_article/presentation/bloc/publish_article_cubit.dart';
import 'package:journalist_app/features/publish_article/presentation/bloc/publish_article_state.dart';
import 'package:journalist_app/injection_container.dart';

class PublishArticlePage extends HookWidget {
  const PublishArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PublishArticleCubit>(),
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

    void removeImage() {
      imagePath.value = null;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: BlocConsumer<PublishArticleCubit, PublishArticleState>(
        listener: (context, state) {
          if (state is PublishArticleSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Article published successfully!'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is PublishArticleFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PublishArticleLoading) {
            return const Center(child: CupertinoActivityIndicator(radius: 16));
          }
          return _buildBody(
            context,
            titleController,
            contentController,
            imagePath.value,
            pickImage,
            removeImage,
          );
        },
      ),
      floatingActionButton: _buildPublishButton(
        context,
        titleController,
        contentController,
        imagePath.value,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Draft',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 18,
          letterSpacing: 0.5,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Ionicons.close_outline,
          color: Colors.black87,
          size: 28,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: Colors.grey.shade100, height: 1),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    TextEditingController titleController,
    TextEditingController contentController,
    String? currentImagePath,
    Future<void> Function() onPickImage,
    VoidCallback onRemoveImage,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (currentImagePath != null)
            Stack(
              children: [
                Image.file(
                  File(currentImagePath),
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(
                        Ionicons.trash_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: onRemoveImage,
                    ),
                  ),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (currentImagePath == null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: InkWell(
                      onTap: onPickImage,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Ionicons.image_outline,
                              size: 36,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add Cover Image (Optional)',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Article Title',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.next,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: Colors.grey.shade200, thickness: 1),
                ),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    hintText: 'Write your story here...',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade400,
                      height: 1.6,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 80), // Space for floating action button
              ],
            ),
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
    return FloatingActionButton.extended(
      onPressed: () {
        if (titleController.text.trim().isEmpty ||
            contentController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Title and content are required'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        context.read<PublishArticleCubit>().publishArticle(
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          imagePath: imagePath,
        );
      },
      backgroundColor: Colors.black87,
      elevation: 4,
      icon: const Icon(
        Ionicons.paper_plane_outline,
        color: Colors.white,
        size: 20,
      ),
      label: const Text(
        'Publish',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
