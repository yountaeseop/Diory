import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      // home: const MyHomePage(title: 'Who\'s diary'),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/my': (context) => MyHomePage(title: 'Who\'s diary'),
      },
    );
  }
}

// -------------------------------------------------------------------
// -------------------------------------------------------------------

// back arrow 누르면 나타나는 페이지
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          onPressed: () => Navigator.pushNamed(context, '/my'),
          child: Text('nextpage'),
        ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        // 중앙 정렬
        elevation: 0.0,
        // 앱바 밑에 내려오는 그림자 조절 가능
        backgroundColor: Colors.grey,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     FocusManager.instance.primaryFocus?.unfocus();
        //     print('back button is clicked');
        //   },
        // ),

        // 텍스트 필드 누르면 키보드가 올라옴과 동시에 우측 상단 햄버거 메뉴가
        // 완료 TextButton으로 바뀌고 완료를 누르면 키보드가 내려가게 하는 이벤트
        actions: [
          if (MediaQuery.of(context).viewInsets.bottom > 0)
          TextButton(
            onPressed: FocusManager.instance.primaryFocus?.unfocus,
            child: Text('완료', style: TextStyle(color: Colors.white)),
          ),
        ],
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.menu),
        //     onPressed: () {
        //       print('menu button is clicked');
        //     },
        //   ),
        // ],
      ),
      endDrawer: Drawer( // 햄버거 menu아이콘을 만들지 않아야 나온다!!! -> 햄버거 아이콘을 자동적으로 만들어줌
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      // ------------------------------------------------------

      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            TextField(
              style: TextStyle(fontSize: 30.0),
              decoration: InputDecoration(
                // font 변경방법?

                labelText: '제목을 입력하세요',
                isDense: true,
              ),
              minLines: 60,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ],

        ),
      ),

      // ---------------------------------------------------------

      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        //animatedIcon: AnimatedIcons.menu_close, -> 기본아이콘이 햄버거로 정해져있음.

        children: [
          SpeedDialChild(
            child: Icon(Icons.share_rounded),
            label: 'return'
          ),
          SpeedDialChild(
            child: Icon(Icons.mail),
              label: 'font change'
          ),
          SpeedDialChild(
            child: Icon(Icons.copy),
              label: 'text'
          ),
          SpeedDialChild(
              child: Icon(Icons.copy),
              label: 'sticker'
          ),
          SpeedDialChild(
              child: Icon(Icons.copy),
              label: 'gallery'
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      // floatingActionButton의 위치 변경


    );
  }
}