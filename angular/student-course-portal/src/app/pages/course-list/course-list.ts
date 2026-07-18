import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CourseCard } from '../../components/course-card/course-card';
import { Highlight } from '../../directives/highlight';
import { Course } from '../../models/course.model';
import { Router, ActivatedRoute } from '@angular/router';
import { Store } from '@ngrx/store';
import { selectAllCourses, selectCoursesLoading, selectCoursesError } from '../../store/course/course.selectors';
import * as CourseActions from '../../store/course/course.actions';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-course-list',
  imports: [CommonModule, CourseCard, Highlight],
  templateUrl: './course-list.html',
  styleUrl: './course-list.css'
})
export class CourseList implements OnInit {
  isLoading$!: Observable<boolean>;
  courses$!: Observable<Course[]>;
  errorMessage$!: Observable<string | null>;
  searchTerm = '';

  constructor(
    private store: Store,
    private router: Router,
    private route: ActivatedRoute
  ) {}

  ngOnInit() {
    const search = this.route.snapshot.queryParamMap.get('search');
    if (search) {
      this.searchTerm = search;
    }
    
    this.courses$ = this.store.select(selectAllCourses);
    this.isLoading$ = this.store.select(selectCoursesLoading);
    this.errorMessage$ = this.store.select(selectCoursesError);
    this.store.dispatch(CourseActions.loadCourses());
  }

  trackByCourseId(index: number, course: any): number {
    return course.id;
  }

  goToCourseDetail(courseId: number) {
    this.router.navigate(['courses', courseId]);
  }
}
