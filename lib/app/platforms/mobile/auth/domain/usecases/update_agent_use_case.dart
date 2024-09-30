
import 'package:either_dart/either.dart';
import 'package:gustosa/app/platforms/mobile/auth/data/repository_impl/auth_repository_impl.dart';

import '../../../../../shared/core/error_handler/error_state.dart';
import '../entities/agent_model.dart';

class UpdateAgentUseCase {
  final AuthRepositoryImpl authPageRepository;

  UpdateAgentUseCase(this.authPageRepository);

  Future<Either<ErrorState, void>> call({required AgentModel agent}) async {
    return await authPageRepository.updateAgent(agent);
  }
}
