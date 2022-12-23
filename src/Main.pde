final float PLAYER_WIDTH=60;
final float PLAYER_HEIGHT=120;
final float GRAVITY=30;
final float PLAYER_WALK_SPEED=20;
final float PLAYER_MAX_SPEED=20;
final float FRICTION=0.95;
final float AIR_FRICTION=0.985;
final float JUMP_ACCELERATION=600;
final float LINE_END_SHRINK=10;
final float MAX_LEG_LENGTH=75;
final float MAX_COYOTE_TIME=0.05;
boolean DEBUG=true;



final Player player=new Player(960,400);



float _last_frame_time;
boolean[] keys=new boolean[256];
TransformGroup root_group;
TransformGroup rotating_square;
TransformGroup moving_platform;



void setup(){
	size(1920,1080);
	_last_frame_time=millis();
	for (int i=0;i<256;i++){
		keys[i]=false;
	}
	root_group=new TransformGroup();
	root_group.add(new Line(0,1080,1920,1080));
	root_group.add(new Line(0,0,1920,0));
	root_group.add(new Line(1920,0,1920,1080));
	root_group.add(new Line(0,0,0,1080));
	root_group.add(new Line(0,900,500,900));
	root_group.add(new Line(500,900,500,1080));
	root_group.add(new Line(500,1000,800,1080));
	root_group.add(new Line(1720,00,1200,1080));
	rotating_square=new TransformGroup();
	rotating_square.add(new Line(860,620,1060,620));
	rotating_square.add(new Line(860,820,1060,820));
	rotating_square.add(new Line(860,620,860,820));
	rotating_square.add(new Line(1060,620,1060,820));
	root_group.add(rotating_square);
	moving_platform=new TransformGroup();
	moving_platform.add(new Line(0,750,500,750));
	root_group.add(moving_platform);
}



void draw(){
	int time=millis();
	float delta_time=(time-_last_frame_time)*1e-3f;
	_last_frame_time=time;
	if (keys['A']||keys['a']){
		player.move(-1);
	}
	if (keys['D']||keys['d']){
		player.move(1);
	}
	if (keys[' ']){
		player.jump();
	}
	rotating_square.rotate(time*0.001,960,720);
	moving_platform.translate(sin(time*0.001)*100,cos(time*0.001)*250);
	player.update(delta_time);
	background(0);
	root_group.update(delta_time,null);
	for (Line line:Line.data){
		line.draw();
	}
	player.draw();
}



void keyPressed(){
	if (key<256){
		keys[key]=true;
		if (key=='q'){
			DEBUG=!DEBUG;
		}
		else if (key=='r'){
			player.x=width/2;
			player.y=height/2;
		}
	}
}



void keyReleased(){
	if (key<256){
		keys[key]=false;
	}
}
