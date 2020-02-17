#include <bits/stdc++.h>

using namespace std;


const int ROWS = 50;
const int COLS = 50;

int a[ROWS][COLS];
int sr, sc;

void read() {
  for (int r = 0; r < ROWS; r++) {
    for (int c = 0; c < COLS; c++) {
      string s;
      cin >> s;
      if (s == "S") {
        sr = r;
        sc = c;
      } else {
        a[r][c] = stoi(s);
      }
    }
  }
}

int main() {
  ios::sync_with_stdio(0);
  cin.tie(0);

  freopen("input_grid.txt", "r", stdin);

  read();

  return 0;
}
