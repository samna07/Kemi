

int screen = 2;
// 0 = startside
// 1 = lærerside
// 2 = elevside
// 3 = godkend kemikalier
// 4 = manuel tilføjelse
// 5 = skabe

int maxChemicals = 40;
int totalChemicals = 0;

String[] chemName = new String[maxChemicals];
String[] chemFormula = new String[maxChemicals];
String[] chemMolmasse = new String[maxChemicals];
String[] chemCategory = new String[maxChemicals];
String[] chemDescription = new String[maxChemicals];
String[] chemLink = new String[maxChemicals];
boolean[] chemApproved = new boolean[maxChemicals];

int approvePage = 0;
int studentPage = 0;
int chemicalsPerPage = 5;

//søge
String searchApprove = "";
String searchStudent = "";


// Manuel tilføjelse
String manualName = "";
String manualFormula = "";
String manualMolmasse = "";
String manualCategory = "";
String manualDescription = "";
String manualLink = "";

String message = "";

int activeField = -1;

void setup() {
  size(900, 700);
  textAlign(CENTER, CENTER);
  textFont(createFont("Arial", 20));

  addStartChemicals();
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

//  knapper og andre funktioner
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
void drawSmallButton(int x, int y, int w, int h, String buttonText) {
  fill(180, 200, 255);
  stroke(0);
  rect(x, y, w, h, 8);

  fill(0);
  textAlign(CENTER, CENTER);
  textSize(12);
  text(buttonText, x + w / 2, y + h / 2);
}

void drawLabel(String label, int x, int y) {
  fill(0);
  textAlign(LEFT, CENTER);
  textSize(15);
  text(label, x, y);
}

void drawBackButton() {
  fill(0);
  triangle(30, height - 45, 55, height - 60, 55, height - 30);

  textAlign(LEFT, CENTER);
  textSize(14);
  text("Tilbage", 65, height - 45);

  textAlign(CENTER, CENTER);
}

boolean backClicked() {
  if (mouseOver(20, height - 70, 120, 50)) {
    return true;
  }

  return false;
}

boolean mouseOver(int x, int y, int w, int h) {
  if (mouseX > x && mouseX < x + w &&
      mouseY > y && mouseY < y + h) {
    return true;
  }

  return false;
}

void drawPageButtons(int page, int totalItems) {
  drawSmallButton(300, 625, 100, 35, "Forrige");
  drawSmallButton(500, 625, 100, 35, "Næste");
  
    fill(0);
  textAlign(CENTER, CENTER);
  textSize(14);
  text("Side " + (page + 1), 450, 642);
}

void checkPageButtons(int totalItems, int whichScreen) {
  if (mouseOver(300, 625, 100, 35)) {
    if (whichScreen == 3 && approvePage > 0) {
      approvePage--;
    }
//her senerer 2og 4
    if (whichScreen == 2 && studentPage > 0) {
      studentPage--;
    }
  }

  if (mouseOver(500, 625, 100, 35)) {
    if (whichScreen == 3) {
      if ((approvePage + 1) * chemicalsPerPage < totalItems) {
        approvePage++;
      }
    }

    if (whichScreen == 2) {
      if ((studentPage + 1) * chemicalsPerPage < totalItems) {
        studentPage++;
      }
    }
  }
}

int countSearchResults(String searchText, boolean onlyApproved) {
  int count = 0;

  for (int i = 0; i < totalChemicals; i++) {
    if (onlyApproved && !chemApproved[i]) {
      continue;
    }

    if (matchesSearch(i, searchText)) {
      count++;
    }
  }

  return count;
}
//--------------------------------------------------

void keyPressed() {
  if (activeField == -1) {
    return;
  }
//gentjek efter elev siden////////
  String currentText = getActiveText();

  if (key == BACKSPACE) {
    if (currentText.length() > 0) {
      currentText = currentText.substring(0, currentText.length() - 1);
    }
  } else if (key == ENTER || key == RETURN) {
    activeField = -1;
  } else if (key != CODED) {
    currentText = currentText + key;
  }

  setActiveText(currentText);

  // Når man søger, starter man fra side 1 igen
  if (activeField == 100) {
    approvePage = 0;
  }

  if (activeField == 101) {
    studentPage = 0;
  }
}

//ved Tryk/ navigeere
//===============================================================
void mousePressed() {
   activeField = -1;
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
    
    if (mouseOver(130, 75, 350, 40)) {
      activeField = 101;
  }
    int shown = 0;
    int found = 0;
    int skip = approvePage * chemicalsPerPage;
    
    
    // Klik på checkbox ved kemikalier
    for (int i = 0; i < totalChemicals; i++) {
     if (matchesSearch(i, searchApprove)) {
     if (found >= skip && shown < chemicalsPerPage) {
     int x = 70;
     int y = 165 + shown * 85;

          if (mouseOver(x + 500, y + 20, 150, 30)) {
            link(chemLink[i]);
          }

          if (mouseOver(x + 690, y + 20, 28, 28)) {
            chemApproved[i] = !chemApproved[i];
          }

          shown++;
        }

        found++;
      }
    }

    int totalFound = countSearchResults(searchApprove, false);
    checkPageButtons(totalFound, 3);
  }

  else if (screen == 4 || screen == 5) {
    if (backClicked()) {
      screen = 1;
    }
  }
}
// elevsiden
// ======================================================

