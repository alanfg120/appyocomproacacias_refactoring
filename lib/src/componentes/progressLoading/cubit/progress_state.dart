part of 'progress_cubit.dart';

class ProgressState extends Equatable {

  final double progress;

  const ProgressState({required this.progress});
 
  factory ProgressState.initial() => ProgressState(progress: 0.0);
  
  ProgressState copyWith({double? progress}) => ProgressState(progress: progress ?? this.progress);

  @override
  List<Object> get props => [progress];
}


