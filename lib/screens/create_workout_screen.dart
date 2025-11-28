import 'package:flutter/material.dart' hide Interval;
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import '../providers/workout_provider.dart';

class CreateWorkoutScreen extends StatefulWidget {
  final Workout? workout;
  final int? index;

  const CreateWorkoutScreen({super.key, this.workout, this.index});

  @override
  State<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final List<Interval> _warmup = [];
  final List<Interval> _intervals = [];
  final List<Interval> _cooldown = [];
  int _rounds = 1;

  @override
  void initState() {
    super.initState();
    if (widget.workout != null) {
      _nameController.text = widget.workout!.name;
      _warmup.addAll(widget.workout!.warmup);
      _intervals.addAll(widget.workout!.intervals);
      _cooldown.addAll(widget.workout!.cooldown);
      _rounds = widget.workout!.rounds;
    }
  }

  void _addInterval(IntervalType type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      builder: (context) => _AddIntervalSheet(
        type: type,
        onSave: (interval) {
          setState(() {
            if (interval.type == IntervalType.warmup) {
              _warmup.add(interval);
            } else if (interval.type == IntervalType.cooldown) {
              _cooldown.add(interval);
            } else {
              _intervals.add(interval);
            }
          });
        },
      ),
    );
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate() && _intervals.isNotEmpty) {
      final workout = Workout(
        name: _nameController.text,
        warmup: _warmup,
        intervals: _intervals,
        cooldown: _cooldown,
        rounds: _rounds,
        id: widget.workout?.id,
      );
      
      if (widget.workout != null && widget.index != null) {
        context.read<WorkoutProvider>().updateWorkout(widget.index!, workout);
      } else {
        context.read<WorkoutProvider>().addWorkout(workout);
      }
      Navigator.pop(context);
    } else if (_intervals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one work/rest interval')),
      );
    }
  }

  Color _getIntervalColor(BuildContext context, IntervalType type) {
    switch (type) {
      case IntervalType.work:
        return Theme.of(context).colorScheme.primary;
      case IntervalType.rest:
        return Theme.of(context).colorScheme.secondary;
      case IntervalType.warmup:
        return Colors.orange;
      case IntervalType.cooldown:
        return Colors.green;
    }
  }

  List<Widget> _buildIntervalList(List<Interval> list, {bool isWarmup = false, bool isCooldown = false}) {
    return list.asMap().entries.map((entry) {
      final i = entry.key;
      final interval = entry.value;
      return Padding(
        key: ValueKey(interval.id),
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ListTile(
          tileColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(
            interval.name,
            style: TextStyle(
              color: _getIntervalColor(context, interval.type),
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            interval.isReps ? '${interval.reps} reps' : '${interval.durationSeconds} seconds',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                list.removeAt(i);
              });
            },
          ),
        ),
      );
    }).toList();
  }

  ListTile _buildIntervalTile(Interval interval, int index, List<Interval> list) {
    return ListTile(
      key: ValueKey(interval.id),
      tileColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text(
        interval.name,
        style: TextStyle(
          color: _getIntervalColor(context, interval.type),
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        interval.isReps ? '${interval.reps} reps' : '${interval.durationSeconds} seconds',
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () {
          setState(() {
            list.removeAt(index);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout != null ? 'Edit Workout' : 'Create Workout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveWorkout,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Workout Name',
                  border: OutlineInputBorder(),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rounds', style: Theme.of(context).textTheme.displayMedium),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (_rounds > 1) setState(() => _rounds--);
                        },
                      ),
                      Text('$_rounds', style: Theme.of(context).textTheme.displayMedium),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => setState(() => _rounds++),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Warmup Section
                    if (_warmup.isNotEmpty) ...[
                      Text(
                        'Warmup',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: Colors.orange,
                            ),
                      ),
                      const SizedBox(height: 8),
                      ..._buildIntervalList(_warmup, isWarmup: true),
                      const SizedBox(height: 16),
                    ],
                    // Main Intervals Section
                    if (_intervals.isNotEmpty) ...[
                      Row(
                        children: [
                          Text(
                            'Work/Rest',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '($_rounds rounds)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ReorderableListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) newIndex -= 1;
                            final item = _intervals.removeAt(oldIndex);
                            _intervals.insert(newIndex, item);
                          });
                        },
                        children: [
                          for (int i = 0; i < _intervals.length; i++)
                            _buildIntervalTile(_intervals[i], i, _intervals),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Cooldown Section
                    if (_cooldown.isNotEmpty) ...[
                      Text(
                        'Cooldown',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: Colors.green,
                            ),
                      ),
                      const SizedBox(height: 8),
                      ..._buildIntervalList(_cooldown, isCooldown: true),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _addInterval(IntervalType.warmup),
                          icon: const Icon(Icons.self_improvement),
                          label: const Text('Warmup'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _addInterval(IntervalType.work),
                          icon: const Icon(Icons.fitness_center),
                          label: const Text('Work'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _addInterval(IntervalType.rest),
                          icon: const Icon(Icons.timer),
                          label: const Text('Rest'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _addInterval(IntervalType.cooldown),
                          icon: const Icon(Icons.air),
                          label: const Text('Cooldown'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddIntervalSheet extends StatefulWidget {
  final IntervalType type;
  final Function(Interval) onSave;

  const _AddIntervalSheet({required this.type, required this.onSave});

  @override
  State<_AddIntervalSheet> createState() => _AddIntervalSheetState();
}

class _AddIntervalSheetState extends State<_AddIntervalSheet> {
  int _duration = 30;
  int _reps = 10;
  bool _isReps = false;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.type.name.toUpperCase(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add ${widget.type.name.toUpperCase()} Interval',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Interval Name',
              border: OutlineInputBorder(),
            ),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('Time'),
                selected: !_isReps,
                onSelected: (selected) {
                  setState(() {
                    _isReps = !selected;
                  });
                },
              ),
              const SizedBox(width: 16),
              ChoiceChip(
                label: const Text('Reps'),
                selected: _isReps,
                onSelected: (selected) {
                  setState(() {
                    _isReps = selected;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_isReps)
            Column(
              children: [
                Text(
                  '$_reps reps',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: widget.type == IntervalType.work
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                      ),
                ),
                Slider(
                  value: _reps.toDouble(),
                  min: 1,
                  max: 100,
                  divisions: 99,
                  activeColor: widget.type == IntervalType.work
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  onChanged: (value) {
                    setState(() {
                      _reps = value.toInt();
                    });
                  },
                ),
              ],
            )
          else
            Column(
              children: [
                Text(
                  '$_duration seconds',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: widget.type == IntervalType.work
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                      ),
                ),
                Slider(
                  value: _duration.toDouble(),
                  min: 5,
                  max: 300, // 5 minutes max
                  divisions: 59,
                  activeColor: widget.type == IntervalType.work
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  onChanged: (value) {
                    setState(() {
                      _duration = value.toInt();
                    });
                  },
                ),
              ],
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onSave(Interval(
                  type: widget.type,
                  durationSeconds: _duration,
                  name: _nameController.text.trim().isEmpty
                      ? widget.type.name.toUpperCase()
                      : _nameController.text,
                  isReps: _isReps,
                  reps: _reps,
                ));
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ),
        ],
      ),
    );
  }
}
