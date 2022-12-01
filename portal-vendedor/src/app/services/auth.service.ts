import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { tap } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  constructor(private httpClient: HttpClient) { }

  auth(user: string, pass: string) {

    const httpOptions = {
      headers: new HttpHeaders({
        Authorization: 'BASIC ' + btoa(user + ":" + pass),
        UserKey:  'BASIC ' + btoa(user + ":" + pass)
      })
    };
    
    return this.httpClient.get<any>('http://localhost:8084/rest/login', httpOptions);

  }

}
