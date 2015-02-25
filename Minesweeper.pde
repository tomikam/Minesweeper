
import de.bezier.guido.*;
public final static int NUM_ROWS = 20; public final static int NUM_COLS = 20; public final static int NUM_BOMBS = 45;
private MSButton[][] buttons = new MSButton[20][20]; //2d array of minesweeper buttons
ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
ArrayList <MSButton> craters = new ArrayList <MSButton>();
ArrayList <MSButton> army = new ArrayList <MSButton>();
ArrayList <MSButton> guns = new ArrayList <MSButton>();
boolean gameOver = false;
int clickCounter;


void setup ()
{
    size(400, 450);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    clickCounter = 0;

    //declare and initialize buttons
    
    for (int i = 0; i < NUM_ROWS; i ++) {
        for (int j = 0; j < NUM_COLS; j ++) {
            buttons[i][j] = new MSButton(i, j);
        }
    }
    
    setBombs();
    setGuns();
    army.add(buttons[NUM_ROWS - 1][NUM_COLS - 1]);
   
}
public void setBombs()
{
    int i = 0;
    while (i < NUM_BOMBS) {
        int x = ((int)(Math.random()*19));
        int y = ((int)(Math.random()*19));
        if (!(bombs.contains(buttons[x][y])) && !(army.contains(buttons[x][y]))) {
            bombs.add(buttons[x][y]);
            i ++;
        }
    }

}
public void setGuns()
{
    int i = 0;
    while (i < 3) {
        int x = ((int)(Math.random()*16)); //Could be 19
        int y = ((int)(Math.random()*16));
        if (!(bombs.contains(buttons[x][y])) && !(army.contains(buttons[x][y]))) {
            guns.add(buttons[x][y]);
            i ++;
        }
    }
}
public void draw ()
{
    fill(0);
    rect(0, 0, 400, 400);
    //background( 0 );
    if(isWon())
        displayWinningMessage();
    
    if (!gameOver) {
        fill(200);
        rect(0, 400, 400, 50);
        if (clickCounter % 3 == 1) {
            fill(255, 140, 0);
            rect(10, 410, 120, 30);
        } else if (clickCounter % 3 == 2) {
            fill(255, 140, 0);
            rect(10, 410, 120, 30);
            rect(140, 410, 120, 30);
        } else if (clickCounter % 3 == 0) {
            fill(255, 140, 0);
            rect(10, 410, 120, 30);
            rect(140, 410, 120, 30);
            rect(270, 410, 120, 30);
        }
    } else if (gameOver) {

    }
    
 
}
public void artillery() {
    if (clickCounter % 3 == 0) {
        int x = ((int)(Math.random()*20));
        int y = ((int)(Math.random()*20));
        if (!(craters.contains(buttons[x][y])) && !(guns.contains(buttons[x][y])) && !(buttons[x][y] == army.get(0))) {
            craters.add(buttons[x][y]);
        }
    }      
}
public boolean isWon()
{
    boolean wonYet = false;
    /*for (int i = 0; i < NUM_ROWS; i ++) {
        for (int j = 0; j < NUM_COLS; j ++) {
            if (!buttons[i][j].isMarked() && !buttons[i][j].isClicked()) {
                return false;
            }
        }
        
    }*/

    //if (!gameOver && army.contains(buttons[0][0])) {return true;}
    if (!gameOver && guns.size() == 0) {return true;}
    else {return false;}
    
    
}

public boolean isValid(int r, int c)
    {
        //your code here

        if (r < NUM_ROWS && c < NUM_COLS && r >= 0 && c >= 0) {
            return true;
        }
        return false;
    }

