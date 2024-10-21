import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/Models/post_model.dart';

class PostScreenPage extends StatefulWidget {
  PostScreenPage({super.key});

  @override
  State<PostScreenPage> createState() => _PostScreenPageState();
}

class _PostScreenPageState extends State<PostScreenPage> {
  Color _categorySelectionBarColor = const Color(0xfff48a34);

  final List<PostModel> postList = [
    PostModel(
        id: 1,
        userId: 101,
        userPhoto:
        "https://i.pinimg.com/236x/13/ab/2f/13ab2fae304fe99a17038a9036a9c3c5.jpg",
        userData: "User 1",
        postContentTitle:
        "This is the first post content.amnsdbambdmnasdmnabsdmnnabsdmnabsdmnnbamndsbamnsbdmnnsbbamndba",
        postContent:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sed condimen",
        postDate: "2024-10-01",
        postLocation: "Location 1",
        postCategory: 0),
    PostModel(
        id: 2,
        userId: 102,
        userPhoto:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQV5hHxTLXXUT6BRNyMjxZ4VSgI38jAcBMHEw&s",
        userData: "User 2",
        postContentTitle: "This is the second post content.",
        postContent:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sed condimen",
        postDate: "2024-10-01",
        postLocation: "Location 2",
        postCategory: 1),
    PostModel(
        id: 3,
        userId: 103,
        userPhoto:
        "https://blog.teknosa.com/wp-content/uploads/2021/09/profil-fotografi-nasil-cekilmeli-teknosa.jpg",
        userData: "User 3",
        postContentTitle: "This is the third post content.",
        postContent:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sed condimen",
        postDate: "2024-10-01",
        postLocation: "Location 3",
        postCategory: 2),
    PostModel(
        id: 4,
        userId: 104,
        userPhoto:
        "https://i.pinimg.com/736x/b3/3a/6b/b33a6b1309694293b744e98714ba3bec.jpg",
        userData: "User 4",
        postContentTitle: "This is the fourth post content.",
        postContent:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sed condimen",
        postDate: "2024-10-01",
        postLocation: "Location 4",
        postCategory: 1),
    PostModel(
        id: 5,
        userId: 105,
        userPhoto:
        "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
        postContent:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sed condimen",
        userData: "User 5",
        postContentTitle: "This is the fifth post content.",
        postDate: "2024-10-01",
        postLocation: "Location 5",
        postCategory: 2),
  ];

  List<List<String>> _categories = [
    ["assets/svg/volleyball.svg", "Voleybol"],
    ["assets/svg/paw.svg", "Patiler"],
    ["assets/svg/megaphone.svg", "Duyuru"]
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: width,
          child: Image.asset(
            "assets/images/motorlar2.png",
            fit: BoxFit.fill,
          ),
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(
                right: width * 0.05, left: width * 0.05, top: width * 0.05),
            child: Column(
              children: [
                _categorySelectionBar(),
                SizedBox(
                  height: width * 0.01,
                ),
                Flexible(
                    child: ListView.builder(
                      itemCount: postList.length,
                      itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            context.go('/postScreenPage/postContentScreenPage',
                                extra: postList[index]);
                          },
                          child: PostItem(
                            postModel: postList[index],
                            categories: _categories,
                          )),
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }

  Container _categorySelectionBar() {
    Color choiceCategoryTextColor = Colors.white;
    Color categorySelectionBarItemColor = Colors.white;
    return Container(
      decoration: BoxDecoration(
          color: _categorySelectionBarColor,
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.add_circle,
              size: 36,
              color: categorySelectionBarItemColor,
            ),
            Row(
              children: [
                Text(
                  "Kategori Seç",
                  style: TextStyle(color: choiceCategoryTextColor),
                ),
                Icon(
                  Icons.arrow_drop_down_circle,
                  size: 36,
                  color: categorySelectionBarItemColor,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PostItem extends StatelessWidget {
  final PostModel postModel;
  final List<List<String>> categories;

  const PostItem({
    Key? key,
    required this.postModel,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userData = postModel.userData!;
    String postContent = postModel.postContentTitle!;
    String postDate = postModel.postDate!;
    String postLocation = postModel.postLocation!;
    String userPhoto = postModel.userPhoto!;
    int postCategoryIconPathIndex = postModel.postCategory!;
    String postCategoryIconPath = categories[postCategoryIconPathIndex][0];
    String postCategoryName = categories[postCategoryIconPathIndex][1];

    Color postBackgroundColor = const Color(0xffd9d9d9);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: postBackgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(border: Border.all()),
                    height: 100,
                    width: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: ClipRRect(
                          child: Image.network(
                            userPhoto,
                            fit: BoxFit.fill,
                          )),
                    )),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        postContent,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    SvgPicture.asset(
                      postCategoryIconPath,
                      height: 50,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 5),
                    Text(postCategoryName,
                        style: Theme.of(context).textTheme.titleMedium)
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(postDate, style: Theme.of(context).textTheme.titleSmall),
                Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      color: Colors.black54,
                      size: 16,
                    ),
                    const SizedBox(width: 3),
                    Text(postLocation,
                        style: Theme.of(context).textTheme.labelSmall),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
