import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dartz/dartz.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Define GoogleSignIn with ClientID to ensure multi-platform support
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Get the Client ID from environment variables to prevent leaking credentials
    clientId: const String.fromEnvironment('GOOGLE_CLIENT_ID', defaultValue: ''),
  );

  // Email login
  Future<Either<String, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(credential.user!);
    } on FirebaseAuthException catch (e) {
      return Left(_handleAuthError(e.code));
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Reset password
  Future<Either<String, Unit>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(_handleAuthError(e.code));
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Create a new account
  Future<Either<String, User>> register({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(credential.user!);
    } on FirebaseAuthException catch (e) {
      return Left(_handleAuthError(e.code));
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Modified Google login
  Future<Either<String, User>> signInWithGoogle() async {
    try {
      // Use Client ID configured version
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return const Left('تم إلغاء العملية');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return Right(userCredential.user!);
    } catch (e) {
      return Left('خطأ في الاتصال بجوجل: $e');
    }
  }

  // Logout method (Critical for Router Auto-Redirect)
  Future<void> logout() async {
    await _googleSignIn.signOut(); // Sign out of Google
    await _auth.signOut(); // Sign out of Firebase
  }

  String _handleAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'المستخدم غير موجود.';
      case 'wrong-password':
        return 'كلمة المرور خاطئة.';
      case 'invalid-email':
        return 'بريد إلكتروني غير صالح.';
      case 'email-already-in-use':
        return 'البريد مستخدم بالفعل.';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً.';
      case 'user-disabled':
        return 'تم تعطيل هذا الحساب.';
      case 'too-many-requests':
        return 'محاولات كثيرة جداً. حاول لاحقاً.';
      case 'network-request-failed':
        return 'تأكد من اتصالك بالإنترنت.';
      case 'operation-not-allowed':
        return 'تسجيل الدخول بالبريد غير مفعل في الإعدادات.';
      default:
        return 'حدث خطأ: $code';
    }
  }
}
