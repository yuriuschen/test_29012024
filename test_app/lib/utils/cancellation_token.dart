class CancellationToken {
  bool _isCanceled = false;

  bool get isCancellationRequested => _isCanceled;

  void cancel() {
    _isCanceled = true;
  }
}
