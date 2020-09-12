#include <bits/stdc++.h>

using namespace std;


const int ROWS = 50;
const int COLS = 50;
const int SIZE = 5; // bfs size

long long a[ROWS][COLS];
int sr, sc;
int rem = 600;

long long dp[4][ROWS][COLS];
int dist[4][ROWS][COLS];

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

int norm(int r) {
  return (r % ROWS + ROWS) % ROWS;
}

void calc_values(int r, int c) {
  for (int d = 0; d < 4; d++) {
    for (int i = 0; i < ROWS; i++) {
      for (int j = 0; j < COLS; j++) {
        if (i == 0 && j == 0) {
          continue;
        }
        int sgni = (d % 2 == 0 ? 1 : -1);
        int sgnj = (d / 2 == 0 ? 1 : -1);
        int ii = norm(r + sgni * i);
        int jj = norm(c + sgnj * j);
        int li = norm(ii - sgni);
        int lj = norm(jj - sgnj);
        if (i > 0) {
          dp[d][ii][jj] = max(dp[d][ii][jj], dp[d][li][jj]);
          dist[d][ii][jj] = dist[d][li][jj] + 1;
        }
        if (j > 0) {
          dp[d][ii][jj] = max(dp[d][ii][jj], dp[d][ii][lj]);
          dist[d][ii][jj] = dist[d][ii][lj] + 1;
        }
        dp[d][ii][jj] += a[ii][jj];
      }
    }
  }
}

int main() {
  ios::sync_with_stdio(0);
  cin.tie(0);

  freopen("input_grid.txt", "r", stdin);

  read();
  for ()


  return 0;
}
