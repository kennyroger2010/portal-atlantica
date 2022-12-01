import { AfterViewInit, Component, Input, OnInit, ViewChild } from '@angular/core';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { Router } from '@angular/router';
import { merge, Observable, of as observableOf, Subject } from 'rxjs';
import { catchError, map, startWith, switchMap } from 'rxjs/operators';
import { ReadParam } from '../../models/params';
import { CrudService } from '../../services/crud.service';

@Component({
  selector: 'app-grid-detail',
  templateUrl: './grid-detail.component.html',
  styleUrls: ['./grid-detail.component.css']
})
export class GridDetailComponent implements OnInit, AfterViewInit {

  @Input() page: any = {};

  @Input() displayedColumns: any[] = [];

  columnsToDisplay: string[] = [];

  search = '';
  resultsLength = 0;
  isLoadingResults = true;
  isRateLimitReached = false;
  dataSource: Observable<any[]> = new Observable();
  filterString: Subject<string> = new Subject<string>();
  readParams: ReadParam = { endpoint: '', pageIndex: 0, pageSize: 0 };

  @ViewChild(MatPaginator) paginator!: MatPaginator;
  @ViewChild(MatSort) sort!: MatSort;

  constructor(private crudService: CrudService, private router: Router) { }

  ngOnInit(): void {

    this.readParams.endpoint = this.page.endpoint;

    this.columnsToDisplay = this.displayedColumns.map(function (elem) {
      return elem.field;
    });

  }

  ngAfterViewInit() {

    this.dataSource = merge(this.sort.sortChange, this.paginator.page, this.filterString)
      .pipe(
        startWith({}),
        switchMap(() => {
          this.isLoadingResults = true;
          this.readParams.pageIndex = this.paginator.pageIndex;
          this.readParams.pageSize = this.paginator.pageSize;
          this.readParams.sortField = this.sort.active;
          this.readParams.sort = this.sort.direction;
          this.readParams.search = this.search;
          this.readParams.id = this.page.id;
          return this.crudService!.read(this.readParams);
        }),
        map(data => {
          this.isLoadingResults = false;
          this.isRateLimitReached = false;
          this.resultsLength = data.total;
          return data.data;
        }),
        catchError(() => {
          this.isLoadingResults = false;
          this.isRateLimitReached = true;
          return observableOf([]);
        })
      );

  }

  resetPaging(): void {
    this.paginator.pageIndex = 0;
  }

  applyFilter() {
    this.filterString.next(this.search);
  }

  reload() {
    this.search = '';
    this.filterString.next(this.search);
  }

}
