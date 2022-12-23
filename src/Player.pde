class Player{
	float x;
	float y;
	boolean on_ground;
	private float _coyote_time;
	private float _ax;
	private float _ay;
	private float _vx;
	private float _vy;
	private Line _ground_line;
	private float _ground_vx;
	private float _ground_vy;
	private float _leg_left_y;
	private float _leg_right_y;
	private float _speed_x;
	private float _speed_y;



	Player(float x,float y){
		this.x=x;
		this.y=y;
		this.on_ground=false;
		this._coyote_time=-1;
		this._ax=0;
		this._ay=0;
		this._vx=0;
		this._vy=0;
		this._ground_line=null;
		this._ground_vx=0;
		this._ground_vy=0;
		this._leg_left_y=0;
		this._leg_right_y=0;
		this._speed_x=0;
		this._speed_y=0;
	}



	void jump(){
		if (this.on_ground||this._coyote_time>=0){
			this._speed_y-=JUMP_ACCELERATION;
			this._coyote_time=-1;
		}
	}



	void move(int direction){
		this._speed_x+=PLAYER_WALK_SPEED*(direction<0?-1:1);
	}



	void update(float delta_time){
		if (this._coyote_time>=0){
			this._coyote_time+=delta_time;
			if (this._coyote_time>MAX_COYOTE_TIME){
				this._coyote_time=-1;
				this._vx+=this._ground_vx;
				this._vy+=this._ground_vy;
				this._ground_vx=0;
				this._ground_vy=0;
			}
		}
		if (this._ground_line!=null){
			Vector v=this._ground_line.get_velocity(this.x);
			this.x+=v.x;
			this.y+=v.y;
			this._ax+=v.x;
			this._ay+=v.y;
		}
		this._vx=(this._vx+this._ax*delta_time)*(this.on_ground?FRICTION:AIR_FRICTION);
		this._vy+=this._ay*delta_time;
		float m=this._vx*this._vx+this._vy*this._vy;
		if (m>PLAYER_MAX_SPEED*PLAYER_MAX_SPEED){
			m=PLAYER_MAX_SPEED/sqrt(m);
			this._vx*=m;
			this._vy*=m;
		}
		this.x+=this._vx;
		this.y+=this._vy;
		if (this.y>height){
			this.x=width/2;
			this.y=height/2;
			this._vx=0;
			this._vy=0;
			this._ax=0;
			this._ay=0;
		}
		this.on_ground=false;
		this._ax=0;
		this._ay=GRAVITY;
		this._ax+=this._speed_x;
		this._ay+=this._speed_y*(this._ground_line!=null&&(this._ground_line.flags&Line.TYPE_MASK)==Line.TYPE_SLOPE?-this._ground_line.normal_y:1);
		this._speed_x=0;
		this._speed_y=0;
		this._ground_line=null;
		this._leg_left_y=this.y+MAX_LEG_LENGTH;
		this._leg_right_y=this.y+MAX_LEG_LENGTH;
	}



	void collide(Line line){
		boolean left_side=Util.is_left_side(this.x,this.y,line.x0,line.y0,line.x1,line.y1);
		if ((line.flags&Line.TYPE_MASK)!=Line.TYPE_WALL&&left_side){
			float left_x=this.x-PLAYER_WIDTH*0.375;
			if (line.x0-LINE_END_SHRINK<=left_x&&left_x<=line.x1+LINE_END_SHRINK){
				float new_left_y=map(left_x,line.x0,line.x1,line.y0,line.y1);
				if (new_left_y<this._leg_left_y){
					this._leg_left_y=new_left_y;
				}
			}
			float right_x=this.x+PLAYER_WIDTH*0.375;
			if (line.x0-LINE_END_SHRINK<=right_x&&right_x<=line.x1+LINE_END_SHRINK){
				float new_right_y=map(right_x,line.x0,line.x1,line.y0,line.y1);
				if (new_right_y<this._leg_right_y){
					this._leg_right_y=new_right_y;
				}
			}
		}
		Vector[] points={
			new Vector(this.x-PLAYER_WIDTH/2,this.y-PLAYER_HEIGHT/2),
			new Vector(this.x+PLAYER_WIDTH/2,this.y-PLAYER_HEIGHT/2),
			new Vector(this.x-PLAYER_WIDTH/2,this.y+PLAYER_HEIGHT/2),
			new Vector(this.x+PLAYER_WIDTH/2,this.y+PLAYER_HEIGHT/2)
		};
		float dist=0;
		boolean has_intersection=false;
		for (Vector point:points){
			float dx=line.x0-point.x;
			float dy=line.y0-point.y;
			float projected_length=-dx*line.dx-dy*line.dy;
			if (projected_length>=0&&projected_length<=line.length*line.length){
				has_intersection=true;
			}
			float dot_product=(point.x-line.x0)*line.normal_x+(point.y-line.y0)*line.normal_y;
			if ((dot_product<0)==left_side){
				float distance=abs(dot_product);
				if (distance>dist){
					dist=distance;
				}
			}
		}
		if (!has_intersection||dist==0){
			return;
		}
		if (!left_side){
			dist=-dist;
		}
		this.x+=line.normal_x*dist;
		this.y+=line.normal_y*dist;
		if ((this._vx*line.normal_x+this._vy*line.normal_y>0)!=left_side){
			this._vx+=line.normal_x*dist;
			this._vy+=line.normal_y*dist;
		}
		if ((line.flags&Line.TYPE_MASK)!=Line.TYPE_WALL&&left_side){
			this.on_ground=true;
			this._coyote_time=0;
			this._ground_line=line;
		}
	}



	void draw(){
		noStroke();
		if (DEBUG){
			fill(0xa0afafaf);
			rect(this.x-PLAYER_WIDTH/2,this.y-PLAYER_HEIGHT/2,PLAYER_WIDTH,PLAYER_HEIGHT);
		}
		fill(#ffffff);
		rect(this.x-PLAYER_WIDTH/2,this.y-PLAYER_HEIGHT/2,PLAYER_WIDTH,PLAYER_HEIGHT*0.65);
		float leg_base=this.y+PLAYER_HEIGHT*0.15;
		rect(this.x-PLAYER_WIDTH/2,leg_base,PLAYER_WIDTH*0.25,this._leg_left_y-leg_base);
		rect(this.x+PLAYER_WIDTH*0.25,leg_base,PLAYER_WIDTH*0.25,this._leg_right_y-leg_base);
	}
}
