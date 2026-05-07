
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/features/auth/data/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _CachedUser = 'CACHED_USER';
abstract class AuthLocalDataSource {
  Future<UserModel> getCachedUser();

  Future<void> cacheUser(UserModel userToCache);

  Future<void> clearCachedUser();

  Future<bool> hasCachedUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _sharedPreferences;

  AuthLocalDataSourceImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  @override
  Future<UserModel> getCachedUser() async {
    final jsonString = _sharedPreferences.getString(_CachedUser);
    if (jsonString == null) {
      throw const CacheException(message: 'No cached user found.');
    }
    try {
      return UserModel.fromJsonString(jsonString);
    } catch (_) {
      throw const CacheException(message: 'Failed to parse cached user.');
    }
  }

  @override
  Future<void> cacheUser(UserModel userToCache) async {
    try {
      await _sharedPreferences.setString(
        _CachedUser,
        userToCache.toJsonString(),
      );
    } catch (_) {
      throw const CacheException(message: 'Failed to cache user.');
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await _sharedPreferences.remove(_CachedUser);
    } catch (_) {
      throw const CacheException(message: 'Failed to clear cached user.');
    }
  }

  @override
  Future<bool> hasCachedUser() async {
    return _sharedPreferences.containsKey(_CachedUser);
  }
}