import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_test/model/account.dart';
import 'package:firebase_test/model/post.dart';
import 'package:firebase_test/utils/authentication.dart';
import 'package:firebase_test/utils/firestore/posts.dart';
import 'package:firebase_test/utils/firestore/users.dart';
import 'package:firebase_test/view/edit_account_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Account myAccount = Authentication.myAccount!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
          backgroundColor: Theme.of(context).canvasColor,
          iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,//画面いっぱい
            child: Column(
              children: [
                Container(
                  color: Colors.white.withOpacity(0.3),
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            foregroundImage: NetworkImage(myAccount.imagePath),
                          ),
                          Column(
                            children: [
                              Text(myAccount.name),
                              Text("@${myAccount.userId}"),
                            ],
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          OutlinedButton(
                              onPressed: ()async{
                                  var result = await Navigator.push(context,MaterialPageRoute(builder:(context) => EditAccountPage()));//プロフィール編集画面にとぶ
                                  if(result ==true){
                                    myAccount = Authentication.myAccount!; //更新情報をmyAccountに格納
                                  }
                              },
                              child: Text("編集"))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(myAccount.selfIntroduction),
                    ],

                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border : Border(
                      bottom: BorderSide(
                        color: Colors.blue,
                        width: 3,
                      ),
                    ),
                  ),
                  child: const Text("投稿"),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: UserFirestore.users.doc(myAccount.id).collection('my_posts').orderBy('created_time',descending: true).snapshots(),//日時でソート
                    builder: (context, snapshot) {
                      if(snapshot.hasData){//投稿データがあるとき
                        List <String> mypostIds = List.generate(snapshot.data!.docs.length, (index){
                          return snapshot.data!.docs[index].id;
                        });
                        return FutureBuilder<List<Post>?>(
                          future: PostFirestore.getPostsFromIds(mypostIds),//自分の投稿データを取得
                          builder: (context, snapshot) {
                            if(snapshot.hasData){//投稿データがあるとき
                              return ListView.builder(
                                  itemCount: snapshot.data!.length, //ポストの数だけ
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context,index){
                                    Post post = snapshot.data![index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: index == 0 ? Border(
                                          top: BorderSide(color:  Colors.grey, width: 0),
                                          bottom:BorderSide(color:  Colors.grey, width: 0),
                                        ) : Border(bottom:BorderSide(color:  Colors.grey, width: 0)),
                                      ),//ListTitleを使う
                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: (){//TODO アイコンタップでプロフィール遷移
                                              print("アイコンタップ");
                                            },
                                            child: CircleAvatar(//アイコン
                                              radius: 22,
                                              foregroundImage: NetworkImage(myAccount.imagePath),//マイアカウントのイメージパス
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(myAccount.name,style: TextStyle(fontWeight: FontWeight.bold),),
                                                  Text("@${myAccount.userId}",style: TextStyle(color: Colors.grey),),
                                                ],
                                              ),
                                              Text(post.content),//TODO 改行できるようにする
                                              Text(DateFormat("H時m分 yyyy年 M月d日").format(post.createdTime!.toDate()),style: TextStyle(color: Colors.grey)),
                                              //intlライブラリdatetime型をstring型に      .todateでTimeStamp型からDateTime型に
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                              );
                            }else{//投稿データがないとき
                              return Container();
                            }
                          }
                        );
                      }else{//投稿データがない時
                        return Container();
                      }
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

