class Util{
	static boolean line_rectangle_intersection(float x,float y,float w,float h,float x0,float y0,float x1,float y1){
		return Util.line_line_intersection(x,y,x+w,y,x0,y0,x1,y1)||Util.line_line_intersection(x,y+h,x+w,y+h,x0,y0,x1,y1)||Util.line_line_intersection(x,y,x,y+h,x0,y0,x1,y1)||Util.line_line_intersection(x+w,y,x+w,y+h,x0,y0,x1,y1);
	}



	static int sign(float val){
		return (val<0?-1:1);
	}



	static PVector rotate_around(float x,float y,float a,float ox,float oy){
		return new PVector(ox+(x-ox)*cos(a)-(y-oy)*sin(a),oy+(x-ox)*sin(a)+(y-oy)*cos(a));
	}



	static boolean is_left_side(float x,float y,float x0,float y0,float x1,float y1){
		return (x-x0)*(y1-y0)>(y-y0)*(x1-x0);
	}



	private static boolean line_line_intersection(float x0,float y0,float x1,float y1,float x2,float y2,float x3,float y3){
		float m=(y3-y2)*(x1-x0)-(x3-x2)*(y1-y0);
		if (m==0){
			return false;
		}
		float u=(x3-x2)*(y0-y2)-(y3-y2)*(x0-x2);
		float v=(x1-x0)*(y0-y2)-(y1-y0)*(x0-x2);
		if (m<0){
			m=-m;
			u=-u;
			v=-v;
		}
		return u>=0&&u<=m&&v>=0&&v<=m;
	}
}
