//Splits an array into an array of arrays of set length

angular.module('mdme-admin').service('SplitArrayService', function () {
  return {
    SplitArray: function (array, columns) {
      if (array.length <= columns) {
        return [array];
      }

      var rowsNum = Math.ceil(array.length / columns);

      var rowsArray = new Array(rowsNum);

      for (var i = 0; i < rowsNum; i++) {
        var columnsArray = new Array(columns);
        for (j = 0; j < columns; j++) {
          var index = i * columns + j;

          if (index < array.length) {
            columnsArray[j] = array[index];
          } else {
            break;
          }
        }
        rowsArray[i] = columnsArray;
      }
      return rowsArray;
    }
  }
});