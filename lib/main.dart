import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_02/bloc/timer_bloc.dart';
import 'ticker.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

void main() => runApp(MyApp());
//todo: step 13 triển khai UI App
// MyApplà một StatelessWidgetcái sẽ quản lý việc khởi tạo và đóng một thể hiện của TimerBloc.
// Ngoài ra, nó đang sử dụng BlocProviderwidget để TimerBloc cung
// cấp phiên bản của chúng tôi cho các widget trong cây con của chúng tôi.
// Tiếp theo, chúng ta cần thực hiện Timerwidget của chúng tôi .

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(109, 234, 255, 1),
        accentColor: Color.fromRGBO(72, 74, 126, 1),
        brightness: Brightness.dark,
      ),
      title: 'Flutter Timer',
      home: BlocProvider(
        create: (context) => TimerBloc(ticker: Ticker()),
        child: Timer(),
      ),
    );
  }
}
//todo: Step 14
// Timer Tiện ích của chúng tôi sẽ chịu trách nhiệm hiển thị thời gian còn lại
// cùng với các nút thích hợp cho phép người dùng bắt đầu, tạm dừng và đặt lại bộ hẹn giờ.

class Timer extends StatelessWidget {
  static const TextStyle timerTextStyle = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Timer')),
      body: Stack(
        children: [
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100.0),
                child: Center(
                  child: BlocBuilder<TimerBloc, TimerState>(
                    builder: (context, state) {
                      final String minutesStr = ((state.duration / 60) % 60)
                          .floor()
                          .toString()
                          .padLeft(2, '0');
                      final String secondsStr = (state.duration % 60)
                          .floor()
                          .toString()
                          .padLeft(2, '0');
                      return Text(
                        '$minutesStr:$secondsStr',
                        style: Timer.timerTextStyle,
                      );
                    },
                  ),
                ),
              ),
              BlocBuilder<TimerBloc, TimerState>(
                condition: (previousState, state) =>
                    state.runtimeType != previousState.runtimeType,
                builder: (context, state) => Actions(),
              ),
            ],
          ),
        ],
      ),
    );
    // todo: step 17
//    Chúng tôi đã thêm một BlocBuildercái khác sẽ kết xuất Actionswidget; tuy nhiên, lần này chúng tôi đang sử dụng tính năng flutter_bloc mới được giới thiệu để kiểm soát tần suất Actions tiện ích được xây dựng lại (được giới thiệu trong v0.15.0).
// Nếu bạn muốn kiểm soát hạt mịn hơn khi builderhàm được gọi, bạn có thể cung cấp một tùy chọn conditionđể BlocBuilder. Các conditiontrạng thái khối trước và trạng thái khối hiện tại và trả về a boolean. Nếu condition trả về true, buildersẽ được gọi với statevà widget sẽ được xây dựng lại. Nếu conditiontrả về false, buildersẽ không được gọi với statevà không xây dựng lại sẽ xảy ra.
// Trong trường hợp này, chúng tôi không muốn Actionstiện ích được xây dựng lại trên mỗi tích tắc vì điều đó sẽ không hiệu quả. Thay vào đó, chúng tôi chỉ muốn Actionsxây dựng lại nếu runtimeTypenhững TimerStatethay đổi (Ready => Chạy, chạy => Tạm dừng, vv ...).
  }
}

//todo: step 15
// Cho đến nay, chúng tôi chỉ sử dụng BlocProvider để truy cập vào thể hiện của chúng tôi TimerBloc và
// sử dụng một BlocBuilder tiện ích để xây dựng lại giao diện người dùng mỗi khi chúng tôi nhận được một cái mới TimerState.
// Tiếp theo, chúng tôi sẽ triển khai Actionstiện ích con sẽ có các hành động phù hợp (bắt đầu, tạm dừng và đặt lại).
class Actions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _mapStateToActionButtons(
        timerBloc: BlocProvider.of<TimerBloc>(context),
      ),
    );
  }

  List<Widget> _mapStateToActionButtons({
    TimerBloc timerBloc,
  }) {
    final TimerState currentState = timerBloc.state;
    if (currentState is Ready) {
      return [
        FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () => {
            timerBloc.add(
              Start(duration: currentState.duration),
            ),
          },
        ),
      ];
    }
    if (currentState is Running) {
      return [
        FloatingActionButton(
          child: Icon(Icons.pause),
          onPressed: () => timerBloc.add(
            Pause(),
          ),
        ),
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => timerBloc.add(Reset()),
        ),
      ];
    }
    if (currentState is Paused) {
      return [
        FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () => timerBloc.add(Resume()),
        ),
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => timerBloc.add(Reset()),
        ),
      ];
    }
    if (currentState is Finished) {
      return [
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => timerBloc.add(Reset()),
        ),
      ];
    }
    return [];
  }
}
//todo: step 16
// Các Actionswidget chỉ là một StatelessWidget cái khác sử dụng BlocProvider để truy cập TimerBloc thể hiện và sau đó trả về khác nhau FloatingActionButtons dựa trên trạng thái hiện tại của TimerBloc.
// Mỗi trong số đó FloatingActionButtonsthêm một sự kiện trong onPressedcuộc gọi lại của nó để thông báo cho TimerBloc.
// Bây giờ chúng ta cần nối lên widget Actionscủa chúng ta Timer.

//todo: step 18: bối cảnh sóng

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [
            Color.fromRGBO(72, 74, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(184, 189, 245, 0.7)
          ],
          [
            Color.fromRGBO(72, 74, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(172, 182, 219, 0.7)
          ],
          [
            Color.fromRGBO(72, 73, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(190, 238, 246, 0.7)
          ],
        ],
        durations: [19440, 10800, 6000],
        heightPercentages: [0.03, 0.01, 0.02],
        gradientBegin: Alignment.bottomCenter,
        gradientEnd: Alignment.topCenter,
      ),
      size: Size(double.infinity, double.infinity),
      waveAmplitude: 25,
      backgroundColor: Colors.blue[50],
    );
  }
}
