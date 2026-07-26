import { Component } from '@angular/core';
import { NotificationService } from '../../services/notification';

@Component({
  selector: 'app-notification',
  imports: [],
  providers: [NotificationService],
  templateUrl: './notification.html',
  styleUrl: './notification.css'
})
export class NotificationComponent {
  constructor(public notificationService: NotificationService) {}

  // Component-level providers create a new instance of the service specifically scoped to this component 
  // and its children. This is useful when you want isolated state (like a local notification stack) 
  // instead of a global singleton where notifications might leak across the entire app.
}
