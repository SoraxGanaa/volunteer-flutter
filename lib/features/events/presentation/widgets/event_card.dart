import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/event_models.dart';

class EventCard extends StatelessWidget {
  final EventSummary ev;
  final VoidCallback? onTap;
  final VoidCallback? onPrimary;

  const EventCard({
    super.key,
    required this.ev,
    this.onTap,
    this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('yyyy-MM-dd');
    final timeFmt = DateFormat('HH:mm');

    final dateText = dateFmt.format(ev.startAt);
    final timeText = '${timeFmt.format(ev.startAt)} - ${timeFmt.format(ev.endAt)}';

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image placeholder (screenshot шиг)
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.white10,
                  child: const Center(
                    child: Icon(Icons.image, color: Colors.white24, size: 42),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // pill (category байхгүй тул orgName ашиглая)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white12),
                ),
                child: Text(
                  ev.orgName,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 12),
              Text(ev.title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: Colors.white70),
                  const SizedBox(width: 8),
                  Text(dateText, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(width: 14),
                  const Icon(Icons.access_time, size: 18, color: Colors.white70),
                  const SizedBox(width: 8),
                  Text(timeText, style: const TextStyle(color: Colors.white70)),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(Icons.location_on, size: 18, color: Colors.white70),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(ev.city, style: const TextStyle(color: Colors.white70)),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.people, size: 18, color: Colors.white70),
                  const SizedBox(width: 8),
                  Text('${ev.capacity}', style: const TextStyle(color: Colors.white70)),
                  const Spacer(),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: onPrimary,
                      child: const Text('Бүртгүүлэх'),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
