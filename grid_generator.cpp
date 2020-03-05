#include <bits/stdc++.h>

using namespace std;


const int ROWS = 200;
const int COLS = 200;

mt19937 rng;

int randint(int lo, int hi) {
  return rng() % (hi - lo + 1) + lo;
}

int main() {
  ios::sync_with_stdio(0);
  cin.tie(0);

  freopen("/Users/huogenx/Desktop/JRMPC/output.txt", "w", stdout);

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
      int x = max(0, randint(-5, 30));
      if (6 <= r && r < 14 && 2 <= c && c < 16) {
        x = 70;
      }
      cout << x;
    }
    cout << ")\n";
  }
  cout << ");";

  return 0;
}
