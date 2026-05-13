

int screen = 0;
// 0 = startside
// 1 = lærerside
// 2 = elevside
// 3 = godkend kemikalier
// 4 = manuel tilføjelse
// 5 = skabe

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
    drawTeacherMenu();
  } else if (screen == 2) {
    drawStudentScreen();
  } else if (screen == 3) {
    drawApproveScreen();
  } else if (screen == 4) {
    drawManualScreen();
  } else if (screen == 5) {
    drawCabinetScreen();
  }
  //se musen for draw (husk x den)
  pushStyle();
  fill(255, 0, 0);
  textSize(16);
  textAlign(LEFT, TOP);
  text("x: " + mouseX + " y: " + mouseY, 10, 10);
  popStyle();
}

// Startside
// ======================================================

void drawStartScreen() {
  fill(0);
  textSize(42);
  text("Kemi Værktøj", width / 2, 120);

  drawButton(width / 2 - 110, 220, 220, 60, "Lærer");

  fill(0);
  textSize(20);
  text("eller", width / 2, 315);

  drawButton(width / 2 - 110, 360, 220, 60, "Elev");

  textSize(15);
  fill(70);
  text("Et simpelt system til at organisere kemiundervisning", width / 2, 180);
}

// lærerside
// ======================================================
void drawTeacherMenu() {
  fill(0);
  textSize(36);
  text("Lærer Siden", width / 2, 90);

  textSize(16);
  text("Hvad ønsker du at gøre", width / 2, 135);

  drawButton(width / 2 - 160, 190, 320, 60, "Godkend kemikalier");
  drawButton(width / 2 - 160, 280, 320, 60, "Manuel tilføjelse");
  drawButton(width / 2 - 160, 370, 320, 60, "Skabe");

  drawBackButton();
}

//  tilbageknap+nomal knap
//====================================================
void drawButton(int x, int y, int w, int h, String buttonText) {
  fill(180, 200, 255);
  stroke(0);
  rect(x, y, w, h, 15);

  fill(0);
  textAlign(CENTER, CENTER);
  textSize(20);
  text(buttonText, x + w / 2, y + h / 2);
}

void drawBackButton() {
  fill(0);
  triangle(30, height - 45, 55, height - 60, 55, height - 30);

  textAlign(LEFT, CENTER);
  textSize(14);
  text("Tilbage", 65, height - 45);

  textAlign(CENTER, CENTER);
}

//ved Tryk/ navigeere
//===============================================================
void mousePressed() {
  if (screen == 0) {
    // Lærer-knap
    if (mouseX > width / 2 - 110 && mouseX < width / 2 + 110 &&
        mouseY > 220 && mouseY < 280) {
      screen = 1;
    }

    // Elev-knap
    if (mouseX > width / 2 - 110 && mouseX < width / 2 + 110 &&
        mouseY > 360 && mouseY < 420) {
      screen = 2;
    }
  }

  else if (screen == 1) {
    // Tilbage til startside
    if (backClicked()) {
      screen = 0;
    }

    // Godkend kemikalier
    if (mouseX > width / 2 - 160 && mouseX < width / 2 + 160 &&
        mouseY > 190 && mouseY < 250) {
      screen = 3;
    }

    // Manuel tilføjelse
    if (mouseX > width / 2 - 160 && mouseX < width / 2 + 160 &&
        mouseY > 280 && mouseY < 340) {
      screen = 4;
    }

    // Skabe
    if (mouseX > width / 2 - 160 && mouseX < width / 2 + 160 &&
        mouseY > 370 && mouseY < 430) {
      screen = 5;
    }
  }

  else if (screen == 2) {
    if (backClicked()) {
      screen = 0;
    }
  }

  else if (screen == 3 || screen == 4 || screen == 5) {
    if (backClicked()) {
      screen = 1;
    }
  }
}

boolean backClicked() {
  if (mouseX > 20 && mouseX < 120 &&
      mouseY > height - 70 && mouseY < height - 20) {
    return true;
  }

  return false;
}

// elevsiden
// ======================================================

void drawStudentScreen() {
  fill(0);
  textSize(36);
  text("Elev Siden", width / 2, 90);

 

  drawBackButton();
}


// Godkend kemikalie
// ======================================================

void drawApproveScreen() {
  fill(0);
  textSize(34);
  text("Godkend kemikalier", width / 2, 90);

  //hent databasen her til

  drawBackButton();
}

// Manuel tilføjelse
// ======================================================

void drawManualScreen() {
  fill(0);
  textSize(34);
  text("Manuel tilføjelse", width / 2, 90);



  drawBackButton();
}

// Skab
// ======================================================

void drawCabinetScreen() {
  fill(0);
  textSize(34);
  text("Skabe", width / 2, 90);


  drawBackButton();
}