public void displayLosingMessage()
{
    

    /*buttons[10][6].setLabel("Y");
    buttons[10][7].setLabel("O");
    buttons[10][8].setLabel("U");
    buttons[10][9].setLabel("");
    buttons[10][10].setLabel("L");
    buttons[10][11].setLabel("O");
    buttons[10][12].setLabel("S");
    buttons[10][13].setLabel("T");*/

    fill(200);
    rect(0, 400, 400, 50);
    fill(0);
    textSize(40);
    text("YOU LOSE", 200, 420);
    textSize(11);



    for (int i = 0; i < bombs.size(); i ++) {
        bombs.get(i).makeClicked();
    }
    
    gameOver = true;
}
public void displayWinningMessage()
{
    fill(0);
    stroke(0);
    buttons[10][6].setLabel("Y");
    buttons[10][7].setLabel("O");
    buttons[10][8].setLabel("U");
    buttons[10][9].setLabel("");
    buttons[10][10].setLabel("W");
    buttons[10][11].setLabel("O");
    buttons[10][12].setLabel("N");
    buttons[10][13].setLabel("!");
    

}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    public void makeClicked() {
        clicked = true;
    }
    public int getR() {return r;}
    public int getC() {return c;}
    // called by manager
    
    public void mousePressed () 
    {
        if (!gameOver)
            if (mouseButton == LEFT) {clicked = true;}
            if (mouseButton == RIGHT) {
                marked = !marked;
                /*if (!(isMarked())) {marked = true;}
                if (isMarked()) {marked = false; clicked = false;}*/
            } else if (bombs.contains(this)) {
                displayLosingMessage();
            } else if (countBombs(r, c) > 0) {
                label = "" + countBombs(r, c);
            } else {
               
                if (isValid(r - 1, c - 1) && !buttons[r - 1][c - 1].isClicked() ) {buttons[r - 1][c - 1].mousePressed();}
                if (isValid(r - 1, c) && !buttons[r - 1][c].isClicked()) {buttons[r - 1][c].mousePressed();}
                if (isValid(r - 1, c + 1) && !buttons[r - 1][c + 1].isClicked()) {buttons[r - 1][c + 1].mousePressed();}
                if (isValid(r, c - 1) && !buttons[r][c - 1].isClicked()) {buttons[r][c - 1].mousePressed();}
                if (isValid(r, c + 1) && !buttons[r][c + 1].isClicked()) {buttons[r][c + 1].mousePressed();}
                if (isValid(r + 1, c - 1) && !buttons[r + 1][c - 1].isClicked()) {buttons[r + 1][c - 1].mousePressed();}
                if (isValid(r + 1, c) && !buttons[r + 1][c].isClicked()) {buttons[r + 1][c].mousePressed();}
                if (isValid(r + 1, c + 1) && !buttons[r + 1][c + 1].isClicked()) {buttons[r + 1][c + 1].mousePressed();}
            }
    }

    public void draw () 
    {    
        if (army.get(0) == this) {strokeWeight(2);}
        if (!(army.get(0) == this)) {strokeWeight(1);}

        if (guns.contains(this))
            fill(255, 140, 0);
        else if (marked)
            fill(0, 0, 255);
        else if( clicked && bombs.contains(this)) 
            fill(255,0,0);
        else if (craters.contains(this))
            fill(0);
        else if (army.contains(this))
            //
            fill(0, 150, 0);
        else if (clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        if (!(army.contains(this)) && !(craters.contains(this))) {text(label,x+width/2,y+height/2);}
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    /*public boolean isValid(int r, int c)
    {
        //your code here

        if (r < NUM_ROWS && c < NUM_COLS && r >= 0 && c >= 0) {
            return true;
        }
        return false;
    }*/
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        
        if (isValid(row - 1, col - 1) && bombs.contains(buttons[row - 1][col - 1])) {numBombs ++;}
        if (isValid(row - 1, col) && bombs.contains(buttons[row - 1][col])) {numBombs ++;}
        if (isValid(row - 1, col + 1) && bombs.contains(buttons[row - 1][col + 1])) {numBombs ++;}
        if (isValid(row, col - 1) && bombs.contains(buttons[row][col - 1])) {numBombs ++;}
        if (isValid(row, col + 1) && bombs.contains(buttons[row][col + 1])) {numBombs ++;}
        if (isValid(row + 1, col - 1) && bombs.contains(buttons[row + 1][col - 1])) {numBombs ++;}
        if (isValid(row + 1, col) && bombs.contains(buttons[row + 1][col])) {numBombs ++;}
        if (isValid(row + 1, col + 1) && bombs.contains(buttons[row + 1][col + 1])) {numBombs ++;}

        return numBombs;
    }
}

public void keyPressed() {
    clickCounter ++;
    artillery();
    int r = army.get(0).getR();
    int c = army.get(0).getC();

    if (key == 'w') 
        if (isValid(r - 1, c) && !(craters.contains(buttons[r - 1][c]))) {
            if (bombs.contains(buttons[r - 1][c])) {
                displayLosingMessage();
            }
            if (guns.contains(buttons[r - 1][c])) {
                guns.remove(buttons[r - 1][c]);
            }
            army.add(0, buttons[r - 1][c]);
        }
    if (key == 'a') 
        if (isValid(r, c - 1) && !(craters.contains(buttons[r][c - 1]))) {
            if (bombs.contains(buttons[r][c - 1]))
                displayLosingMessage();
            if (guns.contains(buttons[r][c - 1])) {
                guns.remove(buttons[r][c - 1]);
            }
            army.add(0, buttons[r][c - 1]);
        }
    if (key == 's')
        if (isValid(r + 1, c) && !(craters.contains(buttons[r + 1][c]))) {
            if (bombs.contains(buttons[r + 1][c]))
                displayLosingMessage();
            if (guns.contains(buttons[r + 1][c])) {
                guns.remove(buttons[r + 1][c]);
            }
            army.add(0, buttons[r + 1][c]);
        }
    if (key == 'd')
        if (isValid(r, c + 1) && !(craters.contains(buttons[r][c + 1]))) {
            if (bombs.contains(buttons[r][c + 1]))
                displayLosingMessage();
            if (guns.contains(buttons[r][c + 1])) {
                guns.remove(buttons[r][c + 1]);
            }
            army.add(0, buttons[r][c + 1]);
        }
}

public void mouseReleased() {
    if (mouseButton == LEFT) {
        clickCounter ++;
        artillery();
    }
}

//TO DO: when mark-unmark, dsplays bombs...