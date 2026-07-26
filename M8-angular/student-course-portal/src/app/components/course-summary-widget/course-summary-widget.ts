import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CourseService } from '../../services/course';

@Component({
  selector: 'app-course-summary-widget',
  imports: [CommonModule],
  templateUrl: './course-summary-widget.html',
  styleUrl: './course-summary-widget.css'
})
export class CourseSummaryWidget {
  constructor(public courseService: CourseService) {}

  addRandomCourse() {
    this.courseService.createCourse({
      name: 'Random Added Course',
      code: 'RND101',
      credits: 3,
      gradeStatus: 'pending'
    }).subscribe(() => {
      // Refresh the list
      this.courseService.getCourses();
    });
  }
}
