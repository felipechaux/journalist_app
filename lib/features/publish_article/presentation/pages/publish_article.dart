import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:journalist_app/features/publish_article/presentation/bloc/publish_article_bloc.dart';
import 'package:journalist_app/features/publish_article/presentation/bloc/publish_article_event.dart';
import 'package:journalist_app/features/publish_article/presentation/bloc/publish_article_state.dart';
import 'package:journalist_app/injection_container.dart';
import 'package:journalist_app/l10n/app_localizations.dart';

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

    // Hooks to trigger rebuild on text change for counters
    useListenable(titleController);
    useListenable(contentController);

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
      body: BlocConsumer<PublishArticleBloc, PublishArticleState>(
        listener: (context, state) {
          if (state is PublishArticleSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.articlePublishedSuccess,
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is PublishArticleFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(
                    context,
                  )!.errorPrefix(state.error.toString()),
                ),
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
      title: Text(
        AppLocalizations.of(context)!.draftTitle,
        style: const TextStyle(
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

  static const int maxTitleLength = 100;
  static const int maxContentLength = 5000;

  Widget _buildBody(
    BuildContext context,
    TextEditingController titleController,
    TextEditingController contentController,
    String? currentImagePath,
    Future<void> Function() onPickImage,
    VoidCallback onRemoveImage,
  ) {
    void insertMarkdown(String tagOpen, [String tagClose = '']) {
      final text = contentController.text;
      final selection = contentController.selection;

      if (!selection.isValid) {
        contentController.text = '$text$tagOpen$tagClose';
        contentController.selection = TextSelection.collapsed(
          offset: text.length + tagOpen.length,
        );
        return;
      }

      final selectedText = selection.textInside(text);

      final newText = text.replaceRange(
        selection.start,
        selection.end,
        '$tagOpen$selectedText$tagClose',
      );

      final newOffset = selectedText.isEmpty
          ? selection.start + tagOpen.length
          : selection.start +
                tagOpen.length +
                selectedText.length +
                tagClose.length;

      contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newOffset),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (currentImagePath != null)
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: onPickImage,
                        child: Image.file(
                          File(currentImagePath),
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Ionicons.camera_outline,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                AppLocalizations.of(context)!.tapToChange,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
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
                                    AppLocalizations.of(context)!.addCoverImage,
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: titleController,
                              maxLength: maxTitleLength,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(
                                  context,
                                )!.articleTitleHint,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                counterText: "", // Hide default counter
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
                          ),
                          Text(
                            '${titleController.text.length}/$maxTitleLength',
                            style: TextStyle(
                              color:
                                  titleController.text.length >= maxTitleLength
                                  ? Colors.red
                                  : Colors.grey.shade400,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Divider(
                          color: Colors.grey.shade200,
                          thickness: 1,
                        ),
                      ),
                      TextField(
                        controller: contentController,
                        maxLength: maxContentLength,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(
                            context,
                          )!.writeStoryHint,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          counterText: "", // Hide default counter
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
                      const SizedBox(
                        height: 80,
                      ), // Space for floating action button
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Formatting Toolbar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade100)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                _buildToolbarIcon(
                  Ionicons.text_outline,
                  'H2',
                  () => insertMarkdown('## '),
                ),
                const SizedBox(width: 16),
                _buildToolbarIcon(
                  Ionicons.text_outline,
                  'B',
                  () => insertMarkdown('**', '**'),
                ),
                const Spacer(),
                Text(
                  AppLocalizations.of(
                    context,
                  )!.charactersCount(contentController.text.length),
                  style: TextStyle(
                    color: contentController.text.length >= maxContentLength
                        ? Colors.red
                        : Colors.grey.shade500,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolbarIcon(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.black87),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
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
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.titleAndContentRequired,
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.orange,
            ),
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
      backgroundColor: Colors.black87,
      elevation: 4,
      icon: const Icon(
        Ionicons.paper_plane_outline,
        color: Colors.white,
        size: 20,
      ),
      label: Text(
        AppLocalizations.of(context)!.publishArticleFab,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
