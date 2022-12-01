import { Component } from '@angular/core';
import { BreakpointObserver, Breakpoints } from '@angular/cdk/layout';
import { Observable } from 'rxjs';
import { map, shareReplay } from 'rxjs/operators';
import { Router } from '@angular/router';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ProfileComponent } from '../profile/profile.component';


@Component({
  selector: 'app-menu',
  templateUrl: './menu.component.html',
  styleUrls: ['./menu.component.css']
})
export class MenuComponent {

  public user: any;

  isHandset$: Observable<boolean> = this.breakpointObserver.observe(Breakpoints.Handset)
    .pipe(
      map(result => result.matches),
      shareReplay()
    );

  constructor(private breakpointObserver: BreakpointObserver, private router: Router, public dialog: MatDialog) { }

  ngOnInit() {

    this.user = localStorage.getItem('auth');

    this.user = JSON.parse(this.user);

  }

  profile() {

    const dialogRef = this.dialog.open(ProfileComponent, {
      width: '230px',
      data: { }
    });

  }

  logout() {
    localStorage.removeItem('auth');
    this.router.navigate(['login']);
  }

}
