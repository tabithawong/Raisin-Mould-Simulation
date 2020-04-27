//THE VARIABLES BELOW CAN BE CHANGED BY THE USER
//side length of bread (should be no more than 50 for best experience)
int n = 40;
//can turn grid on or off (false means grid and true means no grid)
boolean nogrid = true;
//adjusts the width of the bread crust
float crustwidth = 33;
//number of random raisins
int r = 20;
//the number of mould that grows at the start (should be at least 10 for best experience)
int m = 15;
//chosen mould colour, can be set to blue, pink, green, red, orange, yellow, or rainbow (seizure warning for rainbow but it is VERY fun)
String strmcolour = "rainbow";
color mcolour;
//the starting configuration of raisins, can be changed to "random" or "alternate" (alternate is not very interesting)
String raisinconfig = "random"; 
//use can choose if environmental factors change to produce ideal mould growing condition
boolean factorincrease = true;
//the starting values of humidity, temperature, and light
String light = "bright"; //can be "bright", "normal","dark"
int temp = 0; //in degrees, goes from 0-40
int hum = 1; //in a scale from 1-5


//THE VARIABLES BELOW SHOULD NOT BE CHANGED BY THE USER
//various starting values
int l = 0;
float cellSize;
float padding = 140;
float crustlength = padding-crustwidth;
float seconds;
String lightstart;
int tempstart;
int humstart;
//cell states
int[][] cellsNow = new int[n][n];
int[][] cellsNext = new int[n][n];
//possible mould colours
String[] colours = {"blue","pink","green","red","orange","yellow"};
color[] colourlist = {color(153,204,255),color(255,153,255),color(0,204,102),color(204,0,0), color(255,178,102),color(255,255,153)};
int colindex;
//colour scheme settings
color background;
color crust;
color healthy;
color raisin;

//sets up drawing window and draws the first raisin and mould cells
void setup(){
  size(1000,1000);
  lightstart = light;
  tempstart = temp;
  humstart = hum;
  validtemp();
  validhum();
  cellSize = (width-2*padding)/n;

  if (raisinconfig.equals("alternate")){
    alternatestart();}
  else{
    randomraisin();}
  randommould();}

//draws cells
void draw(){
  float growrate = calculategrowthrate();
  frameRate(growrate);
  seconds = millis()/1000;
  if (factorincrease){
    factorincrease();}
  colourscheme();
  if (nogrid){
    noStroke();}
  background(background);
  fill(crust);
  //creates crust edge around bread
  rect(crustlength,crustlength,(width - 2*crustlength), (height-2*crustlength));
  float y = padding;  
  //defines mould colour based on user's choice
  if (strmcolour.equals("rainbow")){
    colindex = int(random(0,colourlist.length));
    mcolour = colourlist[colindex];}
  else{
    for (int h=0; h<colours.length;h++){
      if (colours[h].equals(strmcolour)){
        mcolour = colourlist[h];}}}
  for(int i=0; i<n; i++) {
    for(int j=0; j<n; j++) {
      float x = padding + j*cellSize;
      //if a cell is healthy
      if (cellsNow[i][j] == 0){
        fill(healthy);}       
      //if a cell is a raisin
      else if (cellsNow[i][j] == 1){
        fill(raisin);}        
      //if a cell is mouldy :(
      else{
        fill(mcolour);}
      rect(x, y, cellSize, cellSize);}
   y += cellSize;}
   computeNextGen();
   overWriteArrays();}

//gradually increases light, temperature, and humidity factors
void factorincrease(){
    //if 8 seconds have passed
    if (seconds > 8){
    //adjusts temperature
    if (0<=tempstart&&tempstart<20){
      temp = 40;}
    //adjusts humidity
    if (humstart == 1){
    hum = 5;}}
  //if 6 seconds have passed
  else if (seconds > 6){
    //adjusts temperature
    if (0<=tempstart&&tempstart<10){
      temp = 30;}
    else if (10<=tempstart&&tempstart<20){
      temp = 40;}
    //adjusts humidty    
    if (humstart == 1){
      hum = 4;}
    else if (humstart == 2){
      hum = 5;}}
  //if 4 seconds have passed
  else if (seconds > 4){
    //adjusts light
    if (lightstart.equals("bright")){
      light = "dark";}
    //adjusts temperature
    if (0<=tempstart&&tempstart<10){
      temp = 20;}
    else if (10<=tempstart&&tempstart<20){
      temp = 30;}
    else if (20<=tempstart&&tempstart<30){
      temp = 40;}
    //adjusts humidity
    if (humstart == 1){
      hum = 3;}
    else if (humstart == 2){
      hum = 4;}
    else if (humstart == 3){
      hum = 5;}}        
  //if 2 seconds have passed
  else if (seconds > 2){
    //adjusts light
    if (lightstart.equals("bright")){
      light = "normal";}
    if (lightstart.equals("normal")){
      light = "dark";}
      //adjusts temperature
    if (0<=tempstart&&tempstart<10){
      temp = 10;}
    else if (10<=tempstart&&tempstart<20){
      temp = 20;}
    else if (20<=tempstart&&tempstart<30){
      temp = 30;}
    //adjusts humidity
    if (humstart == 1){
      hum = 2;}
    else if (humstart == 2){
      hum = 3;}
    else if (humstart == 3){
      hum = 4;}
    else if (humstart == 4){
      hum = 5;}}}

