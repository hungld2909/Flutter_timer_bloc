part of 'timer_bloc.dart';
//todo: Step 3.
// Lưu ý rằng tất cả các phần TimerStates mở rộng của lớp cơ sở trừu tượng TimerState 
// có thuộc tính thời lượng. Điều này là do cho dù chúng ta TimerBlocđang ở trạng thái nào , 
// chúng ta muốn biết thời gian còn lại là bao nhiêu.
abstract class TimerState extends Equatable {
  final int duration; // tính thời lượng 

  const TimerState(this.duration);

  @override
  List<Object> get props => [duration];
}

class Ready extends TimerState {
  const Ready(int duration) : super(duration);
  // thời lượng sẵn sàng chạy
  @override
  String toString() => 'Ready { duration: $duration }';
}

class Paused extends TimerState {
  const Paused(int duration) : super(duration);
  // Paused thời lượng
  @override
  String toString() => 'Paused { duration: $duration }';
}

class Running extends TimerState {
  const Running(int duration) : super(duration);
  // thời lượng đang chạy
  @override
  String toString() => 'Running { duration: $duration }';
}

class Finished extends TimerState {
  const Finished() : super(0);
  // khi thời lượng hoàn thành và kết thúc
  // ấn nút reset để chạy lại ứng dụng
}

