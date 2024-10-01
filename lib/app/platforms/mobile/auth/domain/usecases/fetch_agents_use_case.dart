

import 'package:either_dart/either.dart';
import 'package:gustosa/app/platforms/mobile/auth/data/repository_impl/auth_repository_impl.dart';
import 'package:gustosa/app/platforms/mobile/auth/domain/entities/agent_model.dart';
import 'package:gustosa/app/shared/config/constants/enums.dart';
import 'package:gustosa/app/shared/core/error_handler/error_state.dart';

class FetchAgentsUseCase {
  final AuthRepositoryImpl authPageRepository;

  FetchAgentsUseCase(this.authPageRepository);

  Future<Either<ErrorState, List<AgentModel>>> call({String? uid, String? email, AgentApprovalStatus? approvalStatus}) async {
    return await authPageRepository.fetchAgents(uid, email, approvalStatus);
  }
}