//changes colour scheme based on light setting
void colourscheme(){
  if (lightstart != light){
      if (light.equals("bright")){
    background = color(220,220,220);
    crust = color(222,184,135);
    healthy = color(255,248,220);
    raisin = color(216,191,216);}
  else if (light.equals("normal")){
    background = color(192,192,192);
    crust = color(139,69,19);
    healthy = color(235,223,164);
    raisin = color(114,85,145);}
  else if (light.equals("dark")){
    background = color(105,105,105);
    crust = color(63,42,20);
    healthy = color(172,147,115);
    raisin = color(56,3,65);}}
  else{
    if (light.equals("bright")){
      background = color(220,220,220);
      crust = color(222,184,135);
      healthy = color(255,248,220);
      raisin = color(216,191,216);}
    else if (light.equals("normal")){
      background = color(192,192,192);
      crust = color(139,69,19);
      healthy = color(235,223,164);
      raisin = color(114,85,145);}
    else{
      background = color(105,105,105);
      crust = color(63,42,20);
      healthy = color(172,147,115);
      raisin = color(56,3,65);}}}

//ensures the temperature set by the user is above 0 and below 41
void validtemp(){
  if (temp > 40){
    temp = 40;
    println("chosen temperature is invalid. it is now set at 40");}
  else if (temp < 0){
    temp = 0;
    println("chosen temperature is invalid. it is now set at 0");}}
    
//ensures the humidity set by the user is within the 0-10 parameters
void validhum(){
  if (hum > 5){
    hum = 5;
    println("chosen humidity is invalid. it is now set at 5");}
  else if (hum < 1){
    hum = 1;
    println("chosen humidity is invalid. it is now set at 1");}}

//calculates the rate of growth
float calculategrowthrate(){
  float lightfactor;
  float tempfactor;
  float humfactor;
  //light factor
  if (light.equals("bright")){
    lightfactor = 3;}
  else if (light.equals("normal")){
    lightfactor = 6;}
  else{
    lightfactor = 10;}
  //temperature factor
  if (0<=temp && temp <10){
    tempfactor = 2.5;}
  else if (10<=temp && temp <20){
    tempfactor = 5;}
  else if (20<=temp && temp <30){
    tempfactor = 7.5;}
  else{
    tempfactor = 10;}
  //humidity factor
  if (hum == 1){
    humfactor = 2;}
  else if (hum == 2){
    humfactor = 4;}  
  else if (hum == 3){
    humfactor = 6;}
  else if (hum == 4){
    humfactor = 8;}
  else{
    humfactor = 10;}
  float rate = ((lightfactor+tempfactor+humfactor)/6);
  return rate;}

//computes the values in the cellsNext array
void computeNextGen(){
  for (int i=0; i<n; i++){
    for (int j=0; j<n; j++){
      int rneigh = findnumraisins(i,j);
      int mneigh = findnummould(i,j);
      if (cellsNow[i][j] == 2){
        if (rneigh >= 2){
          cellsNext[i][j] = 0;}
        else{
          cellsNext[i][j] = 2;}}
      else if (cellsNow[i][j] == 1){
          if (rneigh > 2){
            cellsNext[i][j] = 2;}
          else{
            cellsNext[i][j] = 1;}}
      else{
        if (mneigh >= 2){
          cellsNext[i][j] = 2;}
        else{
          cellsNext[i][j] = 0;}}}}}

//overwrites the values in the CellsNow array with the values in the cellsNext array
void overWriteArrays(){
  for (int i=0; i<n;i++){
    for (int j=0;j<n;j++){
      cellsNow[i][j] = cellsNext[i][j];}}}

//counts the number of raisin cells surrounding a cell
int findnumraisins(int i, int j){
  int numraisins = 0;
  for (int a=-1;a<2;a++){
    for (int b=-1;b<2;b++){
      try{
        if ((cellsNow[i+a][j+b] == 1) && !(a==0 && b==0)){
          numraisins++;}}
      catch (Exception e){}}}
  return numraisins;}

//counts the number of mouldy cells surrounding a cell
int findnummould(int i, int j){
  int nummould = 0;
  for (int a=-1; a<2; a++){
    for (int b=-1; b<2; b++){
      try{
        if ((cellsNow[i+a][j+b] == 2) && !(a==0 && b==0)){
          nummould++;}}
      catch (Exception e){}}}
   return nummould;}

//adds raisins randomly to bread
void randomraisin(){
  while (l<r){
    int f = 1;
    int o = round(random(0,n-1));
    int m = round(random(0,n-1));
    cellsNow[o][m] = f;
    l++;}}
    
//adds a single mouldy cell to the bread as long as its place isn't already taken by a raisin
void randommould(){
  for (int k=0; k<m;k++){ 
  int t = 2;
  int p = round(random(0,n-1));
  int q = round(random(0,n-1));
  while (cellsNow[p][q] == 1){
      p = round(random(0,n-1));
      q = round(random(0,n-1));}
  cellsNow[p][q] = t;}}
  
//adds raisins in a checkerboard pattern
void alternatestart(){
  for (int i=0;i<n;i++){
    for (int j=0;j<n;j++){
      if (i%2 == 0 && j%2 != 0){
        cellsNow[i][j] = 1;}
      else if (i%2 != 0 && j%2 == 0){
        cellsNow[i][j] = 1;}}}}
