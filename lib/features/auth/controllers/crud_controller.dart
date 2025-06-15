import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/crud_model.dart';

class CoursesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _collection = FirebaseFirestore.instance.collection('courses');

  Future<List<Course>> fetchCourses() async {
    try {
      debugPrint('Fetching courses from Firestore...');
      final snapshot = await _collection.orderBy('title').get();
      debugPrint('Got ${snapshot.docs.length} courses from Firestore');
      final courses = snapshot.docs.map((doc) => Course.fromMap(doc.id, doc.data())).toList();
      debugPrint('Mapped courses: ${courses.map((c) => c.title).join(', ')}');
      return courses;
    } catch (e, st) {
      debugPrint('Error fetching courses: $e');
      debugPrint('Stack trace: $st');
      rethrow;
    }
  }

  Future<void> addCourse(Course course) async {
    try {
      debugPrint('Adding course: ${course.title}');
      final docRef = await _collection.add(course.toMap());
      debugPrint('Course added successfully with ID: ${docRef.id}');
    } catch (e) {
      debugPrint('Error adding course: $e');
      rethrow;
    }
  }

  Future<void> updateCourse(Course course) async {
    try {
      debugPrint('Updating course: ${course.title}');
      await _collection.doc(course.id).update(course.toMap());
      debugPrint('Course updated successfully');
    } catch (e) {
      debugPrint('Error updating course: $e');
      rethrow;
    }
  }

  Future<void> deleteCourse(String id) async {
    try {
      debugPrint('Deleting course with id: $id');
      await _collection.doc(id).delete();
      debugPrint('Course deleted successfully');
    } catch (e) {
      debugPrint('Error deleting course: $e');
      rethrow;
    }
  }
}