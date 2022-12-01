import { Component } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { AuthService } from '../services/auth.service';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {

  loginForm = this.fb.group({
    'user': ['', Validators.required],
    'pass': ['', Validators.compose([
      Validators.required, Validators.minLength(3), Validators.maxLength(6)])
    ]
  });

  constructor(private fb: FormBuilder, private authService: AuthService, private snackBar: MatSnackBar, private router: Router) { }

  ngOnInit() {
  }

  onSubmit(): void {

    this.authService.auth(this.loginForm.value.user, this.loginForm.value.pass)
      .subscribe((response) => {

        let objeto = response.data;

        objeto.Authorization = btoa(this.loginForm.value.user + ":" + this.loginForm.value.pass);
        
        localStorage.setItem('auth', JSON.stringify(objeto));

        this.router.navigate(['dashboard']);

        this.snackBar.open(
          'Seja bem-vindo(a) ' + response.data.nome + '!', 'OK',
          { duration: 3000 }
        );

      }, erro => {

        console.error(erro);

        this.snackBar.open(
          erro.error.message, 'OK',
          { duration: 3000 }
        );

      })

  }

}
