class TransformMatrix{
	float[] data;



	TransformMatrix(){
		this.data=new float[6];
		this.identity();
	}



	TransformMatrix multiply(TransformMatrix other){
		TransformMatrix out=new TransformMatrix();
		out.data[0]=this.data[0]*other.data[0]+this.data[1]*other.data[3];
		out.data[1]=this.data[0]*other.data[1]+this.data[1]*other.data[4];
		out.data[2]=this.data[0]*other.data[2]+this.data[2];
		out.data[3]=this.data[3]*other.data[0]+this.data[4]*other.data[3];
		out.data[4]=this.data[3]*other.data[1]+this.data[4]*other.data[4];
		out.data[5]=this.data[3]*other.data[2]+this.data[4]*other.data[5]+this.data[5];
		return out;
	}



	Vector multiply(float x,float y){
		Vector out=new Vector(0,0);
		out.x=this.data[0]*x+this.data[1]*y+this.data[2];
		out.y=this.data[3]*x+this.data[4]*y+this.data[5];
		return out;
	}



	void identity(){
		this.data[0]=1;
		this.data[1]=0;
		this.data[2]=0;
		this.data[3]=0;
		this.data[4]=1;
		this.data[5]=0;
	}



	void translate(float x,float y){
		this.data[0]=1;
		this.data[1]=0;
		this.data[2]=x;
		this.data[3]=0;
		this.data[4]=1;
		this.data[5]=y;
	}



	void rotate(float angle,float ox,float oy){
		float s=sin(angle);
		float c=cos(angle);
		this.data[0]=c;
		this.data[1]=-s;
		this.data[2]=ox*(1-c)+oy*s;
		this.data[3]=s;
		this.data[4]=c;
		this.data[5]=oy*(1-c)-ox*s;
	}
}
