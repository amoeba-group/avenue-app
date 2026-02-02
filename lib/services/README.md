# Services Documentation

Thư mục này chứa các services để xử lý các tác vụ phổ biến trong ứng dụng.

## 📚 Danh sách Services

### 1. ClientService
**File**: [`client_service.dart`](client_service.dart)

HTTP Client service sử dụng Dio để gọi API.

**Chức năng**:
- Centralized HTTP client configuration
- Request/Response interceptors
- Automatic error handling và convert sang AppException
- Authentication token management
- Request logging (debug mode)

**Usage**:
```dart
// Khởi tạo
final clientService = ClientService();

// Thêm token
clientService.setAuthToken('your_jwt_token');

// Gọi API
try {
  final response = await clientService.dio.get('/users');
  print(response.data);
} on AppException catch (e) {
  // Xử lý lỗi
  print('Error: ${e.message}');
}

// Xóa token (logout)
clientService.clearAuthToken();
```

**Error Handling**:
Tất cả lỗi được convert sang `AppException`:
- `NetworkException` - Không có kết nối mạng
- `TimeoutException` - Request timeout
- `ServerException` - Lỗi server (5xx)
- `FailureException` - Lỗi API (4xx)
- `UnknownException` - Lỗi không xác định

---

### 2. LocalStorageService
**File**: [`local_storage_service.dart`](local_storage_service.dart)

Service để lưu trữ dữ liệu local sử dụng SharedPreferences và FlutterSecureStorage.

**Chức năng**:
- Lưu/đọc dữ liệu với SharedPreferences (non-sensitive)
- Lưu/đọc dữ liệu với FlutterSecureStorage (sensitive: tokens, passwords)
- Type-safe methods cho String, Int, Bool, Double, List<String>
- Convenience methods cho user session management

**Initialization** (trong `main.dart`):
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // QUAN TRỌNG: Phải gọi trước khi sử dụng
  await LocalStorageService.init();

  runApp(MyApp());
}
```

**Usage - Basic Operations**:
```dart
// Lưu/đọc string
await LocalStorageService.save('key', 'value');
final value = await LocalStorageService.read('key');

// Lưu/đọc int
await LocalStorageService.saveInt('age', 25);
final age = await LocalStorageService.readInt('age');

// Lưu/đọc bool
await LocalStorageService.saveBool('isActive', true);
final isActive = await LocalStorageService.readBool('isActive');

// Xóa key
await LocalStorageService.remove('key');

// Xóa tất cả
await LocalStorageService.clear();
```

**Usage - Secure Storage** (cho tokens, passwords):
```dart
// Lưu token (được mã hóa trong Keychain/KeyStore)
await LocalStorageService.saveSecure('token', 'jwt_token_here');

// Đọc token
final token = await LocalStorageService.readSecure('token');

// Xóa token
await LocalStorageService.removeSecure('token');
```

**Usage - User Session Management**:
```dart
// Lưu session sau khi login
await LocalStorageService.saveUserSession(
  accessToken: 'jwt_token',
  refreshToken: 'refresh_token',
  userId: 'user123',
  email: 'user@example.com',
);

// Check đã login chưa
final isLoggedIn = await LocalStorageService.isLoggedIn();

// Xóa session (logout)
await LocalStorageService.clearUserSession();
```

**Storage Keys** (có sẵn trong service):
```dart
LocalStorageService.keyAccessToken   // 'accessToken'
LocalStorageService.keyRefreshToken  // 'refreshToken'
LocalStorageService.keyUserId        // 'userId'
LocalStorageService.keyUserEmail     // 'userEmail'
LocalStorageService.keyIsLoggedIn    // 'isLoggedIn'
LocalStorageService.keyLocale        // 'locale'
LocalStorageService.keyFcmToken      // 'fcmToken'
// ... và nhiều keys khác
```

---

### 3. SignInSocialService
**File**: [`sign_in_social_service.dart`](sign_in_social_service.dart)

Service để đăng nhập qua các nền tảng social (Apple, Google, Facebook).

**Chức năng**:
- Sign in with Apple (iOS 13+)
- Sign in with Google
- Sign in with Facebook
- Unified result model: `SocialSignInResult`

**Usage - Apple Sign In**:
```dart
final socialService = SignInSocialService();

final result = await socialService.signInWithApple();
if (result != null) {
  print('User ID: ${result.userId}');
  print('Email: ${result.email}');
  print('Name: ${result.fullName}');

  // ⚠️ LƯU Ý: Apple CHỈ trả về email/name LẦN ĐẦU
  // Các lần sau chỉ có userId
  // Bạn cần lưu vào database ngay lần đầu!
}
```

**Usage - Google Sign In**:
```dart
// Google Sign In (v7.x API)
final result = await socialService.signInWithGoogle(
  serverClientId: 'your-server-client-id', // Optional
);

if (result != null) {
  print('User ID: ${result.userId}');
  print('Email: ${result.email}');
  print('Name: ${result.fullName}');
  print('Photo: ${result.photoUrl}');
  print('ID Token: ${result.idToken}'); // Dùng cho backend auth
}

// Logout
await socialService.signOutGoogle();
```

**Usage - Facebook Sign In**:
```dart
final result = await socialService.signInWithFacebook();

