import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import de.bezier.guido.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Minesweeper extends PApplet {



public final static int NUM_ROWS = 20; public final static int NUM_COLS = 20;
private MSButton[][] buttons = new MSButton[20][20]; //2d array of minesweeper buttons
ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

public void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    

    //declare and initialize buttons
    
    for (int i = 0; i < NUM_ROWS; i ++) {
        for (int j = 0; j < NUM_COLS; j ++) {
            buttons[i][j] = new MSButton(i, j);
        }
    }
    
    setBombs();
    
}
public void setBombs()
{
    int i = 0;
    while (i < 30) {
        int x = ((int)(Math.random()*20));
        int y = ((int)(Math.random()*20));
        if (!(bombs.contains(buttons[x][y]))) {
            bombs.add(buttons[x][y]);
            i ++;
        }
    }
    bombs.add(buttons[1][1]);
    
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
    

    System.out.println(isWon());
}
public boolean isWon()
{
    boolean wonYet = false;
    if (buttons[0][0].isClicked()) {return true;}
    for (int i = 0; i < NUM_ROWS; i ++) {
        for (int j = 0; j < NUM_COLS; j ++) {
            if (!buttons[i][j].isMarked() && !buttons[i][j].isClicked()) {
                return false;
            }
        }
        
    }
    return true;
    //your code here
    
    
}
public void displayLosingMessage()
{
    //your code here
}
public void displayWinningMessage()
{
    //your code here
    fill(0);
    rect(0, 0, 400, 400);
    text("You win!", 50, 100);

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
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if (mouseButton == RIGHT) {
            marked = !marked;
        } else if (bombs.contains(this)) {
            System.out.println("You Lost.");
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
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        //your code here

        if (r < NUM_ROWS && c < NUM_COLS && r >= 0 && c >= 0) {
            return true;
        }
        return false;
    }
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



  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Minesweeper" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
