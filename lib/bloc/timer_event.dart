part of 'timer_bloc.dart';
// Tiếp theo, hãy xác định và thực hiện cái TimerEvents mà chúng ta TimerBloc sẽ xử lý.
//todo Step 4:
// timerBloc sẽ xử lý timer_event

// TimerEvent
// Chúng tôi TimerBloc sẽ cần biết cách xử lý các sự kiện sau:
// Bắt đầu - thông báo cho TimerBloc rằng bộ hẹn giờ sẽ được khởi động.
// Tạm dừng - thông báo cho TimerBloc rằng nên tạm dừng bộ hẹn giờ.
// Tiếp tục - thông báo cho TimerBloc rằng bộ định thời sẽ được nối lại.
// Đặt lại - thông báo cho TimerBloc rằng bộ hẹn giờ sẽ được đặt lại về trạng thái ban đầu.
// Tick ​​- thông báo cho TimerBloc rằng một đánh dấu đã xảy ra và nó cần cập nhật trạng thái tương ứng.
abstract class TimerEvent extends Equatable {
  const TimerEvent();
// timer_Bloc sẽ xử lý timer_event
  @override
  List<Object> get props => [];
}

class Start extends TimerEvent {
  // Bắt đầu - thông báo cho TimerBloc rằng bộ hẹn giờ sẽ được khởi động.
  final int duration;

  const Start({@required this.duration});

  @override
  String toString() => "Start { duration: $duration }";
}

class Pause extends TimerEvent {
  // Tạm dừng - thông báo cho TimerBloc rằng nên tạm dừng bộ hẹn giờ.
}

class Resume extends TimerEvent {
  // Đặt lại - thông báo cho TimerBloc rằng bộ hẹn giờ sẽ được đặt lại về trạng thái ban đầu.
}

class Reset extends TimerEvent {
  // Đặt lại - thông báo cho TimerBloc rằng bộ hẹn giờ sẽ được đặt lại về trạng thái ban đầu.
}

class Tick extends TimerEvent {
  // Tick ​​- thông báo cho TimerBloc rằng một đánh dấu đã xảy ra và nó cần cập nhật trạng thái tương ứng.
  final int duration;

  const Tick({@required this.duration});

  @override
  List<Object> get props => [duration];

  @override
  String toString() => "Tick { duration: $duration }";
}

