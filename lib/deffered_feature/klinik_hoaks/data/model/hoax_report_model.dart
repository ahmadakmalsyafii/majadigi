import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class HoaxReportModel extends Equatable {
  final String? id;
  final String info;
  final String source;
  final String? imageUrl;
  final DateTime reportedAt;
  final String? userId;
  final String status;

  const HoaxReportModel({
    this.id,
    required this.info,
    required this.source,
    this.imageUrl,
    required this.reportedAt,
    this.userId,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'info': info,
      'source': source,
      'imageUrl': imageUrl,
      'reportedAt': FieldValue.serverTimestamp(),
      'userId': userId,
      'status': status,
    };
  }

  factory HoaxReportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HoaxReportModel(
      id: doc.id,
      info: data['info'] ?? '',
      source: data['source'] ?? '',
      imageUrl: data['imageUrl'],
      reportedAt: (data['reportedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: data['userId'],
      status: data['status'] ?? 'pending',
    );
  }

  @override
  List<Object?> get props => [id, info, source, imageUrl, reportedAt, userId, status];
}
