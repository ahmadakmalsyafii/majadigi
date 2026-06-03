import 'package:equatable/equatable.dart';

abstract class KlinikHoaksEvent extends Equatable {
  const KlinikHoaksEvent();

  @override
  List<Object?> get props => [];
}

class FetchKlinikHoaksDataEvent extends KlinikHoaksEvent {}

class SearchKlinikHoaksEvent extends KlinikHoaksEvent {
  final String query;
  final String category; // e.g. "Semua", "Hoaks", "Disinformasi", "Fakta", "Hate Speech"

  const SearchKlinikHoaksEvent({required this.query, required this.category});

  @override
  List<Object?> get props => [query, category];
}

class SubmitHoaxReportEvent extends KlinikHoaksEvent {
  final String info;
  final String source;
  final String? filePath;

  const SubmitHoaxReportEvent({
    required this.info,
    required this.source,
    this.filePath,
  });

  @override
  List<Object?> get props => [info, source, filePath];
}
