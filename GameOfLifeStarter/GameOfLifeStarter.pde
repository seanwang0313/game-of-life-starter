final int SPACING = 10; // each cell's width/height //<>// //<>//
final float DENSITY = 0.5; // how likely each cell is to be alive at the start
int[][] grid; // the 2D array to hold 0's and 1's
int cols, rows;
int [][] ageGrid;
boolean paused = false;
boolean stepNext = false;

void setup() {
  size(800, 600); // adjust accordingly, make sure it's a multiple of SPACING
  noStroke(); // don't draw the edges of each cell
  frameRate(30); // controls speed of regeneration

  cols = width/SPACING;
  rows = height/SPACING;
  grid = new int[rows][cols];
  ageGrid = new int [rows][cols]; // 2d array for the age

  // initialize
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      if (random(1) <= DENSITY) {
        grid[y][x] = 1;
        ageGrid[y][x] = 1;
      } else {
        grid[y][x] = 0;
        ageGrid[y][x] = 0;
      }
    }
  }
}

void draw() {
  background(0);
  showGrid();

  if (!paused || stepNext) { // to ensure stopping and stepping
    grid = calcNextGrid();
    stepNext = false;
  }
}

void keyPressed() {
  if (key == ' ') {
    paused = !paused;
  } else if (keyCode == RIGHT) {
    stepNext = true;
  }
}

int[][] calcNextGrid() {
  int[][] nextGrid = new int[rows][cols];
  int[][] nextAgeGrid = new int[rows][cols];

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      int neighbors = countNeighbors(y, x);

      if (grid[y][x] == 1) {
        if (neighbors == 2 || neighbors == 3) {
          nextGrid[y][x] = 1;
          nextAgeGrid[y][x] = ageGrid[y][x] + 1;
        } else {
          nextGrid[y][x] = 0;
          nextAgeGrid[y][x] = 0;
        }
      } else {
        if (neighbors == 3) {
          nextGrid[y][x] = 1;
          nextAgeGrid[y][x] = ageGrid[y][x] + 1;
        } else {
          nextGrid[y][x] = 0;
          nextAgeGrid[y][x] = 0;
        }
      }
    }
  }
  ageGrid = nextAgeGrid;
  return nextGrid;
}

int countNeighbors(int y, int x) {
  int n = 0; // don't count yourself!

  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      if (i == 0 && j == 0) {
        continue;
      }
      int newY = y + i;
      int newX = x + j;

      if (newY >= 0 && newY < rows && newX >= 0 && newX < cols) {
        n += grid[newY][newX];
      }
    }
  }
  return n;
}

void showGrid() {
  int brightness = 0;
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      if (grid[i][j] == 1) {
        brightness = min(255, max(50, ageGrid[i][j] * 5)); // set boundary for the brightness
        fill (255, brightness, brightness); // gradually become white
        square(j * SPACING, i * SPACING, SPACING);
      }
    }
  }
}
