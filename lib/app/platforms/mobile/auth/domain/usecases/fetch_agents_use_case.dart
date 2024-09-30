
import 'package:either_dart/either.dart';
import 'package:gustosa/app/platforms/mobile/auth/data/repository_impl/auth_repository_impl.dart';

import '../../../../../shared/config/constants/enums.dart';
import '../../../../../shared/core/error_handler/error_state.dart';
import '../entities/agent_model.dart';

class FetchAgentsUseCase {
  final AuthRepositoryImpl authPageRepository;

  FetchAgentsUseCase(this.authPageRepository);

  Future<Either<ErrorState, List<AgentModel>>> call({String? uid, String? email, AgentApprovalStatus? approvalStatus}) async {
    return await authPageRepository.fetchAgents(uid, email, approvalStatus);
  }
}
