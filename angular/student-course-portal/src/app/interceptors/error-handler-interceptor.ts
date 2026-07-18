import { HttpInterceptorFn, HttpErrorResponse } from '@angular/common/http';
import { inject } from '@angular/core';
import { Router } from '@angular/router';
import { catchError } from 'rxjs/operators';
import { throwError } from 'rxjs';

export const errorHandlerInterceptor: HttpInterceptorFn = (req, next) => {
  const router = inject(Router);

  return next(req).pipe(
    catchError((error: HttpErrorResponse) => {
      if (error.status === 401) {
        console.warn('401 Unauthorized - redirecting to home.');
        router.navigate(['/']);
      } else if (error.status === 500) {
        alert('500 Internal Server Error: Something went critically wrong!');
      }
      return throwError(() => error);
    })
  );
};
