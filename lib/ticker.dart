//todo: Step 1.

class Ticker {
  Stream<int> tick({int ticks}) {
    return Stream.periodic(Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}

//todo1: Tất cả các Ticker lớp của chúng tôi làm là hiển thị một hàm đánh dấu lấy số lượng giây mà chúng tôi muốn và trả về một luồng phát ra các giây còn lại mỗi giây.
//todo2: Tiếp theo, chúng ta cần tạo ra TimerBloc cái mà chúng ta sẽ tiêu thụ Ticker.
