

int screen = 0;
// 0 = startside
// 1 = lærerside
// 2 = elevside

void setup() {
  size(900, 700);
  textAlign(CENTER, CENTER);
  textFont(createFont("Arial", 20));
}

void draw() {
  background(220, 230, 245);

  if (screen == 0) {
    drawStartScreen();
  } else if (screen == 1) {
    drawTeacherScreen();
  } else if (screen == 2) {
    drawStudentScreen();
  }
  pushStyle();
  fill(255, 0, 0);
  textSize(16);
  textAlign(LEFT, TOP);
  text("x: " + mouseX + " y: " + mouseY, 10, 10);
  popStyle();
}

// Startside
void drawStartScreen() {
  fill(0);
  textSize(42);
  text("Kemi Værktøj", width / 2, 120);

  // Lærer knap
  fill(180, 200, 255);
  rect(width / 2 - 110, 220, 220, 60, 15);

  fill(0);
  textSize(22);
  text("Lærer", width / 2, 250);

  // Ordet eller
  textSize(20);
  text("eller", width / 2, 315);

  // Elev knap
  fill(180, 200, 255);
  rect(width / 2 - 110, 360, 220, 60, 15);

  fill(0);
  textSize(22);
  text("Elev", width / 2, 390);
}

// lærerside prø
void drawTeacherScreen() {
  fill(0);
  textSize(34);
  text("Lærerdel", width / 2, 100);

  textSize(18);
  text("Her skal læreren senere kunne godkende kemikalier.", width / 2, 180);

  drawBackButton();
}

//  elevside prø
void drawStudentScreen() {
  fill(0);
  textSize(34);
  text("Elevdel", width / 2, 100);

  textSize(18);
  text("Her skal elever senere kunne søge efter kemikalier.", width / 2, 180);

  drawBackButton();
}

//  tilbageknap
void drawBackButton() {
  fill(0);
  triangle(30, height - 45, 55, height - 60, 55, height - 30);

  textAlign(LEFT, CENTER);
  textSize(14);
  text("Tilbage", 65, height - 45);

  textAlign(CENTER, CENTER);
}

void mousePressed() {
  if (screen == 0) {
    // Klik på Lærer
    if (mouseX > width / 2 - 110 && mouseX < width / 2 + 110 &&
        mouseY > 220 && mouseY < 280) {
      screen = 1;
    }

    // Klik på Elev
    if (mouseX > width / 2 - 110 && mouseX < width / 2 + 110 &&
        mouseY > 360 && mouseY < 420) {
      screen = 2;
    }
  }

  // Tilbageknap på lærer/elev-siderne
  if (screen == 1 || screen == 2) {
    if (mouseX > 20 && mouseX < 120 &&
        mouseY > height - 70 && mouseY < height - 20) {
      screen = 0;
    }
  }
}
