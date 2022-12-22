class Line{
	static final int TYPE_GROUND=0;
	static final int TYPE_SLOPE=1;
	static final int TYPE_WALL=2;
	static final int TYPE_MASK=3;

	static ArrayList<Line> data=new ArrayList<Line>();

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
	Object _next_child;
	private float _base_x0;
	private float _base_y0;
	private float _base_x1;
	private float _base_y1;



	Line(float x0,float y0,float x1,float y1){
		this.flags=0;
		this.vx=0;
		this.vy=0;
		this._base_x0=x0;
		this._base_y0=y0;
		this._base_x1=x1;
		this._base_y1=y1;
		this.update_matrix(new TransformMatrix());
		Line.data.add(this);
	}



	void update_matrix(TransformMatrix matrix){
		Vector p0=matrix.multiply(this._base_x0,this._base_y0);
		Vector p1=matrix.multiply(this._base_x1,this._base_y1);
		if (p1.x<p0.x||(p0.x==p1.x&&p1.y<p0.y)){
			Vector tmp=p0;
			p0=p1;
			p1=tmp;
		}
		this.x0=p0.x;
		this.y0=p0.y;
		this.x1=p1.x;
		this.y1=p1.y;
		this.normal_x=this.y1-this.y0;
		this.normal_y=this.x0-this.x1;
		this.length=sqrt(this.normal_x*this.normal_x+this.normal_y*this.normal_y);
		this.normal_x/=this.length;
		this.normal_y/=this.length;
		this.x0-=this.normal_y*LINE_END_SHRINK;
		this.y0+=this.normal_x*LINE_END_SHRINK;
		this.x1+=this.normal_y*LINE_END_SHRINK;
		this.y1-=this.normal_x*LINE_END_SHRINK;
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
}
