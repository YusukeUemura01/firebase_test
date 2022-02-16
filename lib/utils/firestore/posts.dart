import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_test/model/post.dart';

class PostFirestore{
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference posts = _firestoreInstance.collection('posts');//他のユーザなどの全体の投稿のpostコレクションのインスタンス

  static Future<dynamic>addPost(Post newPost)async{//投稿を追加するメソッド、引数に投稿の内容
    try{
      final CollectionReference _userPosts = _firestoreInstance.collection('users')
          .doc(newPost.postAccountId).collection('my_posts');//自分の投稿だけのmy_postsコレクションのインスタンス

      var result = await posts.add({//全体の投稿に自分の投稿を追加
        'content': newPost.content,
        'post_account_id': newPost.postAccountId,
        'created_time': Timestamp.now(),
      });
      _userPosts.doc(result.id).set({//result.idはその投稿自体のid   result.idを用いて自分の_userPostsにも保存する
        'post_id':result.id,
        'created_time':Timestamp.now(),
      });
      print("投稿完了");
      return true;
    }on FirebaseException catch(e){
      print("投稿エラー $e");
      return false;
    }
  }
  static Future<List<Post>?> getPostsFromIds(List<String> ids)async{//Idから自分の投稿内容の一蘭を取得
    List<Post> postList = [];
    try{
      await Future.forEach(ids, (String id)async{//自分の投稿のidであるidsというリストから自分の投稿のidを一つずつ取得する
        var doc = await posts.doc(id).get();//全体の投稿であるpostからポストidを元に自分の投稿内容を取得
        Map<String,dynamic> data = doc.data() as Map<String,dynamic>;
        Post post = Post(
          id: doc.id,
          content: data['content'],
          postAccountId: data['post_account_id'],
          createdTime: data['created_time']
        );
        postList.add(post);
      });
      print("自分の投稿を取得完了");
      return postList;//ポスト内容の入ったリストを返す
    }on FirebaseException catch(e){
      print("自分の投稿を取得エラー");
      return null;
    }

  }
}