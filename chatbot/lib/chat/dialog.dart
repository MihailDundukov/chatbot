import 'package:chatbot/chat/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:link/link.dart';

class DialogView extends StatefulWidget {
  DialogView({Key key}) : super(key: key);

  @override
  _DialogViewState createState() => _DialogViewState();
}

class _DialogViewState extends State<DialogView> with TickerProviderStateMixin {
  List<Message> messageList;
  List<Message> listviewList;
  List<String> buttonList;
  int id = 0;
  AnimationController _messageWindowController;
  Animation _messageWindowAnimation;
  AnimationController _bunnyController;
  Animation<Offset> _bunnyAnimation;
  @override
  void initState() {
    super.initState();
    _bunnyController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _bunnyAnimation = Tween<Offset>(
      begin: const Offset(2.0, 3.0),
      end: const Offset(0.0, 0.0),
    ).animate(
        CurvedAnimation(parent: _bunnyController, curve: Curves.elasticIn));
    _messageWindowController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _messageWindowAnimation =
        CurvedAnimation(parent: _messageWindowController, curve: Curves.easeIn);
    _bunnyController.forward();
    _bunnyController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _bunnyController.stop();
      }
    });

    _messageWindowController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _messageWindowController.stop();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bunnyController.dispose();
    _messageWindowController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (messageList == null) {
      messageList = [];
    }
    if (listviewList == null) {
      listviewList = [];
    }
    if (buttonList == null) {
      buttonList = [];
      buttonList.add("Вызвать помощника");
    }
    _upgrageListView();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        height: size.height,
        width: size.width,
        child: Padding(
          padding: EdgeInsets.only(
            right: 20,
            top: 104,
          ),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80, right: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FadeTransition(
                    //чат
                    opacity: _messageWindowAnimation,
                    child: Container(
                      height: size.height / 1.5,
                      width: size.width / 4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ChatHeader(size, "Альфред",
                                  "Как говорил мой дед..."), //шапка
                              Container(
                                //диалоговое окно
                                height: size.height / 2 - 50,
                                width: size.width / 4,
                                child: ListView.builder(
                                  reverse: true,
                                  itemCount: listviewList.length,
                                  itemBuilder: (BuildContext context, int pos) {
                                    return MessageCard(listviewList[pos]);
                                  },
                                ),
                              ),
                              Container(
                                //кнопочки ответов
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(12),
                                        bottomLeft: Radius.circular(12))),
                                height: size.height / 6,
                                width: size.width / 4,
                                child: ListView.builder(
                                  itemCount: buttonList.length,
                                  itemBuilder:
                                      (BuildContext context, int poss) {
                                    return GestureDetector(
                                      onTap: () {
                                        _sendButtonData(
                                            context, buttonList[poss]);
                                      },
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: ButtonsCard(buttonList[poss]),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    // контейнер персонажа
                    onTap: () {
                      _messageWindowController.forward();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 60, left: 45),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: SlideTransition(
                          position: _bunnyAnimation,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    "images/Alfred_post.png",
                                  ),
                                  fit: BoxFit.fill),
                            ),
                            height: 220,
                            width: 150,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget ChatHeader(Size size, String name, String motto) {
    //шапка
    return Container(
      height: 50,
      width: size.width / 4,
      decoration: BoxDecoration(
        color: Colors.blue[800],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 40,
                width: 40,
                color: Colors.orange,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20, top: 10),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    motto,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _messageWindowController.reverse();
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(12)),
                ),
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget MessageCard(Message message) {
    return Padding(
      padding: message.from_bot == 0
          ? EdgeInsets.only(right: 15, bottom: 10, left: 60)
          : EdgeInsets.only(left: 15, bottom: 10, right: 60),
      child: Container(
        alignment: message.from_bot == 0
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
          decoration: BoxDecoration(
            color: message.from_bot == 0 ? Colors.grey[300] : Colors.grey[350],
            borderRadius: message.from_bot == 0
                ? BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12))
                : BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12)),
          ),
          child: message.link.isNotEmpty
              ? Link(
                  url: message.link,
                  child: Text(
                    message.text,
                    style: TextStyle(color: Colors.blue[300], fontSize: 12),
                  ),
                )
              : Text(
                  message.text,
                  style: TextStyle(
                      color: message.text == "Например такие..."
                          ? Colors.blue[300]
                          : Colors.black,
                      fontSize: 12),
                ),
        ),
      ),
    );
  }

  Widget ButtonsCard(String data) {
    return Padding(
      padding: EdgeInsets.only(left: 15, top: 10, right: 15),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 25,
          padding: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
          decoration: BoxDecoration(
            color: Colors.blue[800],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          child: Center(
            child: Text(
              data,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }

  void _upgrageListView() {
    setState(() {
      this.listviewList = messageList;
    });
  }

  void _sendMessage(BuildContext context, Message message) {
    setState(() {
      messageList.insert(0, message);
      this.id += 1;
    });
    _upgrageListView();
  }

  void _sendButtonData(BuildContext context, String data) {
    scenario(context, data).then((value) {
      setState(() {
        this.buttonList = value;
      });
    });
  }

  Future<List<String>> scenario(BuildContext context, String data) async {
    switch (data) {
      case "В начало":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context, Message(this.id, 1, "Чем могу Вам помочь?", ""));
          var list = [
            "Главная страница",
            "О проекте",
            "Обучение",
            "Вход/Регистрация",
            "Доп. информация"
          ];
          return list;
        }
      case "Вызвать помощника":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(
                  this.id,
                  1,
                  "Привет! Я бот Альфред! Помогатель-выручатель на сайте 'Россия - страна возможностей'. Итак...",
                  ""));
          await Future.delayed(Duration(seconds: 2));
          _sendMessage(
              context, Message(this.id, 1, "Небольшая инструкция:", ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(
                  this.id,
                  1,
                  "С помощью кнопок снизу Вы будете выбирать разделы, которые Вам нужны (они листабельны, нужно лишь провести пальцем или навести на них мышью и промотать), а я буду присылать в ответ подразделы или же ссылки на нужные страницы, которые будут голубого цвета. На них нужно лишь нажать!",
                  ""));
          await Future.delayed(Duration(seconds: 5));
          _sendMessage(context, Message(this.id, 1, "Например такие...", ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(context, Message(this.id, 1, "Начнём!", ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context, Message(this.id, 1, "Чем могу Вам помочь?", ""));
          var list = [
            "Главная страница",
            "О проекте",
            "Обучение",
            "Вход/Регистрация",
            "Доп. информация"
          ];
          return list;
        }
      case "Главная страница":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(this.id, 1, "Вот ссылка на главную страницу нашего сайта",
                  "https://rsv.ru/"));
          var list = [
            "О проекте",
            "Обучение",
            "Вход/Регистрация",
            "Доп. информация"
          ];
          return list;
        }
      case "О проекте":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context, Message(this.id, 1, "Информация о нашем проекте", ""));
          var list = [
            "В начало",
            "О нас",
            "Новости",
            "Наблюдательный совет",
            "Проекты",
            "Истории успеха",
            "Блог",
            "Вся команда",
            "Конкурсы",
            "Галерея"
          ];
          return list;
        }
      case "О нас":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(this.id, 1, "Вот информация о нас",
                  "https://rsv.ru/about-us/"));
          var list = ["В начало", "О проекте"];
          return list;
        }
      case "Новости":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(
                  this.id, 1, "Все свежие новости", "https://rsv.ru/news/"));
          var list = ["В начало", "О проекте"];
          return list;
        }
      case "Наблюдательный совет":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(this.id, 1, "Наш наблюдательный совет",
                  "https://rsv.ru/supervisory-board/"));
          var list = ["В начало", "О проекте"];
          return list;
        }
      case "Проекты":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(this.id, 1, "Все наши проекты",
                  "https://rsv.ru/competitions/contests/"));
          var list = ["В начало", "О проекте"];
          return list;
        }
      case "Истории успеха":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(context,
              Message(this.id, 1, "Истории успеха", "https://rsv.ru/success/"));
          var list = ["В начало", "О проекте"];
          return list;
        }
      case "Блог":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context, Message(this.id, 1, "Блог", "https://rsv.ru/blog/"));
          var list = ["В начало", "О проекте"];
          return list;
        }
      case "Вся команда":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(
                  this.id, 1, "Вся команда", "https://rsv.ru/about-us/team/"));
          var list = ["В начало", "О проекте"];
          return list;
        }
      case "Конкурсы":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(this.id, 1, "Конкурсы",
                  "https://rsv.ru/competitions/contests/"));
          var list = ["В начало", "О проекте"];
          return list;
        }
      case "Галерея":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(context,
              Message(this.id, 1, "Галерея", "https://rsv.ru/gallery/"));
          var list = ["В начало", "О проекте"];
          return list;
        }
      case "Обучение":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context, Message(this.id, 1, "Информация про обучение", ""));
          var list = [
            "В начало",
            "Онлайн-курсы",
            "Очные мероприятия",
            "Вебинары",
            "Тесты",
            'Программа "Наставничество"'
          ];
          return list;
        }
      case "Онлайн-курсы":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(
                  this.id, 1, "Онлайн-курсы", "https://rsv.ru/edu/courses/"));
          var list = ["В начало", "Обучение"];
          return list;
        }
      case "Очные мероприятия":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(this.id, 1, "Очные мероприятия",
                  "https://rsv.ru/edu/events/"));
          var list = ["В начало", "Обучение"];
          return list;
        }
      case "Вебинары":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(context,
              Message(this.id, 1, "Вебинары", "https://rsv.ru/edu/webinars/"));
          var list = ["В начало", "Обучение"];
          return list;
        }
      case "Тесты":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context, Message(this.id, 1, "Тесты", "https://rsv.ru/testing/"));
          var list = ["В начало", "Обучение"];
          return list;
        }
      case 'Программа "Наставничество"':
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(this.id, 1, 'Программа "Наставничество"',
                  "https://rsv.ru/mentoring/"));
          var list = ["В начало", "Обучение"];
          return list;
        }
      case "Вход/Регистрация":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context, Message(this.id, 1, "Выберите, что Вам нужно", ""));
          var list = ["В начало", "Вход", "Регистрация"];
          return list;
        }
      case "Вход":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(context,
              Message(this.id, 1, "Вход", "https://auth.rsv.ru/login/form"));
          var list = ["В начало", "Вход/Регистрация"];
          return list;
        }
      case "Регистрация":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(this.id, 1, "Регистрация",
                  "https://auth.rsv.ru/registration/form"));
          var list = ["В начало", "Вход/Регистрация"];
          return list;
        }
      case "Доп. информация":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(context,
              Message(this.id, 1, "Дополнительная информация для Вас", ""));
          var list = [
            "В начало",
            "Мы в соцсетях",
            "Трудоустройство",
            "Контакты",
            "Политика обработки персональных данных",
            "Пользовательское соглашение"
          ];
          return list;
        }
      case "Мы в соцсетях":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context, Message(this.id, 1, "Мы в социальных сетях!", ""));
          var list = [
            "В начало",
            "Доп. информация",
            "ВКонтакте",
            "Одноклассники",
            "Инстаграм",
            "Фейсбук",
            "Телеграм",
            "Ютуб"
          ];
          return list;
        }
      case "ВКонтакте":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(context,
              Message(this.id, 1, "Мы в ВКонтакте!", "https://vk.com/rsvru"));
          var list = ["В начало", "Доп. информация"];
          return list;
        }
      case "Одноклассники":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(
                  this.id, 1, "Мы в Одноклассниках!", "https://ok.ru/rsvru"));
          var list = ["В начало", "Доп. информация"];
          return list;
        }
      case "Инстаграм":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(this.id, 1, "Мы в Инстаграм!",
                  "https://www.instagram.com/rsv.ru/"));
          var list = ["В начало", "Доп. информация"];
          return list;
        }
      case "Фейсбук":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(this.id, 1, "Мы в Фейсбук!",
                  "https://www.facebook.com/anorsv"));
          var list = ["В начало", "Доп. информация"];
          return list;
        }
      case "Телеграм":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(this.id, 1, "Наш Телеграм-канал!",
                  "https://t.me/stranavozmojnostey"));
          var list = ["В начало", "Доп. информация"];
          return list;
        }
      case "Ютуб":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(this.id, 1, "Наш Ютуб-канал!",
                  "https://www.youtube.com/channel/UCJPc1Fjh9C8tPUo5qBEErMw"));
          var list = ["В начало", "Доп. информация"];
          return list;
        }
      case "Трудоустройство":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(
                  this.id, 1, "Найдите работу с нами", "https://trudvsem.ru/"));
          var list = ["В начало", "Доп. информация"];
          return list;
        }
      case "Контакты":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(this.id, 1, "Наши контактные данные!",
                  "https://rsv.ru/contacts/"));
          var list = ["В начало", "Доп. информация"];
          return list;
        }
      case "Политика обработки персональных данных":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(this.id, 1, "Политика обработки персональных данных",
                  "https://s3-cms.rsv.ru/a4ab0c5af82ae400423caf415c51f33362ee561240e3a53d9c465307fb81a7ea.pdf"));
          var list = ["В начало", "Доп. информация"];
          return list;
        }
      case "Пользовательское соглашение":
        {
          _sendMessage(context, Message(this.id, 0, data, ""));
          await Future.delayed(Duration(seconds: 1));
          _sendMessage(
              context,
              Message(this.id, 1, "Пользовательское соглашение",
                  "https://s3-cms.rsv.ru/720f72cf824a72142e6bab5b41fb1f6b9d2ca8cbc39551381b33e762ebe90ad7.doc"));
          var list = ["В начало", "Доп. информация"];
          return list;
        }
    }
  }
}
