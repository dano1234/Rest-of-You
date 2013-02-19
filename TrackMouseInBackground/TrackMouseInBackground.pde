import java.awt.*;

public class MouseLocation
{

  private MouseInfo mInfo;
  private PointerInfo pInfo;
  private Point point = new Point();
  private int buttons = 0;
  private double pointX = 0;
  private double pointY = 0;

  private Robot robot;

  public MouseLocation()
  {
    try
    { 
      robot = new Robot();
    }

    catch(Exception e) {
    }

    hasMouse();
    pointerLocation();
  }//ends constr.

  private void hasMouse()
  {
    buttons = mInfo.getNumberOfButtons();
    if (buttons == -1)
    {
      System.out.println("No mouse detected. Program terminated.");
      System.exit(0);
    }
  }//ends hasMouse()

  private void pointerLocation()
  {
    try
    {
      pInfo = mInfo.getPointerInfo();
      point = pInfo.getLocation();

      pointX = point.getX();
      pointY = point.getY();

      System.out.println("pointer is at: (" + (int)pointX + ", " + (int)pointY + ")");

      delay();
    }

    catch(HeadlessException he)
    {
      System.out.println((he.toString()) + ". Program terminated.");
      System.exit(1);
    }

    catch(SecurityException se)
    {
      System.out.println((se.toString()) + ". Program terminated.");
      System.exit(1);
    }
  }//ends pointerLocation()

  public String getPointerLocation()
  { 
    return (point.toString());
  }//ends getPointerLocation()

  public void delay()
  {
    try
    {
      robot.delay(100);
      pointerLocation();
    }

    catch(Exception e) {
    }
  }//ends delay()

  public static void main(String[] args)
  {
    MouseLocation ml = new MouseLocation();
  }//ends
}//ends class MouseLocation

