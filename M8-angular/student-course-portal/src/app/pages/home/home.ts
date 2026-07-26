import { Component, OnInit, OnDestroy } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { CourseService } from '../../services/course';
import { CourseSummaryWidget } from '../../components/course-summary-widget/course-summary-widget';
import { NotificationComponent } from '../../components/notification/notification';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';
import { Course } from '../../models/course.model';

@Component({
  selector: 'app-home',
  imports: [CommonModule, FormsModule, CourseSummaryWidget, NotificationComponent],
  templateUrl: './home.html',
  styleUrl: './home.css'
})
export class Home implements OnInit, OnDestroy {
  portalName = 'Student Course Portal';
  isPortalActive = true;
  message = '';
  searchTerm = '';
  courses$!: Observable<Course[]>;

  constructor(public courseService: CourseService, private router: Router) {}

  onEnrollClick() {
    this.message = 'Enrollment opened!';
  }

  onSearch() {
    this.router.navigate(['courses'], { queryParams: { search: this.searchTerm } });
  }

  ngOnInit() {
    console.log('HomeComponent initialised — loading courses stream');
    this.courses$ = this.courseService.getCourses();
  }

  ngOnDestroy() {
    console.log('HomeComponent destroyed');
  }
}
