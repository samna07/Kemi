

int screen = 4;
// 0 = startside
// 1 = lærerside
// 2 = elevside
// 3 = godkend kemikalier
// 4 = manuel tilføjelse
// 5 = skabe

int maxChemicals = 50;
int totalChemicals = 0;

String[] chemName = new String[maxChemicals];
String[] chemFormula = new String[maxChemicals];
String[] chemMolmasse = new String[maxChemicals];
String[] chemCategory = new String[maxChemicals];
String[] chemState = new String[maxChemicals];
String[] chemLocation = new String[maxChemicals];
String[] chemDescription = new String[maxChemicals];
String[] chemLink = new String[maxChemicals];
String[] chemNotes = new String[maxChemicals];
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
String manualState = "";
String manualLocation = "";
String manualLink = "";
String manualNotes = "";

String message = "";

//tekstfelt
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
//----indtast----------------------------------------------

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
     if (chemApproved[i]&& matchesSearch(i, searchStudent)) {
     if (found >= skip && shown < chemicalsPerPage) {
     int x = 70;
     int y = 165 + shown * 85;

          if (mouseOver(x + 580, y + 20, 150, 30)) {
            link(chemLink[i]);
          }

          shown++;
        }

        found++;
      }
    }

    int totalFound = countSearchResults(searchApprove, true);
    checkPageButtons(totalFound, 2);
  }

  else if (screen == 3) {
    if (backClicked()) {
      screen = 1;
    }
    
    if (mouseOver(130, 75, 350, 40)) {
      activeField = 100;
  }
  
      int shown = 0;
    int found = 0;
    int skip = approvePage * chemicalsPerPage;

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

  else if (screen == 4) {
    if (backClicked()) {
      screen = 1;
    }

    if (mouseOver(250, 98, 420, 32)) activeField = 1;
    if (mouseOver(250, 138, 420, 32)) activeField = 2;
    if (mouseOver(250, 178, 420, 32)) activeField = 3;
    if (mouseOver(250, 218, 420, 32)) activeField = 4;
    if (mouseOver(250, 258, 420, 32)) activeField = 5;
    if (mouseOver(250, 298, 420, 32)) activeField = 6;
    if (mouseOver(250, 338, 420, 32)) activeField = 7;
    if (mouseOver(250, 378, 420, 32)) activeField = 8;
    if (mouseOver(250, 418, 420, 32)) activeField = 9;

    if (mouseOver(250, 500, 250, 50)) {
      saveManualChemical();
    }
  }

  else if (screen == 5) {
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
  text("Kategori: " + chemCategory[i], x + 170, y + 42);
  text("Tilstand: " + chemState[i], x + 360, y + 42);
  
  drawSmallButton(x + 580, y + 20, 150, 30, "Sikkerhedsdatablad");
  
  textAlign(CENTER, CENTER);
}


// Godkend kemikalie
// ======================================================

void drawApproveScreen() {
  fill(0);
  textSize(34);
  text("Godkend kemikalier", width / 2, 45);

  fill(0);
  textAlign(LEFT, CENTER);
  textSize(16);
  text("Søg:", 80, 95);
  
  drawInputBox(130, 75, 350, 40, searchApprove, "Skriv kemikaliets navn", 100);
  
  textSize(15);
  fill(70);
  text("Sæt flueben ved de kemikalier, der findes på skolen.", 80,130); 
  
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
  drawBackButton();  
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
  text("Kategori: " + chemCategory[i], x + 170, y + 42);
  text("Tilstand: " + chemState[i], x + 360, y + 42);
  
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
  addChemical("Saltsyre", "36.46 g/mol", "HCl", "Syre", "Væske", "","Syre-base, pH, titrering",
    "https://app.ecoonline.com//documents/msds/1014950/28142883_286_a75e1c80e9bcecc4986832c615479bb0.pdf",
     "Syre-base, pH, titrering", false);

  addChemical("Natriumhydroxid","40 g/mol", "NaOH", "Base", "Væske", "", "Titrering, pH, neutralisation",
    "https://media.frederiksen-scientific.com/documents/25673778_286_517396d3fbd504f10a4b07b098e8f89d.pdf",
    "Titrering, pH, neutralisation", false);

  addChemical("Ethansyre",  "60.05 g/mol", "CH3COOH", "Svag Syre", "Væske", "", "Syrer, pH, eddikesyre",
    "https://media.frederiksen-scientific.com/documents/23709882_286_729ba15a5db5791b74f8363a221e0ae6.pdf",
    "Syrer, pH, eddikesyre", false);

  addChemical("Ammoniakvand","17.03 g/mol", "NH3", "Base", "Væske", "", "Svage baser, ligevægt",
    "https://media.frederiksen-scientific.com/documents/23709144_286_90d05ef88e885f905f520e6d0ad12f38.pdf",
    "Svage baser, ligevægt", false);

  addChemical("Natriumchlorid","58.44 g/mol", "NaCl", "Salt", "Fast stof", "","Ioner, opløsninger, ledningsevne",
    "https://media.frederiksen-scientific.com/documents/24468866_286_fbaaa325691679abf8abf8fcec5d54e4.pdf", 
    "Ioner, opløsninger, ledningsevne", false);

  addChemical("Kobbersulfat", "249.68 g/mol", "CuSO4*5H2O", "Salt", "Væske", "", "Ioner, farvereaktioner, redox",
    "https://media.frederiksen-scientific.com/documents/24563838_286_a3b9d27bbdf5418689b03109439d953f.pdf",
    "Ioner, farvereaktioner, redox", false);

  addChemical("Sølvnitrat","169.87 g/mol", "AgNO3", "Salt", "Væske", "", "Påvisning af chloridioner",
    "https://media.frederiksen-scientific.com/documents/25364356_286_d50d143e9c85f7881a8da2ca42052dc3.pdf",
    "Påvisning af chloridioner", false);

  addChemical("Natriumcarbonat","105.99 g/mol", "Na2CO3", "Base", "Fast stof", "", "Syre-base, carbonatreaktioner",
    "https://media.frederiksen-scientific.com/documents/24722646_286_8152d212e9a2f2e10f3bde8721f2e9b5.pdf",
    "Syre-base, carbonatreaktioner", false);

  addChemical("Natriumhydrogencarbonat", "84.01 g/mol", "NaHCO3", "Base", "Fast stof", "","CO2-dannelse, syrereaktioner",
    "https://media.frederiksen-scientific.com/documents/24722646_286_8152d212e9a2f2e10f3bde8721f2e9b5.pdf",
    "CO2-dannelse, syrereaktioner", false);

  addChemical("Kaliumpermanganat","158.04 g/mol", "KMnO4", "Oxidationsmiddel", "Væske", "", "Redoxforsøg",
    "https://www.frederiksen-scientific.dk/",
    "Redoxforsøg", false);

  addChemical("Kaliumiodid",  "166.00 g/mol", "KI", "Salt", "Væske", "", "Redox, iodreaktioner",
    "https://media.frederiksen-scientific.com/documents/24240288_286_b5a300a8f9a71b93ca35cb0ff77e030f.pdf",
    "Redox, iodreaktioner", false);

  addChemical("Jodopløsning",  "253.81 g/mol", "I2", "Reagens", "Væske", "", "Stivelsestest, redox",
    "https://media.frederiksen-scientific.com/documents/24909491_286_b24bb79f6fb292c2458f0d4da3df21f1.pdf",
    "Stivelsestest, redox", false);

  addChemical("Ethanol", "46.07 g/mol", "C2H5OH", "Organisk stof", "Væske", "", "Alkoholer, forbrænding, opløselighed",
    "https://media.frederiksen-scientific.com/documents/23435890_286_fe1aed637df262b2a08f40fae0c46c1d.pdf",
    "Alkoholer, forbrænding, opløselighed", false);

  addChemical("Acetone", "58.08 g/mol", "(CH3)2CO", "Organisk stof", "Væske", "","Opløsningsmiddel, organiske stoffer",
    "https://media.frederiksen-scientific.com/documents/23409280_286_0bec3da39adbeda8cd7b70c494d4b812.pdf",
    "Opløsningsmiddel, organiske stoffer", false);

  addChemical("Hydrogenperoxid", "34.01 g/mol", "H2O2", "Oxidationsmiddel", "Væske", "", "Reaktionshastighed, katalyse, redox",
    "https://media.frederiksen-scientific.com/documents/24207584_286_642f1788913feab99c544588b2f99004.pdf",
    "Reaktionshastighed, katalyse, redox", false);
}

void addChemical(String name, String molmasse, String formula, String category, String state, String location, String description, String linkText,String notes, boolean approved) {
  if (totalChemicals >= maxChemicals) {
    return;
  }
  chemName[totalChemicals] = name;
  chemMolmasse[totalChemicals] = molmasse;
  chemFormula[totalChemicals] = formula;
  chemCategory[totalChemicals] = category;
  chemState[totalChemicals] = state;
  chemLocation[totalChemicals] = location;
  chemDescription[totalChemicals] = description;
  chemLink[totalChemicals] = linkText;
  chemNotes[totalChemicals] = notes;
  chemApproved[totalChemicals] = approved;

  totalChemicals++;
}
void saveManualChemical() {
  if (trim(manualName).length() == 0) {
    message = "Du skal skrive et navn.";
    return;
  }
  String molmasse = manualMolmasse;
  if (trim(molmasse).length() == 0) {
    molmasse = "Ikke angivet";
  }
  
  String formula = manualFormula;
  if (trim(formula).length() == 0) {
    formula = "Ikke angivet";
  }

  String category = manualCategory;
  if (trim(category).length() == 0) {
    category = "Andet";
  }
  
  String state = manualState;
  if (trim(state).length() == 0) {
    state = "Ikke angivet";
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
   addChemical(
    manualName,
    molmasse,
    formula,
    category,
    state,
    manualLocation,
    description,
    linkText,
    manualNotes,
    true
  );
  
 message = manualName + " er tilføjet og godkendt.";

  manualName = "";
  manualMolmasse = "";
  manualFormula = "";
  manualCategory = "";
  manualState = "";
  manualLocation = "";
  manualDescription = "";
  manualLink = "";
  manualNotes = "";
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
  if (activeField == 100) return searchApprove;
  if (activeField == 101) return searchStudent;
  
  if (activeField == 1) return manualName;
  if (activeField == 2) return manualMolmasse;
  if (activeField == 3) return manualFormula;
  if (activeField == 4) return manualCategory;
  if (activeField == 5) return manualState;
  if (activeField == 6) return manualLocation;
  if (activeField == 7) return manualDescription;
  if (activeField == 8) return manualLink;
  if (activeField == 9) return manualNotes;
  
  return "";
}

void setActiveText(String t) {
  if (activeField == 100) searchApprove = t;
  if (activeField == 101) searchStudent = t;
  
  if (activeField == 1) manualName = t;
  if (activeField == 2) manualMolmasse = t;
  if (activeField == 3) manualFormula = t;
  if (activeField == 4) manualCategory = t;
  if (activeField == 5) manualState = t;
  if (activeField == 6) manualLocation = t;
  if (activeField == 7) manualDescription = t;
  if (activeField == 8) manualLink = t;
  if (activeField == 9) manualNotes = t;  
}


// Manuel tilføjelse
// ======================================================

void drawManualScreen() {
  fill(0);
  textSize(34);
  text("Manuel tilføjelse", width / 2, 40);

  fill(0);
  textAlign(LEFT, CENTER);
  textSize(15);
  text("Her kan du tilføje et kemikalie, hvis det ikke findes i databasen.", 70, 75);

  drawLabel("Navn:", 70, 115);
  drawInputBox(250, 98, 420, 32, manualName, "fx Saltsyre", 1);
  
  drawLabel("Molmasse:", 70, 155);
  drawInputBox(250, 138, 420, 32, manualMolmasse, "fx 36.46 g/mol", 2);

  drawLabel("Formel:", 70, 195);
  drawInputBox(250, 178, 420, 32, manualFormula, "fx HCl", 3);

  drawLabel("Kategori:", 70, 235);
  drawInputBox(250, 218, 420, 32, manualCategory, "fx Syre, Base eller Salt", 4);
  
  drawLabel("Tilstand:", 70, 275);
  drawInputBox(250, 258, 420, 32, manualState, "fx Væske eller Fast stof", 5);

  drawLabel("Placering:", 70, 315);
  drawInputBox(250, 298, 420, 32, manualLocation, "frivillig", 6);
  
  drawLabel("Beskrivelse:", 70, 355);
  drawInputBox(250, 338, 420, 32, manualDescription, "kort beskrivelse", 7);

  drawLabel("Sikkerhedsdatablad:", 70, 395);
  drawInputBox(250, 378, 420, 32, manualLink, "link til hjemmeside", 8);
  
  drawLabel("Noter:", 70, 435);
  drawInputBox(250, 418, 420, 32, manualNotes, "eventuelle noter", 9);

  drawButton(250, 500, 250, 50, "Tilføj kemikalie");

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
