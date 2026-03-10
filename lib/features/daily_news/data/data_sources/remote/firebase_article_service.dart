import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:journalist_app/features/daily_news/data/models/article.dart';

class FirebaseArticleService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  FirebaseArticleService(this._firestore, this._storage);

  Future<void> publishArticle(
    ArticleModel article, {
    String? localImagePath,
  }) async {
    String? imageUrl = article.urlToImage;

    if (localImagePath != null && localImagePath.isNotEmpty) {
      final file = File(localImagePath);
      final ref = _storage.ref().child(
        'article_images/${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}',
      );
      final uploadTask = await ref.putFile(file);
      imageUrl = await uploadTask.ref.getDownloadURL();
    }

    final articleData = {
      'title': article.title,
      'content': article.content,
      'description': article.description,
      'author': article.author,
      'url': article.url,
      'urlToImage': imageUrl,
      'publishedAt': DateTime.now().toIso8601String(),
    };

    await _firestore.collection('articles').add(articleData);
  }

  Future<List<ArticleModel>> getArticles({bool forceRefresh = false}) async {
    final snapshot = await _firestore
        .collection('articles')
        .orderBy('publishedAt', descending: true)
        .get(forceRefresh ? const GetOptions(source: Source.server) : null);
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ArticleModel.fromJson(data);
    }).toList();
  }
}
