import java.io.File;

int screen = 0;
// 0 = startside
// 1 = lærerside
// 2 = godkend kemikalier
// 3 = manuel tilføjelse
// 4 = skabe
// 5 = elevside
// 6 = indhold i skab
// 7 = detaljer

int maxChemicals = 100;
int totalChemicals = 0;

int previousScreen = 0;


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


// -1 betyder ikke placeret i et skab
int[] chemCabinet = new int[maxChemicals];


//sider
int approvePage = 0;
int studentPage = 0;
int cabinetListPage = 0;
int chemicalsPerPage = 5; //**

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

PImage manualChosenImage = null;
String manualChosenImageName = "Intet billede valgt";

String message = "";

// Skab
int numberOfCabinets = 3;
int selectedCabinet = -1;
int selectedChemicalForCabinet = -1;
int selectedChemicalDetails = -1;

PImage[] chemImage = new PImage[maxChemicals];


int cabinetPage = 0;
int cabinetsPerPage = 6;

//tekstfelt
int activeField = -1;

void setup() {
  size(900, 700);
  textAlign(CENTER, CENTER);
  textFont(createFont("Arial", 16));

  addStartChemicals();
}

void draw() {
  background(220, 230, 245);

  if (screen == 0) {
    drawStartScreen();
  } else if (screen == 1) {
    drawTeacherScreen();
  } else if (screen == 2) {
    drawApproveScreen();
  } else if (screen == 3) {
    drawManualScreen();
  } else if (screen == 4) {
    drawCabinetScreen();
  } else if (screen == 5) {
    drawStudentScreen();
  } else if (screen == 6) {
    drawCabinetContentScreen();
  } else if (screen == 7) {
    drawDetailsScreen();
    
  }
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
void drawTeacherScreen() {
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

String getCabinetText(int i) {
  if (chemCabinet[i] == -1) {
    return "Ikke placeret endnu";
  } else {
    return "Skab " + (chemCabinet[i] + 1);
  }
}

String getLocationText(int i) {
  if (trim(chemLocation[i]).length() == 0) {
    return "Ikke angivet";
  } else {
    return chemLocation[i];
  }
}

String safeText(String value) {
  if (value == null) {
    return "";
  }
  return value;
}

String getNotesText(int i) {
  if (trim(chemNotes[i]).length() == 0) {
    return "Ingen noter";
  } else {
    return chemNotes[i];
  }
}

void drawPageButtons(int page) {
  drawSmallButton(300, 625, 100, 35, "Forrige");
  drawSmallButton(500, 625, 100, 35, "Næste");
  
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(14);
  text("Side " + (page + 1), 450, 642);
}

void checkPageButtons(int totalItems, int whichScreen) {
  if (mouseOver(300, 625, 100, 35)) {
    if (whichScreen == 2 && approvePage > 0) approvePage--;
    if (whichScreen == 5 && studentPage > 0) studentPage--;
    }
  

  if (mouseOver(500, 625, 100, 35)) {
    if (whichScreen == 2) {
      if ((approvePage + 1) * chemicalsPerPage < totalItems) approvePage++;
      }

    if (whichScreen == 5) {
      if ((studentPage + 1) * chemicalsPerPage < totalItems) studentPage++;
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
  if (activeField == 100) approvePage = 0;
  if (activeField == 101) studentPage = 0;
  }


//ved Tryk/ navigeere
//===============================================================
void mousePressed() {
   activeField = -1;
  if (screen == 0) {
    // Lærer-knap
    if (mouseOver(width / 2 - 110, 220, 220, 60)) {
      screen = 1;
    }
    if (mouseOver(width / 2 - 110, 360, 220, 60)) {
      screen = 5;
    }

  } else if (screen == 1) {
    // Tilbage til startside
    if (backClicked()) {
      screen = 0;
      return;
    }
  
    
    if (mouseOver(width / 2 - 160, 190, 320, 60)) {
      screen = 2;
    }
    // Godkend kemikalier
    if (mouseOver(width / 2 - 160, 280, 320, 60)) {
      screen = 3;
    }

    // Manuel tilføjelse
    if (mouseOver(width / 2 - 160, 370, 320, 60)) {
      screen = 4;
    }
  }
    else if (screen == 2) {
    if (backClicked()) {
      screen = 1;
      return;
    }
    
    if (mouseOver(130, 75, 350, 40)) {
      activeField = 100;
  }
  
   checkApproveScreenClick();

    int found = countSearchResults(searchApprove, false);
    checkPageButtons(found, 2);
  
    }
    
   else if (screen == 3) {
    if (backClicked()) {
      screen = 1;
      return;
    }

    checkManualFieldsClick();

    if (mouseOver(250, 452, 160, 35)) {
      selectInput("Vælg et billede:", "fileSelected");
    }

    if (mouseOver(250, 500, 250, 50)) {
      saveManualChemical();
    }
  } else if (screen == 4) {
    if (backClicked()) {
      screen = 1;
      return;
    }

    checkCabinetScreenClick();
  } else if (screen == 5) {
    if (backClicked()) {
      screen = 0;
      return;
    }

    if (mouseOver(130, 75, 350, 40)) {
      activeField = 101;
    }

    checkStudentScreenClick();

    int found = countSearchResults(searchStudent, true);
    checkPageButtons(found, 5);
  } else if (screen == 6) {
    if (backClicked()) {
      screen = 4;
      return;
    }

    checkCabinetContentClick();
  } else if (screen == 7) {
    if (backClicked()) {
      screen = previousScreen;
      return;
    }

    if (mouseOver(280, 530, 250, 45)) {
      if (chemLink[selectedChemicalDetails].length() > 0) {
        link(chemLink[selectedChemicalDetails]);
      }
    }
  }
}
void checkApproveScreenClick() {
    int shown = 0;
    int found = 0;
    int skip = approvePage * 5;

    for (int i = 0; i < totalChemicals; i++) {
      if (matchesSearch(i, searchApprove)) {
        if (found >= skip && shown < 5) {
          int x = 60;
          int y = 165 + shown * 90;

          if (mouseOver(x + 535, y + 22, 150, 30)) {
            if (chemLink[i].length() > 0) {
            link(chemLink[i]);
          }
        }
          if (mouseOver(x + 710, y + 22, 28, 28)) {
            chemApproved[i] = !chemApproved[i];
          }
           shown++;
        }
           found++;
      }
    }
  }
  
void checkStudentScreenClick() {
  int shown = 0;
  int found = 0;
  int skip = studentPage * 5;

  for (int i = 0; i < totalChemicals; i++) {
    if (chemApproved[i] && matchesSearch(i, searchStudent)) {
      if (found >= skip && shown < 5) {
        int x = 60;
        int y = 165 + shown * 85;

        if (mouseOver(x + 620, y + 22, 150, 30)) {
          if (chemLink[i].length() > 0) {
            link(chemLink[i]);
          }
        } else if (mouseOver(x, y, 780, 75)) {
          selectedChemicalDetails = i;
          previousScreen = 5;
          screen = 7;
        }

        shown++;
      }
      found++;
    }
  }
}

void checkManualFieldsClick() {
    if (mouseOver(250, 88, 420, 32)) activeField = 1;
    if (mouseOver(250, 128, 420, 32)) activeField = 2;
    if (mouseOver(250, 168, 420, 32)) activeField = 3;
    if (mouseOver(250, 208, 420, 32)) activeField = 4;
    if (mouseOver(250, 248, 420, 32)) activeField = 5;
    if (mouseOver(250, 288, 420, 32)) activeField = 6;
    if (mouseOver(250, 328, 420, 32)) activeField = 7;
    if (mouseOver(250, 368, 420, 32)) activeField = 8;
    if (mouseOver(250, 408, 420, 32)) activeField = 9;
  }

    
void checkCabinetScreenClick() {
    // minus-knap
    if (mouseOver(60, 160, 40, 30)) {
      if (numberOfCabinets > 1) {
        numberOfCabinets--;
      for (int i = 0; i < totalChemicals; i++) {
        if (chemCabinet[i] >= numberOfCabinets) {
          chemCabinet[i] = -1;
        }
      }

      if (cabinetPage * cabinetsPerPage >= numberOfCabinets) {
        cabinetPage--;
      }

      if (cabinetPage < 0) {
        cabinetPage = 0;
      }
    }
  }

    // plus-knap 
    if (mouseOver(240, 160, 40, 30)) {
      numberOfCabinets++;
      cabinetPage = (numberOfCabinets - 1) / cabinetsPerPage;
    }

    // sideknapper til listen med godkendte kemikalier
    int approvedCount = countApprovedChemicals();

    if (mouseOver(60, 610, 100, 35)) {
      if (cabinetListPage > 0) {
        cabinetListPage--;
      }
    }

    if (mouseOver(175, 610, 100, 35)) {
      if ((cabinetListPage + 1) * 5 < approvedCount) {
        cabinetListPage++;
      }
    }
    
     // Skift side mellem skabene
  if (mouseOver(500, 560, 90, 35)) {
    if (cabinetPage > 0) {
      cabinetPage--;
    }
  }

  if (mouseOver(605, 560, 90, 35)) {
    if ((cabinetPage + 1) * cabinetsPerPage < numberOfCabinets) {
      cabinetPage++;
    }
  }

    // Klik på et godkendt kemikalie
    int shown = 0;
    int found = 0;
    int skip = cabinetListPage * 5;

    for (int i = 0; i < totalChemicals; i++) {
      if (chemApproved[i]) {
        if (found >= skip && shown < 5) {
          int y = 260 + shown * 65;

          if (mouseOver(60, y, 380, 55)) {
            selectedChemicalForCabinet = i;
            message = "Vælg nu et skab";
          }

          shown++;
        }

        found++;
      }
    }

    // Klik på et skab
    int firstCabinet = cabinetPage * cabinetsPerPage;
    int lastCabinet = min(firstCabinet + cabinetsPerPage, numberOfCabinets);
    
    for (int i = firstCabinet; i < lastCabinet; i++) {
      int localNumber = i - firstCabinet;
      
      int x = 500 + (localNumber % 3) * 125;
      int y = 270 + (localNumber / 3) * 145;

      if (mouseOver(x, y, 110, 120)) {
        if (selectedChemicalForCabinet != -1) {
          chemCabinet[selectedChemicalForCabinet] = i;
          message = chemName[selectedChemicalForCabinet] + " er lagt i Skab " + (i + 1);
          selectedChemicalForCabinet = -1;
        } else {
          selectedCabinet = i;
          screen = 6;
        }
      }
    }
  }
  

void checkCabinetContentClick() {
  
  int y = 140;

  for (int i = 0; i < totalChemicals; i++) {
    if (chemApproved[i] && chemCabinet[i] == selectedCabinet) {
      if (mouseOver(70, y, 750, 65)) {
        selectedChemicalDetails = i;
        previousScreen = 6;
        screen = 7;
      }
      y += 80;
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

  fill(70);
  textSize(14);
  text("Du kan kun se kemikalier, som læreren har godkendt.", 80, 130);
  
  int shown = 0;
  int found = 0;
  int skip = studentPage * 5;

  for (int i = 0; i < totalChemicals; i++) {
    if (chemApproved[i] && matchesSearch(i, searchStudent)) {
      if (found >= skip && shown < 5) {
        int y = 165 + shown * 85;
        drawStudentChemicalCard(i, 60, y);
        shown++;
      }

      found++;
    }
  }
  

  if (found == 0) {
    fill(0);
    textAlign(CENTER,CENTER);
    textSize(18);
    text("Ingen godkendte kemikalier fundet", width / 2, 380);
  }
  drawPageButtons(studentPage);
  drawBackButton();
  }

void drawStudentChemicalCard(int i, int x, int y) {
  fill(255);
  stroke(180);
  rect(x, y, 780, 75, 10);

  drawChemicalPicture(i, x + 10, y + 10, 55, 55); 
  
  fill(0);
  textAlign(LEFT, CENTER);
  textSize(16);
  text(chemName[i], x + 80, y + 18);

  textSize(13);
  text("Formel: " + chemFormula[i], x + 80, y + 42);
  text("Kategori: " + chemCategory[i], x + 230, y + 42);
  text("Skab: " + getCabinetText(i), x + 430, y + 42);
  
  drawSmallButton(x + 620, y + 20, 150, 30, "Sikkerhedsdatablad");
  
  fill(70);
  textSize(12);
  text("Klik på kortet for detaljer", x + 80, y + 62);
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
  int skip = approvePage * 5;

  // Viser kemikalierne
  for (int i = 0; i < totalChemicals; i++) {
    if (matchesSearch(i, searchApprove)) {
      if (found >= skip && shown < 5) {
        int y = 165 + shown * 90;
        drawApproveChemicalCard(i, 60, y);
        shown++;
  }
        found++;
    }
  }
  
  if (found == 0) {
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(18);
    text("Ingen kemikalier fundet.", width / 2, 380);
  }
  drawPageButtons(approvePage);
  drawBackButton();  
}


void drawApproveChemicalCard(int i, int x, int y) {
  fill(255);
  stroke(180);
  rect(x, y, 780, 75, 10);

  fill(0);
  textAlign(LEFT, CENTER);
  textSize(18);
  text(chemName[i], x + 80, y + 18);

  textSize(13);
  text("Formel: " + chemFormula[i], x + 80, y + 42);
  text("Kategori: " + chemCategory[i], x + 230, y + 42);
  text("Tilstand: " + chemState[i], x + 420, y + 42);
  
  drawSmallButton(x + 535, y + 22, 150, 30, "Sikkerhedsdatablad");

  // Checkbox
  fill(255);
  stroke(0);
  rect(x + 710, y + 22, 28, 28);

  if (chemApproved[i]) {
    stroke(0, 150, 0);
    strokeWeight(4);
    line(x + 715, y + 36, x + 722, y + 46);
    line(x + 722, y + 46, x + 735, y + 27);
    strokeWeight(1);
  }

  fill(0);
  textAlign(CENTER, CENTER);
  textSize(12);
  text("Godkend", x + 724, y + 62);

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
  
  //så kemika ik stå i et skab inu
  chemCabinet[totalChemicals] = -1;

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


  if (manualChosenImage != null) {
    chemImage[totalChemicals - 1] = manualChosenImage;
  }
  
 message = manualName + " er tilføjet";

  manualName = "";
  manualMolmasse = "";
  manualFormula = "";
  manualCategory = "";
  manualState = "";
  manualLocation = "";
  manualDescription = "";
  manualLink = "";
  manualNotes = "";
  
  manualChosenImage = null;
  manualChosenImageName = "Intet billede valgt";
}  
  


// søgning
// ======================================================

boolean matchesSearch(int i, String searchText) {
  
  String s = safeText(searchText).toLowerCase();
  
  if (s.length() == 0) {
    return true;
  }

  if (chemName[i].toLowerCase().contains(s)) return true;
  if (chemCategory[i].toLowerCase().contains(s))return true;
  if (chemFormula[i].toLowerCase().contains(s))return true;
  return false;
}


//for skab
int countChemicalsInCabinet(int cabinetNumber) {
  int count = 0;

  for (int i = 0; i < totalChemicals; i++) {
    if (chemApproved[i] && chemCabinet[i] == cabinetNumber) {
      count++;
    }
  }

  return count;
}

int countApprovedChemicals() {
  int count = 0;

  for (int i = 0; i < totalChemicals; i++) {
    if (chemApproved[i]) {
      count++;
    }
  }

  return count;
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

// så brugeren vælger et billede
void fileSelected(File selection) {
  if (selection == null) {
    manualChosenImageName = "Intet billede valgt";
  } else {
    manualChosenImage = loadImage(selection.getAbsolutePath());
    manualChosenImageName = selection.getName();

    if (manualChosenImage == null) {
      manualChosenImageName = "Billedet kunne ikke indlæses";
    }
  }
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

  drawLabel("Navn:", 70, 105);
  drawInputBox(250, 88, 420, 32, manualName, "fx Saltsyre", 1);
  
  drawLabel("Molmasse:", 70, 145);
  drawInputBox(250, 128, 420, 32, manualMolmasse, "fx 36.46 g/mol", 2);

  drawLabel("Formel:", 70, 185);
  drawInputBox(250, 168, 420, 32, manualFormula, "fx HCl", 3);

  drawLabel("Kategori:", 70, 225);
  drawInputBox(250, 208, 420, 32, manualCategory, "fx Syre, Base eller Salt", 4);
  
  drawLabel("Tilstand:", 70, 265);
  drawInputBox(250, 248, 420, 32, manualState, "fx Væske eller Fast stof", 5);

  drawLabel("Placering:", 70, 305);
  drawInputBox(250, 288, 420, 32, manualLocation, "frivillig", 6);
  
  drawLabel("Beskrivelse:", 70, 345);
  drawInputBox(250, 328, 420, 32, manualDescription, "kort beskrivelse", 7);

  drawLabel("Sikkerhedsdatablad:", 70, 385);
  drawInputBox(250, 368, 420, 32, manualLink, "link til hjemmeside", 8);
  
  drawLabel("Noter:", 70, 425);
  drawInputBox(250, 408, 420, 32, manualNotes, "eventuelle noter", 9);
  
  drawLabel("Billede:", 70, 470);
  drawSmallButton(250, 452, 160, 35, "Vælg billede");
  
  fill(0);
  textAlign(LEFT, CENTER);
  textSize(13);
  text(manualChosenImageName, 430, 469);

  if (manualChosenImage != null) {
    image(manualChosenImage, 700, 100, 130, 130);
  } else {
    fill(245);
    stroke(0);
    rect(700, 100, 130, 130, 10);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(13);
    text("Intet billede", 765, 165);
  }


  drawButton(250, 500, 250, 50, "Tilføj kemikalie");

  fill(0, 120, 0);
  textAlign(LEFT, CENTER);
  textSize(15);
  text(message, 250, 615);

  drawBackButton();
}

// Skab
// ======================================================

void drawCabinetScreen() {
  fill(0);
  textSize(34);
  text("Skabe", width / 2, 45);

  fill(0);
  textAlign(LEFT, CENTER);
  textSize(15);
  text("1. Klik på et godkendt kemikalie", 60, 85);
  text("2. Klik på et skab for at placere kemikaliet", 60, 110);
  text("Hvis intet kemikalie er valgt, åbner skabet.", 60, 135);
  
   drawSmallButton(60, 160, 40, 30, "-");

  fill(0);
  textAlign(LEFT, CENTER);
  textSize(15);
  text("Antal skabe: " + numberOfCabinets, 115, 175);

  drawSmallButton(240, 160, 40, 30, "+");

  // liste med godkendte kemikalier
  fill(0);
  textSize(20);
  textAlign(LEFT, CENTER);
  text("Godkendte kemikalier", 60, 230);

  int shown = 0;
  int found = 0;
  int skip = cabinetListPage * 5;

  for (int i = 0; i < totalChemicals; i++) {
    if (chemApproved[i]) {
      if (found >= skip && shown < 5) {
        int y = 260 + shown * 65;
        drawCabinetChemicalCard(i, 60, y);
        shown++;
      }

      found++;
    }
  }

  if (found == 0) {
    fill(0);
    textSize(15);
    text("Ingen godkendte kemikalier endnu", 60, 270);
  }

  drawSmallButton(60, 610, 100, 35, "Forrige");
  drawSmallButton(175, 610, 100, 35, "Næste");

  // Skabe på højre side
  fill(0);
  textSize(20);
  textAlign(LEFT, CENTER);
  text("Kemikalieskabe", 500, 230);

  //så den vis kun 6 skabe ad gangen
  int firstCabinet = cabinetPage * cabinetsPerPage;
  int lastCabinet = min(firstCabinet + cabinetsPerPage, numberOfCabinets);
  
  for (int i = firstCabinet; i < lastCabinet; i++) {
    int localNumber = i - firstCabinet;
    
    int x = 500 + (localNumber % 3) * 125;
    int y = 270 + (localNumber / 3) * 145;

    drawCabinet(i, x, y);
  }

  drawSmallButton(500, 560, 90, 35, "Forrige");
  drawSmallButton(605, 560, 90, 35, "Næste");
  
  fill(0);
  textAlign(LEFT, CENTER);
  textSize(13);
  text("Skab-side " + (cabinetPage + 1), 710, 577);
  
  if (selectedChemicalForCabinet != -1) {
    fill(0, 100, 0);
    textSize(14);
    textAlign(LEFT, CENTER);
    text("Valgt: " + chemName[selectedChemicalForCabinet], 500, 625);
  }

  fill(0, 100, 0);
  textSize(14);
  text(message, 500, 650);

  drawBackButton();
}

void drawCabinetChemicalCard(int i, int x, int y) {
  if (selectedChemicalForCabinet == i) {
    fill(210, 255, 210);
  } else {
    fill(255);
  }

  stroke(180);
  rect(x, y, 380, 55, 8);

  drawChemicalPicture(i, x + 8, y + 8, 40, 40);
  
  fill(0);
  textAlign(LEFT, CENTER);
  textSize(14);
  text(chemName[i], x + 60, y + 18);

  textSize(12);
  text(getCabinetText(i), x + 60 , y + 40);
}

void drawCabinet(int i, int x, int y) {
  fill(200, 210, 220);
  stroke(0);
  rect(x, y, 110, 120, 10);

  // to døre
  line(x + 55, y, x + 55, y + 120);

  // håndtag
  fill(0);
  ellipse(x + 48, y + 65, 6, 6);
  ellipse(x + 62, y + 65, 6, 6);

  fill(0);
  textAlign(CENTER, CENTER);
  textSize(15);
  text("Skab " + (i + 1), x + 55, y + 25);

  textSize(12);
  text(countChemicalsInCabinet(i) + " kemikalier", x + 55, y + 100);
}
  
  
 //ind i skane
//// -------------------------------------------
 void drawCabinetContentScreen() {
  fill(0);
  textSize(34);
  text("Indhold i Skab " + (selectedCabinet + 1), width / 2, 55);

  fill(70);
  textAlign(LEFT, CENTER);
  textSize(15);
  text("Klik på et kemikalie for at se flere detaljer.", 70, 90);
  
  int y = 140;
  int found = 0;

  for (int i = 0; i < totalChemicals; i++) {
    if (chemApproved[i] && chemCabinet[i] == selectedCabinet) {
      drawCabinetContentCard(i, 70, y);
      y = y + 80;
      found++;
    }
  }

  if (found == 0) {
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(18);
    text("Dette skab er tomt.", width / 2, 350);
  }

  drawBackButton();
}

void drawCabinetContentCard(int i, int x, int y) {
  fill(255);
  stroke(180);
  rect(x, y, 750, 65, 8);

  drawChemicalPicture(i, x + 10, y + 10, 45, 45);
  
  fill(0);
  textAlign(LEFT, CENTER);
  textSize(16);
  text(chemName[i], x + 70, y + 20);

  textSize(13);
  text("Formel: " + chemFormula[i], x + 70, y + 45);
  text("Kategori: " + chemCategory[i], x + 250, y + 45);
  
  fill(80);
  textSize(12);
  text("Klik for detaljer", x + 570, y + 45);
}

 // mere info 
 ///---------------------------------------
 void drawDetailsScreen() {
  fill(0);
  textSize(34);
  text("Detaljer", width / 2, 55);

  if (selectedChemicalDetails == -1) {
    return;
  }

  int i = selectedChemicalDetails;

  fill(255);
  stroke(180);
  rect(70, 100, 760, 500, 12);
  
  drawChemicalPicture(i, 100, 140, 140, 140);

  fill(0);
  textAlign(LEFT, CENTER);
  textSize(28);
  text(chemName[i], 280, 130);

  textSize(16);
  text("Formel: " + chemFormula[i], 280, 180);
  text("Molmasse: " + chemMolmasse[i], 280, 215);
  text("Kategori: " + chemCategory[i], 280, 250);
  text("Tilstand: " + chemState[i], 280, 285);
  text("Skab: " + getCabinetText(i), 280, 320);
  text("Placering: " + getLocationText(i), 280, 355);

  text("Beskrivelse:", 280, 400);
  text(chemDescription[i], 280, 430, 500, 45);

  text("Noter: " + getNotesText(i), 280, 485);

  drawButton(280, 530, 250, 45, "Åbn sikkerhedsdatablad");

  drawBackButton();
}
 
 
 //tegning///
////-====================================================



void drawChemicalPicture(int i, int x, int y, int w, int h) {
  if (chemImage[i] != null) {
    image(chemImage[i], x, y, w, h);
  } else {
    // Simpelt tegnet demo billede
    fill(245);
    stroke(0);
    rect(x, y, w, h, 8);

    if (chemCategory[i].toLowerCase().contains("syre")) {
      fill(255, 180, 180);
    } else if (chemCategory[i].toLowerCase().contains("base")) {
      fill(180, 210, 255);
    } else if (chemCategory[i].toLowerCase().contains("salt")) {
      fill(210, 240, 210);
    } else {
      fill(235, 225, 255);
    }

    rect(x + w / 3, y + 10, w / 3, h - 20, 5);

    fill(255);
    rect(x + w / 3 + 4, y + h / 2 - 10, w / 3 - 8, 20);

    fill(0);
    textAlign(CENTER, CENTER);
    textSize(10);

    String shortName = chemFormula[i];

    if (shortName.length() > 6) {
      shortName = shortName.substring(0, 6);
    }

    text(shortName, x + w / 2, y + h / 2);
  }
}
