import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/state/auth_controller.dart';
import '../../data/models/event_models.dart';
import '../../data/repos/event_repo.dart';

final eventRepoProvider = Provider((ref) => EventRepo(ref.watch(apiClientProvider)));

final eventsControllerProvider =
    NotifierProvider<EventsController, AsyncValue<List<EventSummary>>>(EventsController.new);

class EventsController extends Notifier<AsyncValue<List<EventSummary>>> {
  @override
  AsyncValue<List<EventSummary>> build() => const AsyncValue.loading();

  Future<void> load({String? city, String? q, String? orgId}) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(eventRepoProvider);

      // public list (published only)
      final list = await repo.publicEvents(city: city, q: q, orgId: orgId);

      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
