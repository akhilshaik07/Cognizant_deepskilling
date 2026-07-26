import { ComponentFixture, TestBed } from '@angular/core/testing';
import { CourseList } from './course-list';
import { provideMockStore, MockStore } from '@ngrx/store/testing';
import { provideRouter } from '@angular/router';
import { By } from '@angular/platform-browser';

describe('CourseList', () => {
  let component: CourseList;
  let fixture: ComponentFixture<CourseList>;
  let store: MockStore;
  
  const mockCourses = [
    { id: 1, name: 'Course 1', code: 'C1', credits: 3, gradeStatus: 'passed' as 'passed' }
  ];

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CourseList],
      providers: [
        provideRouter([]),
        provideMockStore({ 
          initialState: { 
            course: { courses: mockCourses, loading: false, error: null },
            enrollment: { enrolledCourseIds: [] } 
          } 
        })
      ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(CourseList);
    component = fixture.componentInstance;
    store = TestBed.inject(MockStore);
    fixture.detectChanges();
  });

  it('should render course cards based on initial state', () => {
    const courseCards = fixture.debugElement.queryAll(By.css('app-course-card'));
    expect(courseCards.length).toBe(1);
  });

  it('should display loading indicator when loading is true', () => {
    store.setState({ 
      course: { courses: [], loading: true, error: null },
      enrollment: { enrolledCourseIds: [] } 
    });
    fixture.detectChanges();

    const loadingText = fixture.debugElement.query(By.css('p')).nativeElement;
    expect(loadingText.textContent).toContain('Loading courses...');
  });
});
