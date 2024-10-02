import 'package:gustosa/app/platforms/mobile/auth/data/data_sources/supabase_auth_data_source.dart';
import 'package:gustosa/app/shared/config/constants/enums.dart';
import '../../../../../shared/core/backend_controller/db_controller/db_tables.dart';
import '../../domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthDataSourceImpl implements SupabaseAuthDataSource {
  final supabase = Supabase.instance.client;
  @override
  Future<List<Map<String, dynamic>>> fetchUsers(
      String? uid, String? email, String? phoneNumber) async {
    final field = uid != null
        ? 'uid'
        : email != null
        ? 'email'
        : 'phoneNumber';

    final value = uid ?? email ?? phoneNumber;

    final data =
    await supabase.from(DbTables.usersTable).select().eq(field, value!);
    return data;
  }
  @override
  Future<Map<String, dynamic>?> fetchUser(String? uid, String? email,
      String? phoneNumber, AgentApprovalStatus? approvalStatus) async {
    const agentApprovalStatusEnumMap = {
      AgentApprovalStatus.approved: 'approved',
      AgentApprovalStatus.pending: 'pending',
      AgentApprovalStatus.denied: 'denied',
    };

    final field = uid != null
        ? 'gust_id'
        : email != null
            ? 'email'
            : phoneNumber != null
                ? 'phone_number'
                : 'agent_approval_status';

    final value = uid ??
        email ??
        phoneNumber ??
        agentApprovalStatusEnumMap[approvalStatus];
    final data = await supabase
        .from(DbTables.usersTable)
        .select()
        .eq(field, value!)
        .limit(1);
    return data.isEmpty ? null : data.first;
  }

  @override
  Future<void> insertUser(UserEntity userModel) async {
    await supabase.from(DbTables.usersTable).insert(userModel.toJson());
  }

  @override
  Future<void> updateUser(UserEntity userModel, String uid) async {
    await supabase
        .from(DbTables.usersTable)
        .update(userModel.toJson())
        .match({'gust_id': uid});
  }
}
