#include <bits/stdc++.h>

using namespace std;


class Mind {
public:
  constexpr int INF = 1000000000;
  constexpr int ROWS = 50;
  constexpr int COLS = 50;

  int a[ROWS][COLS];
  int dp[4][ROWS][COLS];
  int dist[4][ROWS][COLS];
  pair<int, int> last[4][ROWS][COLS];

  int sr, sc; // current row and column
  int rem;
  queue<int> moves;

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

  Mind() {
    read();
    rem = 600;
  }

  int norm(int r) {
    return (r % ROWS + ROWS) % ROWS;
  }

  void calc_values(int r, int c) {
    vector<pair<int, pair<int, int>>> v;
    for (int d = 0; d < 4; d++) {
      for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
          dp[d][i][j] = -INF;
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
            if (dp[d][li][jj] > dp[d][ii][jj]) {
              dp[d][ii][jj] = dp[d][li][jj];
              last[d][ii][jj] = {li, jj};
            }
            dist[d][ii][jj] = dist[d][li][jj] + 1;
          }
          if (j > 0) {
            if (dp[d][ii][lj] > dp[d][ii][jj]) {
              dp[d][ii][jj] = dp[d][ii][lj];
              last[d][ii][jj] = {ii, lj};
            }
            dist[d][ii][jj] = dist[d][ii][lj] + 1;
          }
          dp[d][ii][jj] += a[ii][jj];
          v.emplace_back(d, ii, jj);
        }
      }
    }
    sort(v.begin(), v.end(), [&](const pair<int, pair<int, int>> &a, const ))
  }

  int get_move() {
    rem--;
    int ret = -1;
    if (!q.empty()) {
      ret = q.front();
      q.pop();
    } else {
      calc_values(sr, sc);
    }
    return ret;
  }
};

void calc_values(int r, int c) {
  for (int )
  for (int i = 0; i <= 50; i++) {
    for (int j = 0; j <= 50; j++) {
      if (i == 0 && j == 0) {
        continue;
      }
      if (i == 0) {

      }
    }
  }
  for (int d = 1; d <= 50; d++) {
    for (int rr = r - d; rr <= r + d; rr++) {
      int nr = (rr % ROWS + ROWS) % ROWS;

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
