import '../model/course.dart';
import '../model/course_result.dart';
import '../model/student.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<CourseResult> scores = [];

  void addStudent({
    required String studentId,
    required String studentName,
  }) {
    if (_findStudent(studentId) != null) {
      throw Exception('Student $studentId already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }

  void removeStudent({required String studentId}) {
    if (_findStudent(studentId) == null) {
      throw Exception('Student $studentId not found');
    }

    students.removeWhere((student) => student.id == studentId);
    for (final course in courses) {
      course.studentIds.remove(studentId);
    }
    scores.removeWhere((result) => result.studentId == studentId);
  }

  void addCourse({
    required String courseId,
    required String courseName,
  }) {
    if (_findCourse(courseId) != null) {
      throw Exception('Course $courseId already exists');
    }

    courses.add(Course(id: courseId, name: courseName));
  }

  void removeCourse({required String courseId}) {
    final course = _findCourse(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }

    courses.remove(course);
    scores.removeWhere((result) => result.courseId == courseId);
  }

  void enrollStudent({
    required String studentId,
    required String courseId,
  }) {
    if (_findStudent(studentId) == null) {
      throw Exception('Student $studentId not found');
    }

    final course = _findCourse(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }
    if (course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId is already enrolled');
    }

    course.studentIds.add(studentId);
  }

  void discardStudentFromCourse({
    required String studentId,
    required String courseId,
  }) {
    final course = _findCourse(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }
    if (!course.studentIds.remove(studentId)) {
      throw Exception('Student $studentId is not enrolled in course $courseId');
    }

    scores.removeWhere(
      (result) => result.studentId == studentId && result.courseId == courseId,
    );
  }

  CourseResult addResult({
    required String studentId,
    required String courseId,
    required int score,
  }) {
    final course = _findCourse(courseId);
    if (_findStudent(studentId) == null) {
      throw Exception('Student $studentId not found');
    }
    if (course == null) {
      throw Exception('Course $courseId not found');
    }
    if (!course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId is not enrolled in course $courseId');
    }
    if (score < 0 || score > 100) {
      throw Exception('Score must be between 0 and 100');
    }
    if (scores.any(
      (result) => result.studentId == studentId && result.courseId == courseId,
    )) {
      throw Exception('A result already exists for this student and course');
    }

    final result = CourseResult(
      id: _nextResultId(),
      studentId: studentId,
      courseId: courseId,
      score: score,
    );
    scores.add(result);
    return result;
  }

  void removeResult({required String resultId}) {
    if (!scores.any((result) => result.id == resultId)) {
      throw Exception('Result $resultId not found');
    }

    scores.removeWhere((result) => result.id == resultId);
  }

  Student? _findStudent(String studentId) {
    for (final student in students) {
      if (student.id == studentId) {
        return student;
      }
    }
    return null;
  }

  Course? _findCourse(String courseId) {
    for (final course in courses) {
      if (course.id == courseId) {
        return course;
      }
    }
    return null;
  }

  String _nextResultId() {
    var id = scores.length + 1;
    while (scores.any((result) => result.id == '$id')) {
      id++;
    }
    return '$id';
  }
}
