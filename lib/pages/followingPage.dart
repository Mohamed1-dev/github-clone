import 'package:flutter/material.dart';
import 'package:github_clone/models/user.dart';
import 'package:github_clone/providers/user_provider.dart';
import 'package:github_clone/requests/github_request.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class FollowingPage extends StatefulWidget {
  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  User user;
  List<User> users;

  @override
  Widget build(BuildContext context) {
    setState(() {
      user = Provider.of<UserProvider>(context).getUser();

      Github(user.login).fetchFolllowing().then((following) {
        Iterable list = json.decode(following.body);
        setState(() {
          users = list.map((model) => User.fromJson(model)).toList();
        });
      });
    });
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              brightness: Brightness.light,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey,
                ),
              ),
              backgroundColor: Colors.white,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(user.avatar_url),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(user.login, style: TextStyle(fontSize: 20))
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  height: 600,
                  child: users != null
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey[200])),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 60,
                                        height: 60,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              users[index].avatar_url),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(users[index].login,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey,
                                          ))
                                    ],
                                  ),
                                  Text('Following',
                                      style: TextStyle(color: Colors.blue))
                                ],
                              ),
                            );
                          },
                        )
                      : Container(
                          child: Align(
                            child: Text('Date is loafing ...'),
                          ),
                        ),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
