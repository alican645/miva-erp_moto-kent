import 'package:flutter/material.dart';
import 'package:moto_kent/Models/chat_group_model.dart';

class ChatGroupsPage extends StatefulWidget {
  const ChatGroupsPage({super.key});

  @override
  State<ChatGroupsPage> createState() => _ChatGroupsPageState();
}

class _ChatGroupsPageState extends State<ChatGroupsPage> {
  List<ChatGroupModel> groupList = [
    ChatGroupModel(
        id: 1,
        groupName: "Tech Enthusiasts",
        groupContent: "A group for people who love technology.",
        groupIcon: 0,
        membersNumber: 5,
        maxMembersNumber: 35),
    ChatGroupModel(
        id: 2,
        groupName: "Flutter Developers",
        groupContent: "Discussion and support for Flutter projects.",
        groupIcon: 4,
        membersNumber: 15,
        maxMembersNumber: 25),
    ChatGroupModel(
        id: 3,
        groupName: "Travel Bloggers",
        groupContent: "Sharing experiences and tips on travel.",
        groupIcon: 3,
        membersNumber: 20,
        maxMembersNumber: 30),
    ChatGroupModel(
        id: 4,
        groupName: "Photography Club",
        groupContent: "A place for photographers to share and learn.",
        groupIcon: 2,
        membersNumber: 110,
        maxMembersNumber: 120),
    ChatGroupModel(
        id: 5,
        groupName: "Fitness Fans",
        groupContent: "Fitness tips, routines, and challenges.",
        groupIcon: 1,
        membersNumber: 70,
        maxMembersNumber: 100),
  ];

  List<Icon> groupIcons = [
    const Icon(Icons.biotech_outlined, color: Colors.white, size: 36),
    const Icon(Icons.fitness_center_outlined, color: Colors.white, size: 36),
    const Icon(Icons.photo_camera_back_outlined, color: Colors.white, size: 36),
    const Icon(Icons.travel_explore_outlined, color: Colors.white, size: 36),
    const Icon(Icons.flutter_dash_outlined, color: Colors.white, size: 36),
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
          left: width * 0.05, right: width * 0.05, top: width * 0.01),
      child: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: groupList.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.50),
                child: ChatGroupItem(
                  chatGroupModel: groupList[index],
                  groupIcons: groupIcons,
                  groupIconBackgroundColor:
                      Theme.of(context).colorScheme.primary,
                  itemBackgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButton(
                    icon: const Icon(
                      Icons.person_2_outlined,
                      size: 48,
                    ),
                    content: "Gruplarım"),
                _buildButton(
                    icon: const Icon(
                      Icons.add,
                      size: 48,
                    ),
                    content: "Oluştur"),
                _buildButton(
                    icon: const Icon(
                      Icons.search_rounded,
                      size: 48,
                    ),
                    content: "Ara")
              ],
            ),
          )
        ],
      ),
    );
  }

  Column _buildButton({required Icon icon, required String content}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: icon,
        ),
        Text(content,style: Theme.of(context).textTheme.headlineSmall,)
      ],
    );
  }
}




class ChatGroupItem extends StatelessWidget {
  final ChatGroupModel chatGroupModel;
  final List<Icon> groupIcons;
  final Color groupIconBackgroundColor;
  final Color itemBackgroundColor;

  const ChatGroupItem({super.key,
    required this.chatGroupModel,
    required this.groupIcons,
    required this.groupIconBackgroundColor,
    required this.itemBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: itemBackgroundColor,
        borderRadius: BorderRadius.circular(90),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundColor: groupIconBackgroundColor,
              radius: 30,
              child: groupIcons[chatGroupModel.groupIcon!],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  chatGroupModel.groupName!,
                  style: Theme.of(context).textTheme.headlineLarge
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        chatGroupModel.groupContent!,
                        style:Theme.of(context).textTheme.headlineSmall ,
                      ),
                    ),
                    Expanded(
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                                "${chatGroupModel.membersNumber}/${chatGroupModel.maxMembersNumber}",style:Theme.of(context).textTheme.headlineSmall,),))
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                )),
          ),
        ],
      ),
    );
  }
}
