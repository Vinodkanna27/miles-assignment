import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miles_assignment/features/auth/controllers/crud_controller.dart';
import 'package:miles_assignment/features/auth/models/crud_model.dart';

final coursesRepositoryProvider = Provider((ref) => CoursesRepository());

final coursesListProvider = StateNotifierProvider<CoursesNotifier, AsyncValue<List<Course>>>((ref) {
  final repo = ref.read(coursesRepositoryProvider);
  return CoursesNotifier(repo);
});

class CoursesNotifier extends StateNotifier<AsyncValue<List<Course>>> {
  final CoursesRepository _repo;

  CoursesNotifier(this._repo) : super(const AsyncValue.loading()) {
    debugPrint('CoursesNotifier initialized');
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    debugPrint('Fetching courses...');
    try {
      final courses = await _repo.fetchCourses();
      debugPrint('Courses fetched successfully: ${courses.length} courses');
      state = AsyncValue.data(courses);
    } catch (e, st) {
      debugPrint('Error in fetchCourses: $e');
      debugPrint('Stack trace: $st');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addCourse(Course course) async {
    debugPrint('Adding new course: ${course.title}');
    try {
      await _repo.addCourse(course);
      await fetchCourses();
    } catch (e) {
      debugPrint('Error adding course: $e');
      rethrow;
    }
  }

  Future<void> updateCourse(Course course) async {
    debugPrint('Updating course: ${course.title}');
    try {
      await _repo.updateCourse(course);
      await fetchCourses();
    } catch (e) {
      debugPrint('Error updating course: $e');
      rethrow;
    }
  }

  Future<void> deleteCourse(String id) async {
    debugPrint('Deleting course with id: $id');
    try {
      await _repo.deleteCourse(id);
      await fetchCourses();
    } catch (e) {
      debugPrint('Error deleting course: $e');
      rethrow;
    }
  }
}