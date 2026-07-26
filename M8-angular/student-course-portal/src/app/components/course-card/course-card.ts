import { Component, Input, OnInit, OnChanges, SimpleChanges } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CreditLabelPipe } from '../../pipes/credit-label-pipe';
import { Course } from '../../models/course.model';
import { Store } from '@ngrx/store';
import { selectEnrolledIds } from '../../store/enrollment/enrollment.selectors';
import { enrollInCourse, unenrollFromCourse } from '../../store/enrollment/enrollment.actions';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-course-card',
  imports: [CommonModule, CreditLabelPipe],
  templateUrl: './course-card.html',
  styleUrl: './course-card.css'
})
export class CourseCard implements OnInit, OnChanges {
  @Input() course!: Course;
  isExpanded = false;
  enrolledIds$!: Observable<number[]>;

  constructor(private store: Store) {}

  ngOnInit() {
    this.enrolledIds$ = this.store.select(selectEnrolledIds);
  }

  get borderStyle() {
    let color = 'grey';
    if (this.course?.gradeStatus === 'passed') color = 'green';
    if (this.course?.gradeStatus === 'failed') color = 'red';
    return { 'border-left-color': color, 'border-left-width': '5px', 'border-left-style': 'solid' };
  }

  ngOnChanges(changes: SimpleChanges) {
    if (changes['course']) {
      console.log('Course changed. Previous:', changes['course'].previousValue, 'Current:', changes['course'].currentValue);
    }
  }

  toggleDetails(event: Event) {
    event.stopPropagation();
    this.isExpanded = !this.isExpanded;
  }

  toggleEnrollment(event: Event, isEnrolled: boolean) {
    event.stopPropagation();
    if (isEnrolled) {
      this.store.dispatch(unenrollFromCourse({ courseId: this.course.id }));
    } else {
      this.store.dispatch(enrollInCourse({ courseId: this.course.id }));
    }
  }
}
