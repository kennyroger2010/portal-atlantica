import { Component, OnInit } from '@angular/core';
import { MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.css']
})
export class ProfileComponent implements OnInit {
  
  user: any = '';
  
  constructor(public dialogRef: MatDialogRef<ProfileComponent>) { }

  ngOnInit(): void {
    this.user = localStorage.getItem('auth');
    this.user = JSON.parse(this.user);
  }

  onClose() {
    this.dialogRef.close();
  }

}