void drawStudentScreen() {
  fill(0);
  textSize(34);
  text("Elev Siden", width / 2, 45);

  fill(0);
  textAlign(LEFT, CENTER);
  textSize(16);
  text("Søg:", 80, 95);
  drawInputBox(130, 75, 350, 40, searchStudent, "Skriv kemikaliets navn", 101);

  int shown = 0;
  int found = 0;
  int skip = studentPage * chemicalsPerPage;

  for (int i = 0; i < totalChemicals; i++) {
    if (chemApproved[i] && matchesSearch(i, searchStudent)) {
      if (found >= skip && shown < chemicalsPerPage) {
        int y = 165 + shown * 85;
        drawStudentChemicalCard(i, 70, y);
        shown++;
      }

      found++;
    }
  }
  

  if (found == 0) {
    fill(0);
    textAlign(CENTER,CENTER);
    textSize(18);
    text("Ingen godkendte kemikalier fundet", width / 2, 360);
  }
  drawPageButtons(studentPage, found);
  drawBackButton();
  }

void drawStudentChemicalCard(int i, int x, int y) {
  fill(255);
  stroke(180);
  rect(x, y, 760, 70, 10);

  fill(0);
  textAlign(LEFT, CENTER);
  textSize(17);
  text(chemName[i], x + 20, y + 18);

  textSize(13);
  text("Formel: " + chemFormula[i], x + 20, y + 42);
  text("Molmasse: " + chemMolmasse[i], x + 160, y + 42);
  text("Kategori: " + chemCategory[i], x + 360, y + 42);

  drawSmallButton(x + 580, y + 20, 150, 30, "Sikkerhedsdatablad");
  
  textAlign(CENTER, CENTER);
}


// Godkend kemikalie
// ======================================================

void drawApproveScreen() {
  fill(0);
  textSize(34);
  text("Godkend kemikalier", width / 2, 60);

  fill(0);
  textAlign(LEFT, CENTER);
  textSize(16);
  text("Søg:", 80, 95);
  
  drawInputBox(130, 75, 350, 40, searchApprove, "Skriv kemikaliets navn", 100);
  
  textSize(15);
  fill(70);
  text("Sæt flueben ved de kemikalier, der findes på skolen.", width / 2, 105); //**redigere placering
  
  int shown = 0;
  int found = 0;
  int skip = approvePage * chemicalsPerPage;

  // Viser kemikalierne
  for (int i = 0; i < totalChemicals; i++) {
    if (matchesSearch(i, searchApprove)) {
      if (found >= skip && shown < chemicalsPerPage) {
        int y = 165 + shown * 85;
    drawChemicalCard(i, 70, y);
    shown++;
  }
    found++;
    }
  }
  
  if (found == 0) {
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(18);
    text("Ingen kemikalier fundet.", width / 2, 360);
  }
  drawPageButtons(approvePage, found);
  drawBackButton();  ///****tilbage knap virker ik fix 
}


void drawChemicalCard(int i, int x, int y) {
  fill(255);
  stroke(180);
  rect(x, y, 760, 70, 10);

  fill(0);
  textAlign(LEFT, CENTER);
  textSize(18);
  text(chemName[i], x + 20, y + 20);

  textSize(13);
  text("Formel: " + chemFormula[i], x + 20, y + 42);
  text("Kategori: " + chemCategory[i], x + 20, y + 45);
  text("Molmasse: " + chemMolmasse[i], x + 330, y + 42);
  
  drawSmallButton(x + 500, y + 20, 150, 30, "Sikkerhedsdatablad");

  // Checkbox
  fill(255);
  stroke(0);
  rect(x + 690, y + 20, 28, 28);

  if (chemApproved[i]) {
    stroke(0, 150, 0);
    strokeWeight(4);
    line(x + 695, y + 34, x + 702, y + 44);
    line(x + 702, y + 44, x + 715, y + 25);
    strokeWeight(1);
  }

  fill(0);
  textAlign(CENTER, CENTER);
  textSize(12);
  text("Godkend", x + 704, y + 60);

  textAlign(CENTER, CENTER);
}

