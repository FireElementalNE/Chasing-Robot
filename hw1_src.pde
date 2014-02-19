
    boolean DEBUG = false;
    
    int CANVAS_WIDTH = 1280;
    int CANVAS_HEIGHT = 720;

    int ANTENNA_OFFSET_Y = -170;
    int ANTENNA_OFFSET_X = 0;
    int ANTENNA_RADIUS = 30;

    int HEAD_OFFSET_Y = -125;
    int HEAD_OFFSET_X = -45;
    int HEAD_WIDTH = 90;
    int HEAD_HEIGHT = 70;

    int BODY_OFFSET_Y = -55;
    int BODY_OFFSET_X = -30;
    int BODY_WIDTH = 60;
    int BODY_HEIGHT = 110;

    int L_ARM_OFFSET_X = -60;
    int L_ARM_OFFSET_Y = -30;
    int R_ARM_OFFSET_X = 60;
    int R_ARM_OFFSET_Y = -30;
    int ARM_RADIUS = 20;

    int L_LEG_OFFSET_X = -25;
    int L_LEG_OFFSET_Y = 100;
    int R_LEG_OFFSET_X = 25;
    int R_LEG_OFFSET_Y = 100;
    int LEG_WIDTH = 25;
    int LEG_HEIGHT = 35;

    int L_EYE_OFFSET_X = -18;
    int L_EYE_OFFSET_Y = -95;
    int R_EYE_OFFSET_X = 20;
    int R_EYE_OFFSET_Y = -95;
    int EYE_WIDTH = 20;
    int EYE_HEIGHT = 20;

    int MOUTH_OFFSET_X = 0;
    int MOUTH_OFFSET_Y = -65;
    int MOUTH_WIDTH = 20;
    int MOUTH_HEIGHT = 20;

    int constant = 0;
    float angle = 0.05f;
    int scalar = 100;
    float speed = 0.035f;
    String angleDir = "U";
    static int FLOOR_HEIGHT = 500;
    float mx = 100;
    float my = 100;
    float angle1 = 0.0f;
    int STARCOUNT = 200;
    Star[] sun = new Star[STARCOUNT];
    int BG_COLOR = color(55);
    myRainbow t0 = new myRainbow(245,193,193);
    MyRobot robot = new MyRobot(CANVAS_WIDTH/2, 600);
    //int x = 0;
    MovementOffset l_leg_move = new MovementOffset(0,"N","NS",20);
    MovementOffset r_leg_move = new MovementOffset(0,"S","NS",20);
    MovementOffset changeOffset(MovementOffset temp) {
        if(temp.atBound()) {
            temp.changeDirection();
        }
        temp.tickValue();
        return temp;
    }
    class MovementOffset {
        int value;
        String type;
        String direction;
        int upperBound;
        int lowerBound;
        MovementOffset(int t0, String t1, String t2, int t3) {
            value = t0;
            direction = t1;
            type = t2;
            upperBound = t3;
            lowerBound = -1 * t3;
        }
        boolean atBound() {
            if(direction == "N" || direction == "E") {
                if(value <= lowerBound) {
                    return true;
                }
            }
            if(direction == "S" || direction == "W") {
                if(value >= upperBound) {
                    return true;
                }
            }
            return false;
        }
        int getValue() {
            return value;
        }
        String getDirection() {
            return direction;
        }
        void setValue(int t0) {
            value = t0;
        }
        void tickValue() {
            if(direction == "N" || direction == "E") {
                value -= 3;
            }
            else {
                value += 3;
            }
        }
        void changeDirection() {
            if(type == "NS") {
                if(direction == "N") {
                    direction = "S";
                }
                else {
                    direction = "N";
                }
            }
            else if(type == "EW") {
                if(direction == "E") {
                    direction = "W";
                }
                else {
                    direction = "E";
                }
            }
        }
    }
    class Component {
        int x;
        int y;
        Component(int init_x, int init_y) {
            x = init_x;
            y = init_y;
        }
        int get_x() {
            return x;
        }
        int get_y() {
            return y;
        }
        void set_x(int t0) {
            x = t0;
        }
        void set_y(int t0) {
            y = t0;
        }
    }
    class Star { // got the stars from http://www.openprocessing.org/sketch/103135 (modified some to fit with my example)
        // They are born dark
        float x, y, bri = -1, dir, sz;
        void shine() {
            // if the star has completely faded to black
            // make it reappear somewhere else
            // (random position, random size and random brightness increase speed)
            if(bri < 107) {
                x = random(CANVAS_WIDTH);
                y = random(FLOOR_HEIGHT);
                sz = random(3);
                dir = random(1, 3);
                bri = 107;
            }
            // set the brightness and draw the star
            noStroke();
            fill(bri);
            ellipse(x, y, sz, sz);
            stroke(0);
            // increase or decrease the brightness
            bri = bri + dir;
            // if it achieved maximum brightness
            // choose a random fade out speed
            if(bri > 255) {
                bri = 255;
                dir = random(-1, -3);
            }
        }
    }
    class MyRobot {
        Component antenna;
        Component head;
        Component l_eye;
        Component r_eye;
        Component mouth;
        Component body;
        Component r_arm;
        Component l_arm;
        Component r_leg;
        Component l_leg;
        MyRobot(int org_x, int org_y) {
            antenna = new Component(org_x+ANTENNA_OFFSET_X, org_y+ANTENNA_OFFSET_Y);
            head = new Component(org_x+HEAD_OFFSET_X, org_y+HEAD_OFFSET_Y);
            body = new Component(org_x+BODY_OFFSET_X, org_y+BODY_OFFSET_Y);
            r_arm = new Component(org_x+R_ARM_OFFSET_X, org_y+R_ARM_OFFSET_Y);
            l_arm = new Component(org_x+L_ARM_OFFSET_X, org_y+L_ARM_OFFSET_Y);
            r_leg = new Component(org_x+R_LEG_OFFSET_X, org_y+R_LEG_OFFSET_Y);
            l_leg = new Component(org_x+L_LEG_OFFSET_X, org_y+L_LEG_OFFSET_Y);
            l_eye = new Component(org_x+L_EYE_OFFSET_X, org_y+L_EYE_OFFSET_Y);
            r_eye = new Component(org_x+R_EYE_OFFSET_X, org_y+R_EYE_OFFSET_Y);
            mouth = new Component(org_x+MOUTH_OFFSET_X, org_y+MOUTH_OFFSET_Y);
        }
        int getX() {
            return body.get_x()-BODY_OFFSET_X;
        }
        int getY() {
            return body.get_y()-BODY_OFFSET_Y;
        }
        void setCoord(int x, int y) {
            antenna.set_x(x+ANTENNA_OFFSET_X);
            head.set_x(x+HEAD_OFFSET_X);
            body.set_x(x+BODY_OFFSET_X);
            r_arm.set_x(x+R_ARM_OFFSET_X);
            l_arm.set_x(x+L_ARM_OFFSET_X);
            r_leg.set_x(x+R_LEG_OFFSET_X);
            l_leg.set_x(x+L_LEG_OFFSET_X);
            l_eye.set_x(x+L_EYE_OFFSET_X);
            r_eye.set_x(x+R_EYE_OFFSET_X);
            mouth.set_x(x+MOUTH_OFFSET_X);
            antenna.set_y(y + ANTENNA_OFFSET_Y);
            head.set_y(y + HEAD_OFFSET_Y);
            body.set_y(y + BODY_OFFSET_Y);
            r_arm.set_y(y + R_ARM_OFFSET_Y);
            l_arm.set_y(y + L_ARM_OFFSET_Y);
            r_leg.set_y(y + R_LEG_OFFSET_Y);
            l_leg.set_y(y + L_LEG_OFFSET_Y);
            l_eye.set_y(y + L_EYE_OFFSET_Y);
            r_eye.set_y(y + R_EYE_OFFSET_Y);
            mouth.set_y(y+MOUTH_OFFSET_Y);
        }
    }
    class myRainbow {
        int stage;
        int r,g,b;
        myRainbow(int r0, int g0, int b0) {
            stage = 1;
            r = r0;
            g = g0;
            b = b0;
        }
        int getStage() {
            return stage;
        }
        int [] calcValues() {
            // blue increases to 255
            // red decreases to 0
            // green increases to 255
            // blue decreases to 0
            // red increases to 255
            // green decreases to 0
            if(stage == 1) {
                if(r == 245 && b == 245 && g == 193)
                    stage = 2;
                else
                    b++;
            }
            if(stage == 2) {
                if( b == 245 && r == 193 && g == 193)
                    stage = 3;
                else
                    r--;
            }
            if(stage == 3) {
                if( b == 245 && r == 193 && g == 245)
                    stage = 4;
                else
                    g++;
            }
            if(stage == 4) {
                if( b == 193 && r == 193 && g == 245)
                    stage = 5;
                else
                    b--;
            }
            if(stage == 5) {
                if( b == 193 && r == 245 && g == 245)
                    stage = 6;
                else
                    r++;
            }
            if(stage == 6) {
                if( b == 193 && r == 245 && g == 193)
                    stage = 1;
                else
                    g--;
            }
            int[] colors = new int[3];
            colors[0] = r;
            colors[1] = g;
            colors[2] = b;
            return colors;
        }
    }

    void drawHead(MyRobot temp) {
        noStroke();
        rect(temp.head.get_x(), temp.head.get_y(), HEAD_WIDTH, HEAD_HEIGHT, 10);
        stroke(0);
    }
    void drawbody(MyRobot temp) {
        noStroke();

        rect(temp.body.get_x(), temp.body.get_y(), BODY_WIDTH, BODY_HEIGHT, 10);
        long unixTime = System.currentTimeMillis() / 1000L;
        if(unixTime % 2 == 1){
            fill(237,245,7);
        }
        else {
            fill(245,7,47);
        }
        rect(temp.body.get_x()+9, temp.body.get_y()+10, 9, 9, 10);
        rect(temp.body.get_x()+43, temp.body.get_y()+10, 9, 9, 10);
        if(unixTime % 2 == 0){
            fill(237,245,7);
        }
        else {
            fill(245,7,47);
        }
        rect(temp.body.get_x()+26, temp.body.get_y()+10, 9, 9, 10);
        stroke(194);
        line(temp.body.get_x(),temp.body.get_y()+55,temp.body.get_x()+BODY_WIDTH-1,temp.body.get_y()+55);
        line(temp.body.get_x(),temp.body.get_y()+45,temp.body.get_x()+BODY_WIDTH-1,temp.body.get_y()+45);
        line(temp.body.get_x(),temp.body.get_y()+65,temp.body.get_x()+BODY_WIDTH-1,temp.body.get_y()+65);

        fill(138);

        stroke(0);
    }
    void drawAntenna(MyRobot temp, boolean atMouse) {
        if(atMouse) {
            fill(color(55,255,5));
        }
        else {
            fill(color(255,5,47));
        }
        ellipse(temp.antenna.get_x(), temp.antenna.get_y(), ANTENNA_RADIUS, ANTENNA_RADIUS);
        fill(color(255,255,255));
        stroke(0,0,0);
    }
    void drawArms(MyRobot temp, float x, float y, float x1, float y1, boolean moveArms) {
        if(moveArms) {
            ellipse(temp.r_arm.get_x() + y - 90, temp.r_arm.get_y() + x, ARM_RADIUS, ARM_RADIUS);
            ellipse(temp.l_arm.get_x() + y1 + 90, temp.l_arm.get_y() + x1, ARM_RADIUS, ARM_RADIUS);
        }
        else {
            ellipse(temp.r_arm.get_x(), temp.r_arm.get_y(), ARM_RADIUS, ARM_RADIUS);
            ellipse(temp.l_arm.get_x(), temp.l_arm.get_y(), ARM_RADIUS, ARM_RADIUS);
        }
    }
    void drawLegs(MyRobot temp, MovementOffset l_offset, MovementOffset r_offset, boolean moveLegs) {
        if(moveLegs) {
            arc(temp.r_leg.get_x(), temp.r_leg.get_y() + r_offset.getValue(), LEG_WIDTH, LEG_HEIGHT, -PI, 0,CHORD);
            arc(temp.l_leg.get_x(), temp.l_leg.get_y() + l_offset.getValue(), LEG_WIDTH, LEG_HEIGHT, -PI, 0,CHORD);
        }
        else {
            arc(temp.r_leg.get_x(), temp.r_leg.get_y(), LEG_WIDTH, LEG_HEIGHT, -PI, 0,CHORD);
            arc(temp.l_leg.get_x(), temp.l_leg.get_y(), LEG_WIDTH, LEG_HEIGHT, -PI, 0,CHORD);
        }
    }
    void drawEyes(MyRobot temp, boolean atMouse) {
        if(atMouse) {
            fill(255,247,5);
            ellipse(temp.r_eye.get_x(), temp.r_eye.get_y(), EYE_WIDTH, EYE_HEIGHT);
            ellipse(temp.l_eye.get_x(), temp.l_eye.get_y(), EYE_WIDTH, EYE_HEIGHT);
        }
        else {
            fill(160,0,11);
            arc(temp.r_eye.get_x(), temp.r_eye.get_y(), EYE_WIDTH, EYE_HEIGHT, -0.5f, PI-0.5f,CHORD);
            arc(temp.l_eye.get_x(), temp.l_eye.get_y(), EYE_WIDTH, EYE_HEIGHT,0.5f,PI+0.5f,CHORD);
        }
        fill(255,255,255);
    }
    void drawMouth(MyRobot temp, boolean atMouse) {
        if(atMouse) {
            fill(0,0,0);
            arc(temp.mouth.get_x(), temp.mouth.get_y()-5, MOUTH_WIDTH, MOUTH_HEIGHT, 0,PI,CHORD);
            fill(255,255,255);
        }
        else {
            fill(0,0,0);
            arc(temp.mouth.get_x(), temp.mouth.get_y(), MOUTH_WIDTH, MOUTH_HEIGHT, -PI, 0,CHORD);
            fill(255,255,255);
        }

    }
    void drawRobot(boolean moveLimbs , boolean atMouse, float sf) {
        if(sf>3.8){
            sf = 3.8f;
        }
        if(sf<0.01) {
          sf = 0.01f;
        }
        translate(0,0,sf*100);
        l_leg_move = changeOffset(l_leg_move);
        r_leg_move = changeOffset(r_leg_move);
        float x = constant + sin(angle) * scalar;
        float y = constant + cos(angle) * scalar;
        float x1 = constant + sin(angle) * scalar;
        float y1 = constant - cos(angle) * scalar;
        drawArms(robot, x,y,x1,y1,moveLimbs);
        drawLegs(robot, l_leg_move, r_leg_move, moveLimbs);
        drawHead(robot);
        drawbody(robot);
        drawAntenna(robot, atMouse);
        drawEyes(robot, atMouse);
        drawMouth(robot, atMouse);
        translate(0,0,0);
        scale(1.0f);
    }
    void setup() {
        size(CANVAS_WIDTH, CANVAS_HEIGHT,P3D);
        for(int i=0; i<STARCOUNT; i++) {
            sun[i] = new Star();
        }
        smooth();


    }
    boolean atMouse() {
        if(robot.getX() == floor(mx)) {
            return true;
        }
        return false;
    }
    int moveX(int roboX) {
        if(abs(mx - roboX) <= 2f) {
            return floor(mx);
        }
        else {
            if (mx > roboX) {
               return roboX + 2;
            }
            else {
                if(mx < roboX) {
                    return roboX - 2;
                }
            }
        }
        return -1;
    }
    int moveY(int roboY) {
        if(abs(my - roboY) <= 5f) {
            return roboY;
        }
        else {
            if (my > roboY) {
                if(roboY + 5 > CANVAS_HEIGHT - 150) {
                    return CANVAS_HEIGHT - 150;
                }
                return roboY + 5;
            }
            else {
                if(my < roboY) {
                    if(roboY - 5 < FLOOR_HEIGHT) {
                        return FLOOR_HEIGHT;
                    }
                    return roboY - 5;
                }
            }
        }
        return -1;
    }
    void drawGrid() {
        int topX = CANVAS_WIDTH / 2;
        int bottomX = CANVAS_WIDTH / 2;
        line(topX, FLOOR_HEIGHT, bottomX, CANVAS_HEIGHT);
        for(int i=0; i < 10000; i = i + 20)
            line(topX + i, FLOOR_HEIGHT,bottomX + i + i , CANVAS_HEIGHT);
        for(int i=0; i < 10000; i = i + 20)
            line(topX - i, FLOOR_HEIGHT,bottomX - i - i , CANVAS_HEIGHT);
        for(float i=500f; i > 1f; i = i * 0.8f)
            line(0, FLOOR_HEIGHT+i, CANVAS_WIDTH,FLOOR_HEIGHT+i);
        line(0, FLOOR_HEIGHT, CANVAS_WIDTH,FLOOR_HEIGHT);
    }
    void drawStars() {
        for(int i=0; i<STARCOUNT; i++) {
            sun[i].shine();
        }
        fill(255);
        stroke(0);
    }
    void drawFloor(int[] c) {
        noStroke();
        fill(0);
        rect(0, FLOOR_HEIGHT, CANVAS_WIDTH, CANVAS_HEIGHT - FLOOR_HEIGHT);
        fill(255);

        stroke(c[0],c[1],c[2]);
        drawGrid(); //got the grid idea from tron
        noStroke();

    }
    void drawText(boolean atMouse, int[] c) {
        PFont myfont = loadFont("DejaVuSansMono-13.vlw");
        String status = null;
        String mood = null;
        if(!atMouse) {
            status = "Moving!";
            mood = "ANGRY! RAWR D:<";
        }
        else {
            status = "Content!";
            mood = "HAPPY!";
        }
        stroke(255);
        textFont(myfont);
        text("Robot Status: " + status,100,100);
        text("Robot Mood: " + mood,100,113);
        text("Current X: " + robot.getX(),100,126);
        text("Target X: " + mx,100,139);
        stroke(c[0],c[1],c[2]);
        String red = Integer.toHexString(c[0]);
        String green = Integer.toHexString(c[1]);
        String blue = Integer.toHexString(c[2]);

        text("#" + red + green + blue, 100, 152);
        noStroke();
    }
    float getScaleFactor(int yPos) {
       return 0.01f+((yPos-500) * 0.061f);

    }
    void draw() {

        int[] c = new int[2];
        c = t0.calcValues();
        background(BG_COLOR);
        drawFloor(c);
        drawStars();

        float dx = mouseX - mx;
        float dy = mouseY - my;
        angle1 = atan2(dy, dx);
        mx = mouseX - (cos(angle1) * 1);
        my = mouseY - (sin(angle1) * 1);
        boolean moveLimbs = !atMouse();

        int roboX = moveX(robot.getX());
        int roboY = moveY(robot.getY());
        robot.setCoord(floor(roboX),floor(roboY));
        fill(138);
        noStroke();
        float scaleFactor = getScaleFactor(roboY);
        drawRobot(moveLimbs, atMouse(), scaleFactor);
        if(DEBUG)
          drawText(atMouse(),c);
        noFill();
        if(angleDir == "U")
            angle = angle + speed;
        else
            angle = angle - speed;
        if(angle > 0.3)
            angleDir = "D";
        else if(angle < -0.3)
            angleDir = "U";
    }


