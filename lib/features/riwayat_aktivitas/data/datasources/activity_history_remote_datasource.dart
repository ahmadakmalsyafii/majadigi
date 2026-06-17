import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../models/activity_history_model.dart';

abstract class ActivityHistoryRemoteDataSource {
  Future<List<ActivityHistoryModel>> getActivityHistories(String userId);
  Future<void> saveActivityHistory(ActivityHistoryModel activityHistory);
}

@LazySingleton(as: ActivityHistoryRemoteDataSource)
class ActivityHistoryRemoteDataSourceImpl implements ActivityHistoryRemoteDataSource {
  final FirebaseFirestore firestore;

  ActivityHistoryRemoteDataSourceImpl({FirebaseFirestore? firestore}) : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<ActivityHistoryModel>> getActivityHistories(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('activity_histories')
          .where('user_id', isEqualTo: userId)
          .orderBy('date_booked', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ActivityHistoryModel.fromJson(data);
      }).toList();
    } catch (e) {
      print('🔥 ActivityHistoryRemoteDataSource error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> saveActivityHistory(ActivityHistoryModel activityHistory) async {
    try {
      final docRef = firestore.collection('activity_histories').doc(activityHistory.id);
      await docRef.set(activityHistory.toJson());
    } catch (e) {
      throw ServerException();
    }
  }
}
