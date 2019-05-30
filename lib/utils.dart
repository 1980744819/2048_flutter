import 'data.dart';
import 'conf.dart';

void updateScore(int val) {
  score += val;
}

List<List<int>> getMoveDownDistance(List<List<Data>> input) {
  var res = new List<List<int>>();
  for (int i = 0; i < input.length; i++) {
    res.add(new List<int>());
    for (int j = 0; j < input[i].length; j++) {
      res[i].add(0);
    }
  }
  for (int j = 0; j < input[0].length; j++) {
    int tmp = 0;
    for (int i = input.length - 1; i >= 0; i--) {
      res[i][j] = tmp;
      if (input[i][j].value == 0) {
        tmp += 1;
      }
    }
  }
  return res;
}

List<List<int>> getMoveLeftDistance(List<List<Data>> input) {
  var res = new List<List<int>>();
  for (int i = 0; i < input.length; i++) {
    res.add(new List<int>());
    int tmp = 0;
    for (int j = 0; j < input[i].length; j++) {
      res[i].add(tmp);
      if (input[i][j].value == 0) {
        tmp += 1;
      }
    }
  }
  return res;
}

List<List<int>> getMoveRightDistance(List<List<Data>> input) {
  var res = new List<List<int>>();
  for (int i = 0; i < input.length; i++) {
    res.add(new List<int>());
    for (int j = 0; j < input[i].length; j++) {
      res[i].add(0);
    }
  }
  for (int i = 0; i < input.length; i++) {
    int tmp = 0;
    for (int j = input[i].length - 1; j >= 0; j--) {
      res[i][j] = tmp;
      if (input[i][j].value == 0) {
        tmp += 1;
      }
    }
  }
  return res;
}

List<List<Data>> copyDataMatrix(List<List<Data>> input) {
  var res = new List<List<Data>>();
  for (int i = 0; i < input.length; i++) {
    res.add(new List<Data>());
    for (int j = 0; j < input[i].length; j++) {
      res[i].add(Data(input[i][j].value, input[i][j].left, input[i][j].top));
    }
  }
  return res;
}

List<List<Data>> getMovedDownGridMatrix(
    List<List<int>> distanceMatrix, List<List<Data>> input) {
  for (int j = 0; j < input[0].length; j++) {
    for (int i = input.length - 2; i >= 0; i--) {
      int tmp = input[i][j].value;
      input[i][j].value = 0;
      input[i + distanceMatrix[i][j]][j].value = tmp;
    }
  }
  return input;
}

List<List<Data>> getMovedLeftGridMatrix(
    List<List<int>> distanceMatrix, List<List<Data>> input) {
  for (int i = 0; i < input.length; i++) {
    for (int j = 0; j < input[i].length; j++) {
      var tmp = input[i][j].value;
      input[i][j].value = 0;
      input[i][j - distanceMatrix[i][j]].value = tmp;
    }
  }
  return input;
}

List<List<Data>> getMovedRightGridMatrix(
    List<List<int>> distanceMatrix, List<List<Data>> input) {
  for (int i = 0; i < input.length; i++) {
    for (int j = input[i].length - 1; j >= 0; j--) {
      var tmp = input[i][j].value;
      input[i][j].value = 0;
      input[i][j + distanceMatrix[i][j]].value = tmp;
    }
  }
  return input;
}

List<List<Data>> getMovedDownMergedGridMatrix(
    List<List<int>> distanceMatrix, List<List<Data>> input) {
  for (int j = 0; j < input[0].length; j++) {
    for (int i = input.length - 2; i >= 0; i--) {
      if (distanceMatrix[i][j] == 0) {
        continue;
      }
      int tmp = input[i][j].value + input[i + distanceMatrix[i][j]][j].value;
      if (tmp == input[i][j].value * 2) updateScore(tmp);
      input[i][j].value = 0;
      input[i + distanceMatrix[i][j]][j].value = tmp;

    }
  }
  return input;
}

List<List<Data>> getMovedLeftMergedGridMatrix(
    List<List<int>> distanceMatrix, List<List<Data>> input) {
  for (int i = 0; i < input.length; i++) {
    for (int j = 1; j < input[i].length; j++) {
      if (distanceMatrix[i][j] == 0) {
        continue;
      }
      var tmp = input[i][j].value + input[i][j - distanceMatrix[i][j]].value;
      if (tmp == input[i][j].value * 2) updateScore(tmp);
      input[i][j].value = 0;
      input[i][j - distanceMatrix[i][j]].value = tmp;

    }
  }
  return input;
}

