import 'package:get_it/get_it.dart';
import 'package:lumb/data/repository/auth_repository_impl.dart';
import 'package:lumb/data/repository/device_repository_impl.dart';
import 'package:lumb/data/repository/session_repository_impl.dart';
import 'package:lumb/data/repository/user_repository_impl.dart';
import 'package:lumb/data/service/firebase_auth_service.dart';
import 'package:lumb/data/service/firebase_device_service.dart';
import 'package:lumb/data/service/firebase_session_service.dart';
import 'package:lumb/data/service/firebase_storage_service.dart';
import 'package:lumb/data/service/firebase_user_service.dart';
import 'package:lumb/domain/repository/auth_repository.dart';
import 'package:lumb/domain/repository/device_repository.dart';
import 'package:lumb/domain/repository/session_repository.dart';
import 'package:lumb/domain/repository/user_repository.dart';
import 'package:lumb/domain/usecases/auth/edit_user_usecases.dart';
import 'package:lumb/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:lumb/domain/usecases/auth/send_recovery_email_usecase.dart';
import 'package:lumb/domain/usecases/auth/signin_email_password.dart';
import 'package:lumb/domain/usecases/auth/signin_facebook_usecase.dart';
import 'package:lumb/domain/usecases/auth/signing_google_usecase.dart';
import 'package:lumb/domain/usecases/auth/signout.dart';
import 'package:lumb/domain/usecases/auth/signup_email_password.dart';
import 'package:lumb/domain/usecases/device/device_usecases.dart';
import 'package:lumb/domain/usecases/session/session_usecases.dart';
import 'package:lumb/domain/usecases/user/user_usecases.dart';
import 'package:lumb/presentation/blocs/auth/auth_bloc.dart';
import 'package:lumb/presentation/blocs/cubits/bluetooth_cubit.dart';
import 'package:lumb/presentation/blocs/cubits/session_cubit.dart';
import 'package:lumb/presentation/blocs/device/device_bloc.dart';
import 'package:lumb/presentation/blocs/session/session_bloc.dart';
import 'package:lumb/presentation/blocs/user/user_bloc.dart';

final sl = GetIt.instance;

Future<void> injectDependencies() async {
  // Dependencies

  // Auth:
  sl.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  sl.registerSingleton<FirebaseStorageService>(FirebaseStorageService());
  sl.registerSingleton<FirebaseDeviceService>(FirebaseDeviceService());
  sl.registerSingleton<FirebaseSessionService>(FirebaseSessionService());
  sl.registerSingleton<FirebaseUserService>(FirebaseUserService());

  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl(), sl()));
  sl.registerSingleton<DeviceRepository>(DeviceRepositoryImpl(sl()));
  sl.registerSingleton<SessionRepository>(SessionRepositoryImpl(sl()));
  sl.registerSingleton<UserRepository>(UserRepositoryImpl(sl()));

  // use cases
  sl.registerSingleton<SignInWithEmailAndPasswordUseCase>(
      SignInWithEmailAndPasswordUseCase(sl()));
  sl.registerSingleton<SignUpWithEmailAndPasswordUseCase>(
      SignUpWithEmailAndPasswordUseCase(sl()));
  sl.registerSingleton<SignOutUseCase>(SignOutUseCase(sl()));
  sl.registerSingleton<GetCurrentUserUseCase>(GetCurrentUserUseCase(sl()));
  sl.registerSingleton<SendRecoveryEmailUseCase>(
      SendRecoveryEmailUseCase(sl()));
  sl.registerSingleton<SignInWithGoogleUseCase>(SignInWithGoogleUseCase(sl()));
  sl.registerSingleton<SignInWithFacebookUseCase>(
      SignInWithFacebookUseCase(sl()));
  sl.registerSingleton<ChangeDisplayNameUseCase>(
      ChangeDisplayNameUseCase(sl()));
  sl.registerSingleton<ChangeEmailUseCase>(ChangeEmailUseCase(sl()));
  sl.registerSingleton<ChangePasswordUseCase>(ChangePasswordUseCase(sl()));
  sl.registerSingleton<SendVerifyEmailUseCase>(SendVerifyEmailUseCase(sl()));
  sl.registerSingleton<ChangeProfilePhotoUseCase>(
      ChangeProfilePhotoUseCase(sl()));

  sl.registerSingleton<AddDeviceUseCase>(AddDeviceUseCase(sl()));
  sl.registerSingleton<GetDevicesUseCase>(GetDevicesUseCase(sl()));
  sl.registerSingleton<UpdateDeviceUseCase>(UpdateDeviceUseCase(sl()));
  sl.registerSingleton<DeleteDeviceUseCase>(DeleteDeviceUseCase(sl()));

  sl.registerSingleton<AddSessionUseCase>(AddSessionUseCase(sl()));
  sl.registerSingleton<GetSessionsUseCase>(GetSessionsUseCase(sl()));
  sl.registerSingleton<UpdateSessionUseCase>(UpdateSessionUseCase(sl()));
  sl.registerSingleton<DeleteSessionUseCase>(DeleteSessionUseCase(sl()));

  sl.registerSingleton<GetDocumentReferenceUserByIdUseCase>(
      GetDocumentReferenceUserByIdUseCase(sl()));
  sl.registerSingleton<SaveUserUseCase>(SaveUserUseCase(sl()));

  //bloc
  sl.registerFactory<AuthBloc>(
      () => AuthBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<DeviceBloc>(() => DeviceBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory<SessionBloc>(() => SessionBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory<UserBloc>(() => UserBloc(sl(), sl()));


  sl.registerFactory<SessionCubit>(() => SessionCubit());

  sl.registerFactory<BluetoothCubit>(() => BluetoothCubit());
}
