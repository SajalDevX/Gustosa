import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/usecases/GetCurrentUserUseCase.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/usecases/SignInWithEmailUseCase.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/usecases/SignOutUseCase.dart';
import '../../domain/usecases/SignUpWithEmailUseCase.dart';
import 'AuthEvent.dart';
import 'AuthState.dart';

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
