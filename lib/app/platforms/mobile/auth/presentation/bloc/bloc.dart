import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gustosa/app/platforms/mobile/auth/presentation/bloc/state.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/signin_with_email_usecase.dart';
import '../../domain/usecases/signout_usecase.dart';
import '../../domain/usecases/signup_with_email_usecase.dart';
import 'event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmailUseCase signInWithEmailUseCase;
  final SignUpWithEmailUseCase signUpWithEmailUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SignOutUseCase signOutUseCase;

  AuthBloc(
      this.signInWithEmailUseCase,
      this.signUpWithEmailUseCase,
      this.getCurrentUserUseCase,
      this.signOutUseCase,
      ) : super(AuthInitial()) {
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await signInWithEmailUseCase(event.email, event.password);
      result.fold(
            (error) => emit(AuthError(error.toString())),
            (user) => emit(AuthAuthenticated(user!)),
      );
    });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await signUpWithEmailUseCase(event.email, event.password);
      result.fold(
            (error) => emit(AuthError(error.toString())),
            (user) => emit(AuthAuthenticated(user!)),
      );
    });

    on<SignOutRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await signOutUseCase();
      result.fold(
            (error) => emit(AuthError(error.toString())),
            (_) => emit(AuthUnauthenticated()),
      );
    });

    on<CheckAuthStatus>(
          (event, emit) async {
        final result = await getCurrentUserUseCase();
        result.fold(
              (error) => emit(AuthError(error.toString())),
              (user) {
            emit(AuthAuthenticated(user!));
          },
        );
      },
    );
  }
}
