import { TestBed } from '@angular/core/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { CourseService } from './course';

describe('CourseService', () => {
  let service: CourseService;
  let httpMock: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [CourseService]
    });
    service = TestBed.inject(CourseService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify();
  });

  it('should get courses', () => {
    const mockCourses = [
      { id: 1, name: 'Course A', code: 'C1', credits: 3, gradeStatus: 'passed' as 'passed' },
      { id: 2, name: 'Course B', code: 'C2', credits: 4, gradeStatus: 'pending' as 'pending' }
    ];

    service.getCourses().subscribe(courses => {
      expect(courses.length).toBe(2);
    });

    const req = httpMock.expectOne('http://localhost:3000/courses');
    expect(req.request.method).toBe('GET');
    req.flush(mockCourses);
  });

  it('should handle error when getting courses fails', () => {
    service.getCourses().subscribe({
      next: () => expect.fail('expected an error, not courses'),
      error: error => {
        expect(error.message).toContain('Failed to load courses. Please try again.');
      }
    });

    const req1 = httpMock.expectOne('http://localhost:3000/courses');
    req1.flush('500 error', { status: 500, statusText: 'Server Error' });

    const req2 = httpMock.expectOne('http://localhost:3000/courses');
    req2.flush('500 error', { status: 500, statusText: 'Server Error' });

    const req3 = httpMock.expectOne('http://localhost:3000/courses');
    req3.flush('500 error', { status: 500, statusText: 'Server Error' });
  });
});
