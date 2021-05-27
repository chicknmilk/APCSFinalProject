public class Player {
  float x, y, speed;
  boolean[] direction;
  
  Room currentRoom;
  
  int health;
  int money;
  int blanks;
  int radius = 15;
  ArrayList<Weapon> weaponList;
  Weapon currentWeapon;
  
  Player(Room currentRoom, float speed) {
    this.x = width / 2;
    this.y = height / 2;
    this.direction = new boolean[4];
    
    this.speed = speed;
    this.currentRoom = currentRoom;
    
    this.health = 5;
    this.money = 0;
    this.blanks = 2;
    
    Weapon pistol = new Weapon(0.5, 5, 1, 0);
    this.weaponList = new ArrayList();
    this.weaponList.add(pistol);
    this.currentWeapon = pistol;
  }
  
  public void draw() {
    fill(0);
    
    // draw the player
    ellipseMode(CENTER);
    ellipse(this.x, this.y, radius * 2, radius * 2);
    
    // draw the weapon
    currentWeapon.draw();
  }
  
  public void move() {
    // sum the directions the player is moving in
    int x = (direction[EAST] ? 1 : 0) + (direction[WEST] ? -1 : 0);
    int y = (direction[NORTH] ? -1 : 0) + (direction[SOUTH] ? 1 : 0);

    if (!checkIfXWall(x, y)) this.x += speed * x;
    if (!checkIfYWall(x, y)) this.y += speed * y;
    
    // checks if the player tries to walk to another room
    checkIfRoomChange();
  }

  public boolean checkIfXWall(int x, int y) {
    float newX = x + this.x;
    float newY = y + this.y;

    try {
      // check if left is in a wall
      if (x == -1) {
        if (this.currentRoom.roomBlueprint[(int)(newY / 60)].charAt((int)((newX - radius) / 60)) == WALL) return true;
        if (this.currentRoom.roomBlueprint[(int)(newY / 60)].charAt((int)((newX - radius) / 60)) == CORRIDOR && this.currentRoom.corridorW == null) return true;
      }
    }
    catch (Exception e) {}
    try {
      // check if right is in a wall
      if (x == 1) {
        if (this.currentRoom.roomBlueprint[(int)(newY / 60)].charAt((int)((newX + radius) / 60)) == WALL) return true;
        if (this.currentRoom.roomBlueprint[(int)(newY / 60)].charAt((int)((newX + radius) / 60)) == CORRIDOR && this.currentRoom.corridorE == null) return true;       
      }
    }
    catch (Exception e) {}

    return false;
  }

  public boolean checkIfYWall(int x, int y) {
    float newX = x + this.x;
    float newY = y + this.y;
    try {
      // check if up is a wall
      if (y == -1) {
        if (this.currentRoom.roomBlueprint[(int)((newY - radius) / 60)].charAt((int)(newX / 60)) == WALL) return true;
        if (this.currentRoom.roomBlueprint[(int)((newY - radius) / 60)].charAt((int)(newX / 60)) == CORRIDOR && this.currentRoom.corridorN == null) return true;       
      }
    }
    catch (Exception e) {}
    try {
      // check if down is a wall
      if (y == 1) {
        if (this.currentRoom.roomBlueprint[(int)((newY + radius) / 60)].charAt((int)(newX / 60)) == WALL) return true;
        if (this.currentRoom.roomBlueprint[(int)((newY + radius) / 60)].charAt((int)(newX / 60)) == CORRIDOR && this.currentRoom.corridorS == null) return true;
      }
    }
    catch (Exception e) {}

    return false;
  }
 


  // responsible for switching room
  public void checkIfRoomChange() {
    if (this.x <= 0) {
      // check if there is a corridor here
      if (this.currentRoom.corridorW != null && (int)(this.x / 60) == this.currentRoom.corridorW[1] && (int)(this.y / 60) == this.currentRoom.corridorW[0]) {
        // GOING WEST
        if (this.currentRoom.roomW != null) {
          this.currentRoom.isCurrentRoom = false;
          this.currentRoom.roomW.isCurrentRoom = true;

          this.currentRoom.roomW.constructCorridors();
          
          this.x = this.currentRoom.roomW.corridorE[1] * 60 - 1;
          this.y = this.currentRoom.roomW.corridorE[0] * 60 + 30;

          this.currentRoom = this.currentRoom.roomW;
          this.currentRoom.visited = true;
        }
        else this.x = 0;
      }
      else this.x = 0;
    }
    else if (this.x >= width) {
      // check if there is a corridor here
      if (this.currentRoom.corridorE != null && (int)(this.x / 60) == this.currentRoom.corridorE[1] && (int)(this.y / 60) == this.currentRoom.corridorE[0]) {
        // GOING EAST
        if (this.currentRoom.roomE != null) {
          this.currentRoom.isCurrentRoom = false;
          this.currentRoom.roomE.isCurrentRoom = true;

          this.currentRoom.roomE.constructCorridors();

          this.x = this.currentRoom.roomE.corridorW[1] * 60 + 1;
          this.y = this.currentRoom.roomE.corridorW[0] * 60 + 30;
          
          this.currentRoom = this.currentRoom.roomE;
          this.currentRoom.visited = true;
        }
        else this.x = width;
      }
      else this.x = width;
    }
    if (this.y <= 0) {
      // check if there is a corridor here
      if (this.currentRoom.corridorN != null && (int)(this.x / 60) == this.currentRoom.corridorN[1] && (int)(this.y / 60) == this.currentRoom.corridorN[0]) {
        // GOING NORTH
        if (this.currentRoom.roomN != null) {
          this.currentRoom.isCurrentRoom = false;
          this.currentRoom.roomN.isCurrentRoom = true;

          this.currentRoom.roomN.constructCorridors();

          this.x = this.currentRoom.roomN.corridorS[1] * 60 + 30;
          this.y = this.currentRoom.roomN.corridorS[0] * 60 - 1;
          
          this.currentRoom = this.currentRoom.roomN;
          this.currentRoom.visited = true;
        }
        else this.y = 0;
      }
      else this.y = 0;
    }
    else if (this.y >= height) {
      // check if there is a corridor here
      if (this.currentRoom.corridorS != null && (int)(this.x / 60) == this.currentRoom.corridorS[1] && (int)(this.y / 60) == this.currentRoom.corridorS[0]) {
        // GOING SOUTH
        if (this.currentRoom.roomS != null) {
          this.currentRoom.isCurrentRoom = false;
          this.currentRoom.roomS.isCurrentRoom = true;

          this.currentRoom.roomS.constructCorridors();

          this.x = this.currentRoom.roomS.corridorN[1] * 60 + 30;
          this.y = this.currentRoom.roomS.corridorN[0] * 60 + 1;
          
          this.currentRoom = this.currentRoom.roomS;
          this.currentRoom.visited = true;
        }
        else this.y = height;
      }
      else this.y = height;
    }
  }
  
  public void changeDirection(boolean moving) {
    switch (keyCode) {
      case 87:
        direction[NORTH] = moving;
        break;
      case 82:
        direction[SOUTH] = moving;
        break;
      case 83:
        direction[EAST] = moving;
        break;
      case 65:
        direction[WEST] = moving;
        break;
    }
  }
  
  // asks the current weapon to shoot
  public void shootProjectile() {
    this.currentWeapon.shootProjectile(x, y);
  }
}
