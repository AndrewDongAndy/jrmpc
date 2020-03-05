#include <bits/stdc++.h>

using namespace std;

// (death) 1
//(warpTo 10@10) 2
// (jump 10)3

const int ROWS = 10;
const int COLS = 10;

mt19937 rng;

string grid[ROWS][COLS];

int randint(int lo, int hi) {
  return rng() % (hi - lo + 1) + lo;
}

void addLine(int r1, int c1, int r2, int c2, int val, int tempr, int tempc) {
  string nVal = to_string(val);
  if (val == 1) {
    nVal = "(death)";
  } else if (val == 2) {
    nVal = "(warpTo " + to_string(tempr) + "@" + to_string(tempc) + ")";
  } else if (val == 3) {
    nVal = "(jump " + to_string(tempr) + ")";
  }
  if (r1 == r2) {
    for (int i = min(c1, c2); i <= max(c1, c2); i++)
      grid[r1][i] = nVal;
  } else {
    for (int i = min(r1, r2); i <= max(r1, r2); i++)
      grid[i][c1] = nVal;
  }
}

void addTrap(int r, int c, int midVal, int len, int wid) {
  for (int i = r + 1; i < r + wid; i++) {
    for (int j = c + 1; j < c + len; j++) {
      grid[r][c] = to_string(midVal);
    }
  }
  // vert
  addLine(r, c, r+wid, c, 1, 1, 1);
  addLine(r, c + len, r + wid, c + len, 1, 1, 1);
  // hort
  addLine(r, c, r, c + len, 1, 1, 1);
  addLine(r + wid, c, r + wid, c + len, 1, 1, 1);


}

void printGrid() {
  int start_row = 100;
  int start_col = 100;
  cout << "#(\n";
  for (int r = 0; r < ROWS; r++) {
    cout << "#(";
    for (int c = 0; c < COLS; c++) {
      if (c > 0) {
        cout << ' ';
      }
      if (r == start_row && c == start_col) {
        cout << "S";
        continue;
      }
      cout << grid[r][c];
    }
    cout << ")\n";
  }
  cout << ");";
}

int main() {
  ios::sync_with_stdio(0);
  cin.tie(0);

  freopen("/Users/huogenx/Desktop/JRMPC/output.txt", "w", stdout);

  for (int r = 0; r < ROWS; r++) {
    for (int c = 0; c < COLS; c++) {
      int x = max(0, randint(-5, 30));
      if (6 <= r && r < 14 && 2 <= c && c < 16) {
        x = 70;
      }
      grid[r][c] = to_string(x);
    }
  }
  // add line from:
  // row1, col1 to row2, col2 with a value, and other stuff.
  // r1, c1, r2, c2, val, temp1, temp2
  // temp1 will be used as value for jump squares
  // temp1 and temp2 will be used as coordinates for warp squares
  // 1 = death, 2 = warp, 3 = jump.
  //addLine(0, 0, 0, 5, 1, 2, 2);

  // add square trap:
  // first 2 parameters are (r, c) for top left of square
  // next val is the val you want on the inside
  // next 2 vals are the length and width
  //addTrap(0, 0, 3, 3, 5);
  printGrid();

  return 0;
}
