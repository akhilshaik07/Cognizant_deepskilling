import { createFeatureSelector, createSelector } from '@ngrx/store';
import { EnrollmentState } from './enrollment.reducer';
import { selectAllCourses } from '../course/course.selectors';
import { Course } from '../../models/course.model';

export const selectEnrollmentState = createFeatureSelector<EnrollmentState>('enrollment');

export const selectEnrolledIds = createSelector(
  selectEnrollmentState,
  (state: EnrollmentState) => state.enrolledCourseIds
);

export const selectEnrolledCourses = createSelector(
  selectAllCourses,
  selectEnrolledIds,
  (allCourses: Course[], enrolledIds: number[]) => {
    return enrolledIds
      .map(id => allCourses.find(c => c.id === id))
      .filter((c): c is Course => c !== undefined);
  }
);
