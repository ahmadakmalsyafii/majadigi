part of 'navigation_bloc.dart';

// navigation_event.dart
abstract class NavigationEvent extends Equatable {
  const NavigationEvent();
}

class NavigationTabChanged extends NavigationEvent {
  final int tabIndex;
  const NavigationTabChanged(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}