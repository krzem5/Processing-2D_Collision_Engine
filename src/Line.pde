class Line{
	static final int TYPE_GROUND=0;
	static final int TYPE_SLOPE=1;
	static final int TYPE_WALL=2;
	static final int TYPE_MASK=3;

	int flags;
	float x0;
	float y0;
	float x1;
	float y1;
	float vx;
	float vy;
	float normal_x;
	float normal_y;
	float length;



	Line(float x0,float y0,float x1,float y1){
		if (x1<x0||(x0==x1&&y1<y0)){
			float tmp=x0;
			x0=x1;
			x1=tmp;
			tmp=y0;
			y0=y1;
			y1=tmp;
		}
		this.flags=0;
		this.x0=x0;
		this.y0=y0;
		this.x1=x1;
		this.y1=y1;
		this.vx=0;
		this.vy=0;
		this.normal_x=this.y1-this.y0;
		this.normal_y=this.x0-this.x1;
		float m=1/sqrt(this.normal_x*this.normal_x+this.normal_y*this.normal_y);
		this.normal_x*=m;
		this.normal_y*=m;
		this.x0-=this.normal_y*LINE_END_SHRINK;
		this.y0+=this.normal_x*LINE_END_SHRINK;
		this.x1+=this.normal_y*LINE_END_SHRINK;
		this.y1-=this.normal_x*LINE_END_SHRINK;
		this.length=sqrt((this.x1-this.x0)*(this.x1-this.x0)+(this.y1-this.y0)*(this.y1-this.y0));
		this._calculate_type();
	}



	void move(float vx,float vy){
		this.vx=vx;
		this.vy=vy;
	}



	void update(float delta_time){
		if (this.vx!=0){
			this.vx*=delta_time;
			this.x0+=this.vx;
			this.x1+=this.vx;
		}
		if (this.vy!=0){
			this.vy*=delta_time;
			this.y0+=this.vy;
			this.y1+=this.vy;
		}
	}



	void rotate(float a,float ox,float oy){
		PVector np0=Util.rotate_around(this.x0,this.y0,a,ox,oy);
		PVector np1=Util.rotate_around(this.x1,this.y1,a,ox,oy);
		PVector nn=Util.rotate_around(this.normal_x,this.normal_y,a,0,0);
		if (np1.x<np0.x||(np0.x==np1.x&&np1.y<np0.y)){
			PVector tmp=np0;
			np0=np1;
			np1=tmp;
			nn.x*=-1;
			nn.y*=-1;
		}
		this.x0=np0.x;
		this.y0=np0.y;
		this.x1=np1.x;
		this.y1=np1.y;
		this.normal_x=nn.x;
		this.normal_y=nn.y;
		this._calculate_type();
	}



	void draw(){
		if (DEBUG){
			stroke(((this.flags&Line.TYPE_MASK)==Line.TYPE_WALL?#7f3f7f:((this.flags&Line.TYPE_MASK)==Line.TYPE_SLOPE?#3f7f3f:#3f507f)));
			strokeWeight(20);
			line(this.x0,this.y0,this.x1,this.y1);
			stroke(#7f3f50);
			strokeWeight(10);
			line(this.x0/2+this.x1/2,this.y0/2+this.y1/2,this.x0/2+this.x1/2+this.normal_x*50,this.y0/2+this.y1/2+this.normal_y*50);
			stroke(#507f50);
			strokeWeight(10);
			line(this.x0/2+this.x1/2,this.y0/2+this.y1/2,this.x0/2+this.x1/2-this.normal_x*50,this.y0/2+this.y1/2-this.normal_y*50);
		}
		else{
			stroke(#5a5a5f);
			strokeWeight(10);
			line(this.x0,this.y0,this.x1,this.y1);
		}
	}



	private void _calculate_type(){
		this.flags&=~Line.TYPE_MASK;
		if (abs(this.normal_y)<0.4f){
			this.flags|=Line.TYPE_WALL;
		}
		else if (abs(this.normal_x)>=abs(this.normal_y)*0.4f){
			this.flags|=Line.TYPE_SLOPE;
		}
		else{
			this.flags|=Line.TYPE_GROUND;
		}
	}
}
