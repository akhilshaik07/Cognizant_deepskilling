import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { CourseService } from '../../services/course';
import { EnrollmentService } from '../../services/enrollment';
import { Course } from '../../models/course.model';
import { CommonModule } from '@angular/common';
import { CreditLabelPipe } from '../../pipes/credit-label-pipe';
import { Observable } from 'rxjs';
import { switchMap } from 'rxjs/operators';

@Component({
  selector: 'app-course-detail',
  imports: [CommonModule, CreditLabelPipe],
  templateUrl: './course-detail.html',
  styleUrl: './course-detail.css'
})
export class CourseDetail implements OnInit {
  course$!: Observable<Course>;
  students$!: Observable<any[]>;

  constructor(
    private route: ActivatedRoute, 
    private courseService: CourseService,
    private enrollmentService: EnrollmentService
  ) {}

  ngOnInit() {
    this.course$ = this.route.paramMap.pipe(
      switchMap(params => {
        const id = Number(params.get('id'));
        return this.courseService.getCourseById(id);
      })
    );

    // switchMap cancels the previous inner Observable when a new courseId arrives.
    // If the user navigates rapidly between courses, this prevents a delayed 
    // HTTP response from an older course from overwriting the newer course's data.
    this.students$ = this.route.paramMap.pipe(
      switchMap(params => {
        const id = Number(params.get('id'));
        return this.enrollmentService.getStudentsByCourse(id);
      })
    );
  }
}
