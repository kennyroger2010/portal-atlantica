import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class ToolsService {

  constructor() { }

  arrayMax(arr: any, field: string) {

    var len = arr.length, max = "";

    while (len--) {

      if (arr[len][field] > max) {
        max = arr[len][field];
      }

    }
    return max;
  };

  retNumber(lastItem: string, lastNumber: string, str: any) {

    if (lastItem !== str) {

      if (str < lastNumber) {
        str = parseInt(str) + 1;
      } else {
        str = (parseInt(str, 36) + 1).toString(36);
      }

    }
    return str;
  };

  nextSequence(obj: any, field: string) {

    let str = '0';
    let strLength = 1;
    let lastItem = 'Z'.repeat(strLength);
    let lastNumber = '9'.repeat(strLength);
    let max = '';

    if (obj) {

      if (obj) {
        max = this.arrayMax(obj, field);
      }

      if (!max && obj.size > 0) {
        max = this.strZero("0", strLength).toUpperCase();
      }

      str = max;
      strLength = max.length;
      lastItem = "Z".repeat(strLength);
      lastNumber = "9".repeat(strLength);

      str = this.retNumber(lastItem, lastNumber, str);

    } else if (obj.count) {

      str = obj.count;
      strLength = obj.count.length;
      lastItem = "Z".repeat(strLength);
      lastNumber = "9".repeat(strLength);

      str = this.retNumber(lastItem, lastNumber, str);

    }
    return this.strZero(str, strLength).toUpperCase();
  }

  strZero(num: string, places: number) {

    var zero = places - num.toString().length + 1;

    return new Array(+(zero > 0 && zero)).join("0") + num;
  };

}
