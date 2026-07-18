import { Routes } from '@angular/router';
import { Home } from './pages/home/home';
import { CourseList } from './pages/course-list/course-list';
import { StudentProfileComponent } from './pages/student-profile/student-profile';
import { CourseDetail } from './pages/course-detail/course-detail';
import { NotFound } from './pages/not-found/not-found';
import { CoursesLayout } from './pages/courses-layout/courses-layout';
import { AuthGuard } from './guards/auth.guard';

export const routes: Routes = [
  { path: '', component: Home },
  { 
    path: 'courses', 
    component: CoursesLayout,
    children: [
      { path: '', component: CourseList },
      { path: ':id', component: CourseDetail }
    ]
  },
  { 
    path: 'enroll', 
    loadChildren: () => import('./features/enrollment/enrollment-module').then(m => m.EnrollmentModule) 
  },
  { path: 'profile', component: StudentProfileComponent, canActivate: [AuthGuard] },
  { path: '**', component: NotFound }
];
