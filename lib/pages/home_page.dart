import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:health_bot/bloc/chat_bloc.dart';
import 'package:health_bot/models/chat_message_model.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatBloc chatBloc = ChatBloc();
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case ChatSuccessState:
              List<ChatMessageModel> messages =
                  (state as ChatSuccessState).messages;
              return Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/health_bg.jpg'),
                          fit: BoxFit.cover)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Health & Wellness Bot",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 24),
                            ),
                            Icon(
                              Icons.image_search,
                              color: Theme.of(context).primaryColor,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = state.messages[index];
                          return Container(
                              margin: const EdgeInsets.only(
                                  bottom: 12.0, left: 16, right: 16),
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  // ignore: deprecated_member_use
                                  color: Colors.teal.withOpacity(0.2)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.role == "user"
                                        ? "User"
                                        : "Health Bot",
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: message.role == "user"
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                        color: message.role == "user"
                                            ? Colors.teal
                                            : Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  message.role == "model"
                                      ? Card(
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          margin:
                                              EdgeInsets.symmetric(vertical: 6),
                                          // ignore: deprecated_member_use
                                          color: Colors.white.withOpacity(0.95),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: MarkdownBody(
                                              data: message.parts.first.text,
                                              styleSheet: MarkdownStyleSheet(
                                                p: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                                strong: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                listBullet: TextStyle(
                                                    color: Colors.teal),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Text(
                                          message.parts.first.text,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                ],
                              ));
                        },
                      )),
                      if (chatBloc.generating)
                        Row(
                          children: [
                            Container(
                                height: 100,
                                width: 100,
                                child: Lottie.asset('assets/loader.json')),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                                child: TextField(
                              controller: textEditingController,
                              style: TextStyle(color: Colors.black),
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                fillColor: Colors.white,
                                hintText: "Ask Something from AI",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor)),
                              ),
                            )),
                            SizedBox(
                              width: 12,
                            ),
                            InkWell(
                              onTap: () {
                                if (textEditingController.text.isNotEmpty) {
                                  String text = textEditingController.text;
                                  print("Swami ${text}");
                                  textEditingController.clear();
                                  chatBloc.add(ChatGenerateNewTextMessageEvent(
                                      inputMessage: text));
                                }
                              },
                              child: CircleAvatar(
                                radius: 32,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.teal,
                                    child: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    )),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ));

            default:
              return SizedBox();
          }
        },
      ),
    );
  }
}
