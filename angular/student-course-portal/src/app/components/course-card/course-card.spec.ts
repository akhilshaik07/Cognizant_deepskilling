import { ComponentFixture, TestBed } from '@angular/core/testing';
import { CourseCard } from './course-card';
import { By } from '@angular/platform-browser';
import { SimpleChange } from '@angular/core';
import { provideMockStore, MockStore } from '@ngrx/store/testing';

describe('CourseCard', () => {
  let component: CourseCard;
  let fixture: ComponentFixture<CourseCard>;
  let store: MockStore;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CourseCard],
      providers: [provideMockStore({ initialState: { enrollment: { enrolledCourseIds: [] } } })]
    })
    .compileComponents();

    fixture = TestBed.createComponent(CourseCard);
    component = fixture.componentInstance;
    store = TestBed.inject(MockStore);
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should render course details correctly', () => {
    component.course = { id: 1, name: 'Data Structures', code: 'CS101', credits: 4, gradeStatus: 'passed' };
    fixture.detectChanges();
    const h3 = fixture.debugElement.query(By.css('h3')).nativeElement;
    expect(h3.textContent).toContain('Data Structures (CS101)');
  });

  it('should dispatch enroll action on enroll button click', () => {
    component.course = { id: 1, name: 'Data Structures', code: 'CS101', credits: 4, gradeStatus: 'passed' };
    fixture.detectChanges();
    vi.spyOn(store, 'dispatch');
    const button = fixture.debugElement.query(By.css('button')).nativeElement;
    button.click();
    fixture.detectChanges();
    expect(store.dispatch).toHaveBeenCalled();
  });

  it('should log on ngOnChanges', () => {
    vi.spyOn(console, 'log');
    component.ngOnChanges({
      course: new SimpleChange(null, { id: 1, name: 'Test', code: 'TEST', credits: 3, gradeStatus: 'pending' }, true)
    });
    expect(console.log).toHaveBeenCalled();
  });
});