if (result != null) {
  print('User ID: ${result.userId}');
  print('Email: ${result.email}'); // Có thể null nếu user dùng SĐT
  print('Name: ${result.fullName}');

  // ⚠️ LƯU Ý: Nếu user dùng SĐT để login Facebook
  // thì email sẽ NULL → cần yêu cầu user nhập email
  if (result.email == null) {
    // Show dialog để nhập email
  }
}

// Logout
await socialService.signOutFacebook();
```

**SocialSignInResult Model**:
```dart
class SocialSignInResult {
  final String userId;        // Luôn có
  final String? email;        // Có thể null
  final String? fullName;     // Có thể null
  final String? photoUrl;     // Có thể null
  final String? idToken;      // Dùng cho backend verification
  final String? accessToken;  // Access token (nếu có)
}
```

---

### 4. ConnectivityService
**File**: [`connectivity_service.dart`](connectivity_service.dart)

Service để monitor kết nối mạng real-time.

**Usage**:
```dart
final connectivityService = ConnectivityService();
connectivityService.initialize();

// Check kết nối hiện tại
final isConnected = await connectivityService.checkConnectivity();

// Listen changes
connectivityService.connectivityStream.listen((isConnected) {
  if (isConnected) {
    print('Đã có mạng');
  } else {
    print('Mất kết nối');
  }
});
```

---

### 5. NotificationService
**File**: [`notification_service.dart`](notification_service.dart)

Service để xử lý Firebase Cloud Messaging và local notifications.

**Usage**: Đã được tự động initialize trong `main.dart`.

---

## 🔧 Integration với Repository Pattern

Các services này được sử dụng trong Repository layer:

```dart
// Example: AuthenticationRepository
class AuthenticationRepository {
  final ClientService _clientService;

  AuthenticationRepository(this._clientService);

  Future<void> login(String email, String password) async {
    try {
      final response = await _clientService.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      final token = response.data['token'];

      // Lưu token
      await LocalStorageService.saveAccessToken(token);

      // Set token cho các requests tiếp theo
      _clientService.setAuthToken(token);

    } on AppException catch (e) {
      // Xử lý lỗi
      rethrow;
    }
  }

  Future<void> logout() async {
    await _clientService.dio.post('/logout');
    await LocalStorageService.clearUserSession();
    _clientService.clearAuthToken();
  }
}
```

---

## 🧪 Testing

Unit tests cho services được đặt trong `test/services/`:

```bash
# Run tất cả tests
flutter test test/services/

# Run test cho service cụ thể
flutter test test/services/local_storage_service_test.dart
flutter test test/services/client_service_test.dart
```

**Lưu ý**:
- Secure storage tests cần integration testing (không chạy được trong unit tests)
- ClientService tests cần mock Dio responses

---

## 📝 Best Practices

### 1. Error Handling
Luôn catch `AppException` khi sử dụng ClientService:
```dart
try {
  final response = await clientService.dio.get('/api/users');
} on NetworkException catch (e) {
  // Không có mạng
  showDialog('Vui lòng kiểm tra kết nối');
} on TimeoutException catch (e) {
  // Timeout
  showDialog('Kết nối quá chậm');
} on ServerException catch (e) {
  // Lỗi server
  showDialog('Server đang bảo trì');
} on AppException catch (e) {
  // Lỗi khác
  showDialog(e.message);
}
```

### 2. Token Management
```dart
// Sau khi login thành công
await LocalStorageService.saveAccessToken(token);
clientService.setAuthToken(token);

// Khi logout
await LocalStorageService.clearUserSession();
clientService.clearAuthToken();
```

### 3. Social Login Flow
```dart
Future<void> handleSocialLogin() async {
  final socialService = SignInSocialService();

  // 1. Sign in với social platform
  final result = await socialService.signInWithGoogle();

  if (result == null) {
    // User hủy sign in
    return;
  }

  // 2. Gửi token lên server để verify và tạo session
  final response = await clientService.dio.post(
    '/auth/google',
    data: {
      'id_token': result.idToken,
      'user_id': result.userId,
    },
  );

  // 3. Lưu token từ server
  final serverToken = response.data['token'];
  await LocalStorageService.saveAccessToken(serverToken);
  clientService.setAuthToken(serverToken);

  // 4. Navigate đến main screen
  Navigator.pushReplacement(...);
}
```

---

## 🔐 Security Notes

1. **Tokens**: Luôn dùng `saveSecure()` cho tokens và passwords
2. **API Keys**: Không hardcode API keys trong code, dùng environment variables
3. **HTTPS Only**: ClientService chỉ nên connect đến HTTPS endpoints
4. **Token Refresh**: Implement token refresh logic trong ClientService interceptor

---

## 📱 Platform-Specific Notes

### iOS
- Sign in with Apple yêu cầu iOS 13+
- Secure Storage sử dụng Keychain

### Android
- Secure Storage sử dụng KeyStore
- Google Sign In cần configure SHA-1 certificate

---

## 🆘 Troubleshooting

### LocalStorageService: "hasn't been initialized"
```dart
// Đảm bảo đã gọi init() trong main.dart
await LocalStorageService.init();
```

### GoogleSignIn: Authentication failed
```dart
// Đảm bảo đã configure serverClientId
await socialService.signInWithGoogle(
  serverClientId: 'your-client-id.apps.googleusercontent.com',
);
```

### ClientService: LateInitializationError
```dart
// Đảm bảo EnvConfig đã được initialize
await EnvConfig().init();
```

---

**Last Updated**: 2026-02-02
**Maintainer**: Development Team
