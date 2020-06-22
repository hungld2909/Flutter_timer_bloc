import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import  '../ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

//todo: Step 2.
// Chúng ta sẽ bắt đầu bằng cách xác định cái TimerStates mà chúng ta TimerBloc có thể ở.
// Nhà TimerBloc nước của chúng tôi có thể là một trong những điều sau đây:
// Sẵn sàng - sẵn sàng để bắt đầu đếm ngược từ thời lượng quy định.
// Chạy - tích cực đếm ngược từ thời lượng quy định.
// Tạm dừng - tạm dừng ở một số thời gian còn lại.
// Hoàn thành - hoàn thành với thời gian còn lại là 0.
// Mỗi trạng thái này sẽ có một hàm ý về những gì người dùng nhìn thấy.

//  Ví dụ:
// nếu trạng thái đã sẵn sàng, thì người dùng sẽ có thể bắt đầu hẹn giờ.
// nếu trạng thái đang chạy, thì người dùng sẽ có thể tạm dừng và đặt lại bộ hẹn giờ cũng như xem thời lượng còn lại.
// nếu trạng thái bị tạm dừng, người dùng sẽ có thể tiếp tục bộ hẹn giờ và đặt lại bộ hẹn giờ.
// Nếu trạng thái đã kết thúc, thì người dùng sẽ có thể đặt lại bộ hẹn giờ.

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  final int _duration = 60;
//todo: step 5.
// Điều đầu tiên chúng ta cần làm là xác định cái initialStatecủa chúng ta TimerBloc. 
// Trong trường hợp này, chúng tôi muốn TimerBloc bắt đầu ở Ready trạng thái với thời lượng đặt trước là 1 phút (60 giây).
  StreamSubscription<int> _tickerSubscription;

  TimerBloc({@required Ticker ticker})
      : assert(ticker != null),
        _ticker = ticker;

  //todo: step 6.
  // Tiếp theo, chúng ta cần xác định sự phụ thuộc vào chúng ta Ticker.
  @override
  TimerState get initialState => Ready(_duration);

  @override
  void onTransition(Transition<TimerEvent, TimerState> transition) {
    print(transition);
    super.onTransition(transition);
  }

//todo: step 7
// Chúng tôi cũng đang xác định một StreamSubscription cho chúng tôi Ticker mà chúng tôi sẽ nhận được để trong một chút.
// Tại thời điểm này, tất cả những gì còn lại phải làm là thực hiện mapEventToState. Để cải thiện khả năng đọc, 
// tôi muốn tách từng trình xử lý sự kiện thành chức năng trợ giúp riêng của nó. Chúng ta sẽ bắt đầu với Start sự kiện này.
  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    if (event is Start) {
      yield* _mapStartToState(event); //! sự kiện bắt đầu chạy ứng dụng
    } else if (event is Pause) {
      yield* _mapPauseToState(event); //! sự kiện dừng ứng dụng
    } else if (event is Resume) {
      yield* _mapResumeToState(event); //! sự kiện tiếp tục chạy ứng dụng
    } else if (event is Reset) {
      yield* _mapResetToState(event); //! sự kiện reset ứng dụng
    } else if (event is Tick) {
      yield* _mapTickToState(event); //! lưu lại thời gian tức thời.
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
     // Chúng ta cũng cần ghi đè close phương thức trên TimerBloc để có thể hủy bỏ _tickerSubscriptionkhi TimerBloc đóng.
  }

  Stream<TimerState> _mapStartToState(Start start) async* {
    yield Running(start.duration);
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: start.duration)
        .listen((duration) => add(Tick(duration: duration)));
  }
  //todo: step 8
  // Nếu TimerBloc nhận được một Start sự kiện, nó sẽ đẩy một Running trạng thái với thời lượng bắt đầu. 
  // Ngoài ra, nếu đã có một mở, _tickerSubscriptionchúng ta cần hủy bỏ nó để giải phóng bộ nhớ. 
  // Chúng ta cũng cần ghi đè close phương thức trên TimerBloc để có thể hủy bỏ _tickerSubscriptionkhi TimerBloc đóng. 
  // Cuối cùng, chúng tôi lắng nghe _ticker.tick luồng và trên mỗi tích tắc, 
  // chúng tôi thêm một Tick sự kiện với thời lượng còn lại.

  Stream<TimerState> _mapPauseToState(Pause pause) async* {
    if (state is Running) {
      _tickerSubscription?.pause();
      yield Paused(state.duration);
    }
  }
  //todo: step 10
//   Trong _mapPauseToState khi state của chúng tôi TimerBloc là Running, 
//   sau đó chúng ta có thể tạm dừng _tickerSubscriptionvà đẩy một Paused nhà nước với thời gian hẹn giờ hiện hành.
//   Tiếp theo, hãy thực hiện Resume trình xử lý sự kiện để chúng ta có thể bỏ tạm dừng bộ hẹn giờ.

  Stream<TimerState> _mapResumeToState(Resume resume) async* {
    if (state is Paused) {
      _tickerSubscription?.resume();
      yield Running(state.duration);
    }
  }
  //todo: step 11
  // Trình Resume xử lý sự kiện rất giống với Pause trình xử lý sự kiện. 
  // Nếu TimerBloc có một statesố Paused và nó nhận được một Resume sự kiện, 
  // sau đó nó tiếp tục lại các _tickerSubscriptionvà đẩy một Running nhà nước với thời gian hiện tại.
  // Cuối cùng, chúng ta cần thực hiện Reset xử lý sự kiện.

  Stream<TimerState> _mapResetToState(Reset reset) async* {
    _tickerSubscription?.cancel();
    yield Ready(_duration);
  }
//todo: step12
// Nếu TimerBloc nhận được một Reset sự kiện, 
// nó cần hủy bỏ dòng điện _tickerSubscription
//  để nó không được thông báo về bất kỳ dấu tích bổ sung nào và đẩy một Ready trạng thái với thời lượng ban đầu.


  Stream<TimerState> _mapTickToState(Tick tick) async* {
    yield tick.duration > 0 ? Running(tick.duration) : Finished();
  }
}
//todo: step 9
// Mỗi khi Tick nhận được một sự kiện, nếu thời lượng của đánh dấu lớn hơn 0, 
// chúng ta cần đẩy Running trạng thái cập nhật với thời lượng mới. 
// Mặt khác, nếu thời lượng của tick là 0, 
// bộ đếm thời gian của chúng tôi đã kết thúc và chúng ta cần đẩy một Finished trạng thái.