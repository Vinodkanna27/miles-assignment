import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miles_assignment/features/auth/models/crud_model.dart';
import 'package:miles_assignment/features/auth/providers/crud_provider.dart';

class CoursesPage extends ConsumerWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesListProvider);
    final notifier = ref.read(coursesListProvider.notifier);
    final isTablet = MediaQuery.of(context).size.width > 600;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            tooltip: 'Logout',
          )
        ],
      ),
      body: coursesAsync.when(
        data: (courses) => courses.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: isTablet
                    ? GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.5,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: courses.length,
                        itemBuilder: (context, index) => _CourseCard(
                          courses[index],
                          notifier,
                          index: index,
                        ),
                      )
                    : ListView.builder(
                        itemCount: courses.length,
                        itemBuilder: (context, index) => _CourseCard(
                          courses[index],
                          notifier,
                          index: index,
                        ),
                      ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 64,
                      color: theme.colorScheme.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No courses yet!',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your first course',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error: $e',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => CourseDialog(onSave: notifier.addCourse),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add Course'),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;
  final CoursesNotifier notifier;
  final int index;

  const _CourseCard(this.course, this.notifier, {required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: isTablet ? 0 : 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (_) => CourseDialog(course: course, onSave: notifier.updateCourse),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      course.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => CourseDialog(
                            course: course,
                            onSave: notifier.updateCourse,
                          ),
                        ),
                        tooltip: 'Edit',
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: theme.colorScheme.error,
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Course'),
                            content: Text('Are you sure you want to delete "${course.title}"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  notifier.deleteCourse(course.id);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: theme.colorScheme.error),
                                ),
                              ),
                            ],
                          ),
                        ),
                        tooltip: 'Delete',
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                course.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 14,
                ),
                maxLines: isTablet ? 2 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseDialog extends StatefulWidget {
  final Course? course;
  final Function(Course) onSave;

  const CourseDialog({super.key, this.course, required this.onSave});

  @override
  State<CourseDialog> createState() => _CourseDialogState();
}

class _CourseDialogState extends State<CourseDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.course?.title);
    _descController = TextEditingController(text: widget.course?.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final course = Course(
        id: widget.course?.id ?? 'temp_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
      );
      widget.onSave(course);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.course != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Course' : 'Add Course'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (value) => value!.isEmpty ? 'Enter title' : null,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
              validator: (value) => value!.isEmpty ? 'Enter description' : null,
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}