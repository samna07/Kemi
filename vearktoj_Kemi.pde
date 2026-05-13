

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

/*    DATABASEN/////////
  I want to replace the database you have created for the program with this data: 

Navn: Saltsyre
Molmasse: 36.46 g/mol
Formel:HCl
Kategori: Syre
Tilstand: Væske
Sikkerhedsdatablad:https://app.ecoonline.com//documents/msds/1014950/28142883_286_a75e1c80e9bcecc4986832c615479bb0.pdf 
Note: Syre-base, pH, titrering

--------------------------------

Navn: Natriumhydroxid
Molmasse: 40 g/mol
Formel:NaOH
Kategori: Base
Tilstand: Væske
Sikkerhedsdatablad: https://media.frederiksen-scientific.com/documents/25673778_286_517396d3fbd504f10a4b07b098e8f89d.pdf
Note: Titrering, pH, neutralisation


--------------------------------

Navn: Ethansyre
Molmasse: 60.05 g/mol
Formel:CH3COOH
Kategori: Svag Syre
Tilstand: Væske
Sikkerhedsdatablad: https://media.frederiksen-scientific.com/documents/23709882_286_729ba15a5db5791b74f8363a221e0ae6.pdf
Note: Syrer, pH, eddikesyre

--------------------------------

Navn: Ammoniakvand
Molmasse: 17.03 g/mol
Formel:NH3
Kategori: Base
Tilstand: Væske
Sikkerhedsdatablad: https://media.frederiksen-scientific.com/documents/23709144_286_90d05ef88e885f905f520e6d0ad12f38.pdf
Note: Svage baser, ligevægt


--------------------------------

Navn: Natriumchlorid
Molmasse: 58.44 g/mol
Formel:NaCl
Kategori: Salt
Tilstand: Fast stof
Sikkerhedsdatablad: https://media.frederiksen-scientific.com/documents/24468866_286_fbaaa325691679abf8abf8fcec5d54e4.pdf
Note: Ioner, opløsninger, ledningsevne
--------------------------------

Navn: Kobbersulfat
Molmasse: 249.68 g/mol
Formel:CuSO4·5H2O
Kategori: Salt
Tilstand: Væske
Sikkerhedsdatablad: https://media.frederiksen-scientific.com/documents/24563838_286_a3b9d27bbdf5418689b03109439d953f.pdf
Note: Ioner, farvereaktioner, redox

--------------------------------

Navn: Sølvnitrat
Molmasse: 169.87 g/mol
Formel:AgNO3
Kategori: Salt
Tilstand: Væske
Sikkerhedsdatablad:https://media.frederiksen-scientific.com/documents/25364356_286_d50d143e9c85f7881a8da2ca42052dc3.pdf
Note: Påvisning af chloridioner

--------------------------------

Navn: Natriumcarbonat
Molmasse: 105.99 g/mol
Formel:Na2CO3
Kategori: Base
Tilstand: Fast stof
Sikkerhedsdatablad: https://media.frederiksen-scientific.com/documents/24722646_286_8152d212e9a2f2e10f3bde8721f2e9b5.pdf
Note: Syre-base, carbonatreaktioner

--------------------------------


Navn: Natriumhydrogencarbonat
Molmasse: 84.01 g/mol
Formel:NaHCO3
Kategori: Base
Tilstand: Fast stof
Sikkerhedsdatablad: https://media.frederiksen-scientific.com/documents/24722646_286_8152d212e9a2f2e10f3bde8721f2e9b5.pdf
Note: CO₂-dannelse, syrereaktioner

--------------------------------

Navn: Kaliumpermanganat
Molmasse: 1 M
Formel:HCl
Kategori: Oxidationsmiddel
Tilstand: Væske
Sikkerhedsdatablad: 
Note: Redoxforsøg


--------------------------------


Navn: Kaliumiodid
Molmasse: 158.04 g/mol
Formel:KMnO4
Kategori: Salt
Tilstand: Væske
Sikkerhedsdatablad: https://media.frederiksen-scientific.com/documents/24240288_286_b5a300a8f9a71b93ca35cb0ff77e030f.pdf
Note: Redox, iodreaktioner
--------------------------------

Navn: Jodopløsning
Molmasse: 58.04 g/mol
Formel:I2
Kategori: Reagens
Tilstand: Væske
Sikkerhedsdatablad: https://media.frederiksen-scientific.com/documents/24909491_286_b24bb79f6fb292c2458f0d4da3df21f1.pdf
Note: Stivelsestest, redox

--------------------------------


Navn: Ethanol
Molmasse: 46.07 g/mol
Formel:C2H5OH
Kategori: Organisk stof
Tilstand: Væske
Sikkerhedsdatablad: https://media.frederiksen-scientific.com/documents/23435890_286_fe1aed637df262b2a08f40fae0c46c1d.pdf
Note: Alkoholer, forbrænding, opløselighed

--------------------------------

Navn: Acetone
Molmasse:58.08 g/mol
Formel:(CH3)2CO
Kategori: Organisk stof
Tilstand: Væske
Sikkerhedsdatablad: https://media.frederiksen-scientific.com/documents/23409280_286_0bec3da39adbeda8cd7b70c494d4b812.pdf
Note: Opløsningsmiddel, organiske stoffer


--------------------------------

Navn: Hydrogenperoxid
Molmasse: 34.01 g/mol
Formel:H2O2
Kategori: Oxidationsmiddel
Tilstand: Væske
Sikkerhedsdatablad: https://media.frederiksen-scientific.com/documents/24207584_286_642f1788913feab99c544588b2f99004.pdf
Note: Reaktionshastighed, katalyse, redox

*/

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
