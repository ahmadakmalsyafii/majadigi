import 'dart:typed_data';
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
  final Uint8List? imageBytes;
  final String? fileName;

  const SubmitHoaxReportEvent({
    required this.info,
    required this.source,
    this.imageBytes,
    this.fileName,
  });

  @override
  List<Object?> get props => [info, source, imageBytes, fileName];
}
