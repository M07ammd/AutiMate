import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'package:atuimate_app/screens/parent/parent_home.dart';

class Post {
  String id;
  String name;
  String time;
  String text;
  bool liked;
  bool saved;
  int likes;

  Post({
    required this.id,
    required this.name,
    required this.time,
    required this.text,
    this.liked = false,
    this.saved = false,
    this.likes = 0,
  });
}

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  int tabIndex = 0;
  bool isLoading = true;
  List<Post> allPosts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    setState(() => isLoading = true);

    try {
      final response = await ApiService().getCommunityPosts(
        sort: "latest",
      );
      List<dynamic> data = response.data["posts"] ?? [];
      setState(() {
        allPosts = data.map((item) {
          return Post(
            id: item['id'] ?? "",
            name: item['author']?['fullName'] ?? "Unknown Parent",
            time: "Recent",
            text: item['content'] ?? "",
            likes: item['likesCount'] ?? 0,
            liked: item['isLiked'] ?? false,
            saved: item['isSaved'] ?? false,
          );
        }).toList();
      });
    } catch (e) {
      print("FETCH ERROR: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }
  Future<void> toggleLike(Post post) async {
    bool old = post.liked;

    setState(() {
      post.liked = !old;
      post.likes += old ? -1 : 1;
    });

    try {
      if (old) {
        await ApiService().unlikePost(post.id);
      } else {
        await ApiService().likePost(post.id);
      }
    } catch (e) {
      setState(() {
        post.liked = old;
        post.likes += old ? 1 : -1;
      });
    }
  }
  Future<void> toggleSave(Post post) async {
    bool old = post.saved;

    setState(() => post.saved = !old);

    try {
      if (old) {
        await ApiService().unsavePost(post.id);
      } else {
        await ApiService().savePost(post.id);
      }
    } catch (e) {
      setState(() => post.saved = old);
    }
  }

  Future<void> deletePostItem(String postId) async {
    try {
      await ApiService().deletePost(postId);

      setState(() {
        allPosts.removeWhere((p) => p.id == postId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Delete failed")),
      );
    }
  }

  void addPostSheet() {
    TextEditingController controller = TextEditingController();
    bool isPosting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Create Post",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  TextField(controller: controller, maxLines: 4),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: isPosting
                        ? null
                        : () async {
                      if (controller.text.isEmpty) return;
                      setModalState(() => isPosting = true);

                      try {
                        final res =
                        await ApiService().createCommunityPost(
                          content: controller.text,
                        );

                        Navigator.pop(sheetContext);

                        setState(() {
                          tabIndex = 0;
                          allPosts.insert(
                            0,
                            Post(
                              id: res.data['id'],
                              name: res.data['author']?['fullName'] ??
                                  "You",
                              time: "Now",
                              text: controller.text,
                            ),
                          );
                        });

                        await fetchPosts();
                      } catch (e) {
                        setModalState(() => isPosting = false);
                      }
                    },
                    child: isPosting
                        ? const CircularProgressIndicator()
                        : const Text("Post"),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  void commentsSheet(String postId) {
    TextEditingController controller = TextEditingController();
    List comments = [];
    bool isLoadingComments = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(builder: (context, setModalState) {
          Future<void> fetchComments() async {
            try {
              final res = await ApiService().getPostComments(postId);
              comments = res.data["comments"] ?? [];
            } catch (e) {
              print("COMMENTS ERROR: $e");
            }
            setModalState(() => isLoadingComments = false);
          }

          if (isLoadingComments) fetchComments();

          return Padding(
            padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                const Text("Comments",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Divider(),

                isLoadingComments
                    ? const CircularProgressIndicator()
                    : SizedBox(
                  height: 300,
                  child: comments.isEmpty
                      ? const Center(child: Text("No comments yet"))
                      : ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (_, i) {
                      final c = comments[i];
                      return ListTile(
                        leading: const CircleAvatar(
                            radius: 15,
                            child: Icon(Icons.person, size: 15)),
                        title:
                        Text(c["author"]?["fullName"] ?? "User"),
                        subtitle: Text(c["content"] ?? ""),
                      );
                    },
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: "Add a comment...",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                          ),
                        )),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xff49B388),),
                      onPressed: () async {
                        if (controller.text.isEmpty) return;

                        await ApiService().addComment(
                          postId: postId,
                          content: controller.text,
                        );

                        controller.clear();

                        final res =
                        await ApiService().getPostComments(postId);

                        setModalState(() {
                          comments = res.data["comments"] ?? [];
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Post> displayPosts = allPosts;

    if (tabIndex == 1) {
      displayPosts = [...allPosts]..sort((a, b) => b.likes.compareTo(a.likes));
    } else if (tabIndex == 2) {
      displayPosts = allPosts.where((p) => p.saved).toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        toolbarHeight: 80,

        title: const Text("Community",
          style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: Color(0xFF1D3557),
        ),),
        centerTitle: true,
        backgroundColor: Colors.white,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
          color: Color(0xFF1D3557),),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => ParentHome()),
                  (route) => false,
            );

          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF45BB89),
        onPressed: addPostSheet,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              tab("Latest", 0),
              tab("Most Liked", 1),
              tab("Saved", 2)
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: displayPosts.length,
              itemBuilder: (context, index) {
                final post = displayPosts[index];

                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color:  const Color(0xffF1F1F1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(radius: 20),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(post.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(post.time,
                                      style: TextStyle(
                                          color: Colors.grey.shade500)),
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () =>
                                deletePostItem(post.id),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(post.text),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          actionItem(
                            icon: Icons.favorite,
                            label: "Like (${post.likes})",
                            color: post.liked
                                ? Colors.red
                                : Colors.black,
                            onTap: () => toggleLike(post),
                          ),
                          const SizedBox(width: 15),
                          actionItem(
                            icon: Icons.comment,
                            label: "Comments",
                            color: Colors.black,
                            onTap: () =>
                                commentsSheet(post.id),
                          ),
                          const SizedBox(width: 15),
                          actionItem(
                            icon: Icons.bookmark,
                            label: "Save",
                            color: post.saved
                                ? Color(0xFF45BB89)
                                : Colors.black,
                            onTap: () => toggleSave(post),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget tab(String title, int index) {
    return GestureDetector(
      onTap: () => setState(() => tabIndex = index),
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: tabIndex == index
              ?  Color(0xFF45BB89)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: tabIndex == index
                ? Colors.white
                : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

Widget actionItem({
  required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Row( 
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: color)),
      ],
    ),
  );
}