List<List<Data>> getMovedRightMergedGridMatrix(
    List<List<int>> distanceMatrix, List<List<Data>> input) {
  for (int i = 0; i < input.length; i++) {
    for (int j = input[i].length - 2; j >= 0; j--) {
      if (distanceMatrix[i][j] == 0) {
        continue;
      }
      var tmp = input[i][j].value + input[i][j + distanceMatrix[i][j]].value;
      if (tmp == input[i][j].value * 2) updateScore(tmp);
      input[i][j].value = 0;
      input[i][j + distanceMatrix[i][j]].value = tmp;

    }
  }
  return input;
}

List<List<int>> getMoveDownMergeDistance(List<List<Data>> input) {
  var res = new List<List<int>>();
  for (int i = 0; i < input.length; i++) {
    res.add(new List<int>());
    for (int j = 0; j < input[i].length; j++) {
      res[i].add(0);
    }
  }
  var cp = copyDataMatrix(input);
  for (int j = 0; j < cp[0].length; j++) {
    int tmp = 0;
    for (int i = cp.length - 2; i >= 0; i--) {
      if (cp[i][j].value == cp[i + 1][j].value && cp[i][j].value != 0) {
        tmp += 1;
        cp[i][j].value = 0;
      }
      res[i][j] = tmp;
    }
  }
  return res;
}

List<List<int>> getMoveLeftMergeDistance(List<List<Data>> input) {
  var res = new List<List<int>>();
  var cp = copyDataMatrix(input);
  for (int i = 0; i < input.length; i++) {
    res.add(new List<int>());
    res[i].add(0);
    int tmp = 0;
    for (int j = 1; j < input[i].length; j++) {
      if (cp[i][j].value == cp[i][j - 1].value && cp[i][j].value != 0) {
        tmp += 1;
        cp[i][j].value = 0;
      }
      res[i].add(tmp);
    }
  }
  return res;
}

List<List<int>> getMoveRightMergeDistance(List<List<Data>> input) {
  var res = new List<List<int>>();
  var cp = copyDataMatrix(input);
  for (int i = 0; i < input.length; i++) {
    res.add(new List<int>());
    for (int j = 0; j < input[i].length; j++) {
      res[i].add(0);
    }
  }
  for (int i = 0; i < input.length; i++) {
    res.add(new List<int>());
    int tmp = 0;
    for (int j = input[i].length - 2; j >= 0; j--) {
      if (cp[i][j].value == cp[i][j + 1].value && cp[i][j].value != 0) {
        tmp += 1;
        cp[i][j].value = 0;
      }
      res[i][j] = tmp;
    }
  }
  return res;
}

List<List<int>> getMoveUpDistance(List<List<Data>> input) {
  var res = new List<List<int>>();
  for (int i = 0; i < input.length; i++) {
    res.add(new List<int>());
    for (int j = 0; j < input[i].length; j++) {
      res[i].add(0);
    }
  }
  for (int j = 0; j < input[0].length; j++) {
    int tmp = 0;
    for (int i = 0; i < input.length; i++) {
      res[i][j] = tmp;
      if (input[i][j].value == 0) {
        tmp += 1;
      }
    }
  }
  return res;
}

List<List<Data>> getMovedUpGridMatrix(
    List<List<int>> distanceMatrix, List<List<Data>> input) {
  for (int j = 0; j < input[0].length; j++) {
    for (int i = 0; i < input.length; i++) {
      int tmp = input[i][j].value;
      input[i][j].value = 0;
      input[i - distanceMatrix[i][j]][j].value = tmp;
    }
  }
  return input;
}

List<List<int>> getMoveUpMergeDistance(List<List<Data>> input) {
  var res = new List<List<int>>();
  for (int i = 0; i < input.length; i++) {
    res.add(new List<int>());
    for (int j = 0; j < input[i].length; j++) {
      res[i].add(0);
    }
  }
  var cp = copyDataMatrix(input);
  for (int j = 0; j < cp[0].length; j++) {
    int tmp = 0;
    for (int i = 1; i < cp.length; i++) {
      if (cp[i][j].value == cp[i - 1][j].value && cp[i][j].value != 0) {
        tmp += 1;
        cp[i][j].value = 0;
      }
      res[i][j] = tmp;
    }
  }
  return res;
}

List<List<Data>> getMovedUpMergedGridMatrix(
    List<List<int>> distanceMatrix, List<List<Data>> input) {
  for (int j = 0; j < input[0].length; j++) {
    for (int i = 0; i < input.length; i++) {
      if (distanceMatrix[i][j] != 0) {
        int tmp = input[i][j].value + input[i - distanceMatrix[i][j]][j].value;
        if (tmp == input[i][j].value * 2) updateScore(tmp);
        input[i][j].value = 0;
        input[i - distanceMatrix[i][j]][j].value = tmp;

      }
    }
  }
  return input;
}