//Data
// ======================================================

void addStartChemicals() {
  addChemical("Saltsyre", "HCl", "36.46 g/mol", "Syre", "Syre-base, pH, titrering",
    "https://app.ecoonline.com//documents/msds/1014950/28142883_286_a75e1c80e9bcecc4986832c615479bb0.pdf");

  addChemical("Natriumhydroxid", "NaOH", "40 g/mol", "Base", "Titrering, pH, neutralisation",
    "https://media.frederiksen-scientific.com/documents/25673778_286_517396d3fbd504f10a4b07b098e8f89d.pdf");

  addChemical("Ethansyre", "CH3COOH", "60.05 g/mol", "Svag Syre", "Syrer, pH, eddikesyre",
    "https://media.frederiksen-scientific.com/documents/23709882_286_729ba15a5db5791b74f8363a221e0ae6.pdf");

  addChemical("Ammoniakvand", "NH3", "17.03 g/mol", "Base", "Svage baser, ligevægt",
    "https://media.frederiksen-scientific.com/documents/23709144_286_90d05ef88e885f905f520e6d0ad12f38.pdf");

  addChemical("Natriumchlorid", "NaCl", "58.44 g/mol", "Salt", "Ioner, opløsninger, ledningsevne",
    "https://media.frederiksen-scientific.com/documents/24468866_286_fbaaa325691679abf8abf8fcec5d54e4.pdf");

  addChemical("Kobbersulfat", "CuSO4*5H2O", "249.68 g/mol", "Salt", "Ioner, farvereaktioner, redox",
    "https://media.frederiksen-scientific.com/documents/24563838_286_a3b9d27bbdf5418689b03109439d953f.pdf");

  addChemical("Sølvnitrat", "AgNO3", "169.87 g/mol", "Salt", "Påvisning af chloridioner",
    "https://media.frederiksen-scientific.com/documents/25364356_286_d50d143e9c85f7881a8da2ca42052dc3.pdf");

  addChemical("Natriumcarbonat", "Na2CO3", "105.99 g/mol", "Base", "Syre-base, carbonatreaktioner",
    "https://media.frederiksen-scientific.com/documents/24722646_286_8152d212e9a2f2e10f3bde8721f2e9b5.pdf");

  addChemical("Natriumhydrogencarbonat", "NaHCO3", "84.01 g/mol", "Base", "CO2-dannelse, syrereaktioner",
    "https://media.frederiksen-scientific.com/documents/24722646_286_8152d212e9a2f2e10f3bde8721f2e9b5.pdf");

  addChemical("Kaliumpermanganat", "KMnO4", "158.04 g/mol", "Oxidationsmiddel", "Redoxforsøg",
    "https://www.frederiksen-scientific.dk/");

  addChemical("Kaliumiodid", "KI", "166.00 g/mol", "Salt", "Redox, iodreaktioner",
    "https://media.frederiksen-scientific.com/documents/24240288_286_b5a300a8f9a71b93ca35cb0ff77e030f.pdf");

  addChemical("Jodopløsning", "I2", "253.81 g/mol", "Reagens", "Stivelsestest, redox",
    "https://media.frederiksen-scientific.com/documents/24909491_286_b24bb79f6fb292c2458f0d4da3df21f1.pdf");

  addChemical("Ethanol", "C2H5OH", "46.07 g/mol", "Organisk stof", "Alkoholer, forbrænding, opløselighed",
    "https://media.frederiksen-scientific.com/documents/23435890_286_fe1aed637df262b2a08f40fae0c46c1d.pdf");

  addChemical("Acetone", "(CH3)2CO", "58.08 g/mol", "Organisk stof", "Opløsningsmiddel, organiske stoffer",
    "https://media.frederiksen-scientific.com/documents/23409280_286_0bec3da39adbeda8cd7b70c494d4b812.pdf");

  addChemical("Hydrogenperoxid", "H2O2", "34.01 g/mol", "Oxidationsmiddel", "Reaktionshastighed, katalyse, redox",
    "https://media.frederiksen-scientific.com/documents/24207584_286_642f1788913feab99c544588b2f99004.pdf");
}

