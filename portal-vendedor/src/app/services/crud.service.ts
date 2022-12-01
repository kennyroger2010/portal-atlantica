import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ɵangular_packages_forms_forms_x } from '@angular/forms';
import { EMPTY, Observable } from 'rxjs';
import { ReadParam, SaveParam } from '../models/params';

@Injectable({
  providedIn: 'root'
})
export class CrudService {

  user: any;
  httpOptions: any;
  host: string = 'http://localhost:8084/rest/'

  constructor(private httpClient: HttpClient) {

    this.user = localStorage.getItem('auth');
    this.user = JSON.parse(this.user);

    this.httpOptions = {
      headers: new HttpHeaders({
        Authorization: 'BASIC ' + this.user.Authorization
      })
    };

  }

  read(params: ReadParam): Observable<any> {

    let url = this.host + params.endpoint;

    if (params.id && !params.sortField) {

      url += '/' + params.id;

    } else {

      url += '?pageNumber=' + (params.pageIndex + 1).toString()
        + '&rowsPage=' + params.pageSize.toString()
        + '&sortField=' + params.sortField
        + '&sort=' + params.sort
        + '&search=' + params.search
        + '&id=' + params.id
        ;

    }

    return this.httpClient.get<any>(url, this.httpOptions);

  }

  save(params: SaveParam): Observable<any> {

    let url = this.host + params.endpoint;

    if (params.method == 'post') {

      let newBody = {
        action: parseInt(params.action),
        data: params.body
      }

      return this.httpClient.post<any>(url, newBody, this.httpOptions);

    } else if (params.action == '3') {

      return this.httpClient.post<any>(url, params.body, this.httpOptions);

    } else if (params.action == '4') {

      return this.httpClient.put<any>(url, params.body, this.httpOptions);

    } else if (params.action == '5') {

      this.httpOptions.body = params.body;

      return this.httpClient.delete<any>(url, this.httpOptions);

    } else {

      return EMPTY;

    }

  }

  create(endpoint: string, body: any): Observable<any> {

    let url = this.host + endpoint;

    return this.httpClient.post<any>(url, body, this.httpOptions);

  }

  update(endpoint: string, body: any): Observable<any> {

    let url = this.host + endpoint;

    return this.httpClient.put<any>(url, body, this.httpOptions);

  }

  delete(endpoint: string, body: any): Observable<any> {

    let url = this.host + endpoint;

    return this.httpClient.delete<any>(url, this.httpOptions);

  }

}
