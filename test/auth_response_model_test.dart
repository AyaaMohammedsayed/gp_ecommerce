import 'package:flutter_test/flutter_test.dart';
import 'package:gp_ecommerce/features/Auth/data/data.dart';

void main() {
  group('AuthResponseModel', () {
    test('should parse login response correctly', () {
      final json = {
        "success": true,
        "msg": "Login Successful",
        "user": {
          "id": 9,
          "name": "Test User",
          "email": "testuser123@example.com",
          "email_verified_at": null,
          "created_at": "2026-06-18T13:24:29.000000Z",
          "updated_at": "2026-06-18T13:24:29.000000Z"
        },
        "token": "19|testToken123"
      };

      final result = AuthResponseModel.fromJson(json);

      expect(result.success, true);
      expect(result.msg, "Login Successful");
      expect(result.token, "19|testToken123");
      expect(result.user.id, 9);
      expect(result.user.name, "Test User");
      expect(result.user.email, "testuser123@example.com");
    });

    test('should parse register response correctly', () {
      final json = {
        "success": true,
        "msg": "Registration Successful",
        "user": {
          "id": 10,
          "name": "Mariel",
          "email": "mariel@test.com",
          "created_at": "2026-06-18T13:24:29.000000Z",
          "updated_at": "2026-06-18T13:24:29.000000Z"
        },
        "token": "20|registerToken123"
      };

      final result = AuthResponseModel.fromJson(json);

      expect(result.success, true);
      expect(result.msg, "Registration Successful");
      expect(result.token, "20|registerToken123");
      expect(result.user.id, 10);
      expect(result.user.name, "Mariel");
      expect(result.user.email, "mariel@test.com");
    });
  });
}