void addChemical(String name, String formula, String molmasse, String category, String description, String linkText) {
  if (totalChemicals >= maxChemicals) {
    return;
  }
  chemName[totalChemicals] = name;
  chemFormula[totalChemicals] = formula;
  chemMolmasse[totalChemicals] = molmasse;
  chemCategory[totalChemicals] = category;
  chemDescription[totalChemicals] = description;
  chemLink[totalChemicals] = linkText;
  chemApproved[totalChemicals] = false;

  totalChemicals++;
}
void saveManualChemical() {
  if (trim(manualName).length() == 0) {
    message = "Du skal skrive et navn.";
    return;
  }

  String formula = manualFormula;
  if (trim(formula).length() == 0) {
    formula = "Ikke angivet";
  }

  String molmasse = manualMolmasse;
  if (trim(molmasse).length() == 0) {
    molmasse = "Ikke angivet";
  }

  String category = manualCategory;
  if (trim(category).length() == 0) {
    category = "Andet";
  }

  String description = manualDescription;
  if (trim(description).length() == 0) {
    description = "Ingen beskrivelse endnu.";
  }

  String linkText = manualLink;
  if (trim(linkText).length() == 0) {
    linkText = "https://www.frederiksen-scientific.dk/";
  }

  if (!linkText.startsWith("http://") && !linkText.startsWith("https://")) {
    linkText = "https://" + linkText;
  }

}
// søgning
// ======================================================

boolean matchesSearch(int i, String searchText) {
  String s = searchText.toLowerCase();

  if (chemName[i].toLowerCase().contains(s)) {
    return true;
  }

  if (chemCategory[i].toLowerCase().contains(s)) {
    return true;
  }

  if (chemFormula[i].toLowerCase().contains(s)) {
    return true;
  }

  return false;
}

//input feltetl

void drawInputBox(int x, int y, int w, int h, String value, String placeholder, int fieldNumber) {
  if (activeField == fieldNumber) {
    fill(255);
    stroke(0, 100, 255);
    strokeWeight(2);
  } else {
    fill(255);
    stroke(120);
    strokeWeight(1);
  }

  rect(x, y, w, h, 5);
  strokeWeight(1);

  textAlign(LEFT, CENTER);
  textSize(14);

  if (value.length() == 0) {
    fill(140);
    text(placeholder, x + 8, y + h / 2);
  } else {
    fill(0);
    text(value, x + 8, y + h / 2);
  }
}

String getActiveText() {
  if (activeField == 100) {
    return searchApprove;
  }

  if (activeField == 101) {
    return searchStudent;
  }

  return "";
}

void setActiveText(String t) {
  if (activeField == 100) {
    searchApprove = t;
  }

  if (activeField == 101) {
    searchStudent = t;
  }
}


// Manuel tilføjelse
// ======================================================

void drawManualScreen() {
  fill(0);
  textSize(34);
  text("Manuel tilføjelse", width / 2, 90);

  fill(0);
  textAlign(LEFT, CENTER);
  textSize(15);
  text("Her kan læreren tilføje et kemikalie, hvis det ikke findes i databasen.", 70, 85);

  drawLabel("Navn:", 70, 135);
  drawInputBox(250, 115, 420, 35, manualName, "fx Saltsyre", 1);

  drawLabel("Formel:", 70, 185);
  drawInputBox(250, 165, 420, 35, manualFormula, "fx HCl", 2);

  drawLabel("Molmasse:", 70, 235);
  drawInputBox(250, 215, 420, 35, manualMolmasse, "fx 36.46 g/mol", 3);

  drawLabel("Kategori:", 70, 285);
  drawInputBox(250, 265, 420, 35, manualCategory, "fx Syre, Base eller Salt", 4);

  drawLabel("Beskrivelse:", 70, 335);
  drawInputBox(250, 315, 420, 35, manualDescription, "kort beskrivelse", 5);

  drawLabel("Sikkerhedsdatablad:", 70, 385);
  drawInputBox(250, 365, 420, 35, manualLink, "link til hjemmeside", 6);

  drawButton(250, 450, 250, 50, "Tilføj kemikalie");

  fill(0, 120, 0);
  textAlign(LEFT, CENTER);
  textSize(15);
  text(message, 250, 535);

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
