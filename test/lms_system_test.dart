import 'package:test/test.dart';

import '../lib/service/lms_system.dart';

void main() {
  test('creates a student', () {
    final lms = LmsSystem();

    // Create a student
    lms.addStudent(studentId: 'S1', studentName: "ronan");

    expect(lms.students.first.name, 'ronan');

    // Remove the student
    lms.removeStudent(studentId: 'S1');
    expect(lms.students.length, 0);
  });
  test('Task 1: Add and remove a course successfully', () {
    final lms = LmsSystem();

    lms.addCourse(courseId: 'C101', courseName: 'Mobile Development');
    expect(lms.courses.length, 1);
    expect(lms.courses.first.name, 'Mobile Development');

    lms.removeCourse(courseId: 'C101');
    expect(lms.courses.isEmpty, isTrue);
  });

  test('Task 1: Reject duplicate course ID', () {
    final lms = LmsSystem();

    lms.addCourse(courseId: 'C101', courseName: 'Mobile Development');
    expect(() {
      lms.addCourse(courseId: 'C101', courseName: 'Web Development');
    }, throwsException);
  });

  test('Task 1: Reject removal of a nonexistent course', () {
    final lms = LmsSystem();

    expect(() {
      lms.removeCourse(courseId: 'C999');
    }, throwsException);
  });

  test('Task 2: Enroll an existing student in an existing course', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S01', studentName: 'Alice');
    lms.addCourse(courseId: 'C101', courseName: 'Flutter Development');

    lms.enrollStudent(studentId: 'S01', courseId: 'C101');
    expect(lms.courses.first.studentIds.contains('S01'), isTrue);
  });

  test('Task 2: Reject enrollment if student does not exist', () {
    final lms = LmsSystem();

    lms.addCourse(courseId: 'C101', courseName: 'Flutter Development');
    expect(() {
      lms.enrollStudent(studentId: 'S99', courseId: 'C101');
    }, throwsException);
  });

  test('Task 2: Reject enrollment if course does not exist', () { // or final lms = LmsSystem();
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S01', studentName: 'Alice');
    expect(() {
      lms.enrollStudent(studentId: 'S01', courseId: 'C999');
    }, throwsException);
  });

  test('Task 2: Reject duplicate enrollment', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S01', studentName: 'Alice');
    lms.addCourse(courseId: 'C101', courseName: 'Flutter Development');
    lms.enrollStudent(studentId: 'S01', courseId: 'C101');

    expect(() {
      lms.enrollStudent(studentId: 'S01', courseId: 'C101');
    }, throwsException);
  });

  test('Task 3: Discard student from course', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S01', studentName: 'Alice');
    lms.addCourse(courseId: 'C101', courseName: 'Flutter');
    lms.enrollStudent(studentId: 'S01', courseId: 'C101');

    lms.discardStudentFromCourse(studentId: 'S01', courseId: 'C101');
    expect(lms.courses.first.studentIds.isEmpty, isTrue);
    expect(lms.students.length, 1);
  });

  test('Task 3: Reject discard if enrollment does not exist', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S01', studentName: 'Alice');
    lms.addCourse(courseId: 'C101', courseName: 'Flutter');

    expect(() {
      lms.discardStudentFromCourse(studentId: 'S01', courseId: 'C101');
    }, throwsException);
  });

  test('Task 3: Scenario - Removing a student cleans enrollments and scores', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S01', studentName: 'Alice');
    lms.addStudent(studentId: 'S02', studentName: 'Bob');
    lms.addCourse(courseId: 'C101', courseName: 'Mobile Dev');

    lms.enrollStudent(studentId: 'S01', courseId: 'C101');
    lms.enrollStudent(studentId: 'S02', courseId: 'C101');

    lms.addResult(studentId: 'S01', courseId: 'C101', score: 85);
    lms.addResult(studentId: 'S02', courseId: 'C101', score: 90);

    lms.removeStudent(studentId: 'S01');

    expect(lms.students.length, 1);
    expect(lms.courses.first.studentIds.contains('S02'), isTrue);
    expect(lms.courses.first.studentIds.contains('S01'), isFalse);
    expect(lms.scores.length, 1);
    expect(lms.scores.first.studentId, 'S02');
  });

  test('Task 4: Add a valid result', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S01', studentName: 'Alice');
    lms.addCourse(courseId: 'C101', courseName: 'Math');
    lms.enrollStudent(studentId: 'S01', courseId: 'C101');

    final result = lms.addResult(studentId: 'S01', courseId: 'C101', score: 95);
    expect(lms.scores.length, 1);
    expect(result.score, 95);
  });

  test('Task 4: Reject result for non-enrolled student', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S01', studentName: 'Alice');
    lms.addCourse(courseId: 'C101', courseName: 'Math');

    expect(() {
      lms.addResult(studentId: 'S01', courseId: 'C101', score: 95);
    }, throwsException);
  });

  test('Task 4: Reject invalid scores', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S01', studentName: 'Alice');
    lms.addCourse(courseId: 'C101', courseName: 'Math');
    lms.enrollStudent(studentId: 'S01', courseId: 'C101');

    expect(() {
      lms.addResult(studentId: 'S01', courseId: 'C101', score: -5);
    }, throwsException);

    expect(() {
      lms.addResult(studentId: 'S01', courseId: 'C101', score: 105);
    }, throwsException);
  });

  test('Task 4: Reject duplicate result per student/course', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S01', studentName: 'Alice');
    lms.addCourse(courseId: 'C101', courseName: 'Math');
    lms.enrollStudent(studentId: 'S01', courseId: 'C101');
    lms.addResult(studentId: 'S01', courseId: 'C101', score: 90);

    expect(() {
      lms.addResult(studentId: 'S01', courseId: 'C101', score: 80);
    }, throwsException);
  });

  // --- Task 5: Remove Student Result ---
  test('Task 5: Remove existing result', () {
    final lms = LmsSystem();

    lms.addStudent(studentId: 'S01', studentName: 'Alice');
    lms.addCourse(courseId: 'C101', courseName: 'Math');
    lms.enrollStudent(studentId: 'S01', courseId: 'C101');
    final res = lms.addResult(studentId: 'S01', courseId: 'C101', score: 90);

    lms.removeResult(resultId: res.id);
    expect(lms.scores.isEmpty, isTrue);
  });

  test('Task 5: Reject removal of nonexistent result', () {
    final lms = LmsSystem();

    expect(() {
      lms.removeResult(resultId: '999');
    }, throwsException);
  });
}
