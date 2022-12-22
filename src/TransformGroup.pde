class TransformGroup{
	static final private int NEXT_CHILD_TYPE_MASK=1;
	static final private int NEXT_CHILD_TYPE_GROUP=0;
	static final private int NEXT_CHILD_TYPE_LINE=1;
	static final private int NEXT_CHILD_ID_SHIFT=1;

	static ArrayList<TransformGroup> data=new ArrayList<TransformGroup>();

	int _next_child;
	int _id;
	private int _first_child;
	private TransformMatrix _matrix;



	TransformGroup(){
		this._first_child=0xffffffff;
		this._matrix=new TransformMatrix();
		this._next_child=0xffffffff;
		this._id=TransformGroup.data.size();
		TransformGroup.data.add(this);
	}



	void add(Line line){
		if (line._next_child!=0xffffffff){
			throw new RuntimeException("Line already has a parent");
		}
		line._next_child=this._first_child;
		this._first_child=(line._id<<TransformGroup.NEXT_CHILD_ID_SHIFT)|TransformGroup.NEXT_CHILD_TYPE_LINE;
	}



	void add(TransformGroup group){
		if (group._next_child!=0xffffffff){
			throw new RuntimeException("Transform Group already has a parent");
		}
		group._next_child=this._first_child;
		this._first_child=(group._id<<TransformGroup.NEXT_CHILD_ID_SHIFT)|TransformGroup.NEXT_CHILD_TYPE_GROUP;
	}



	void translate(float x,float y){
		TransformMatrix matrix=new TransformMatrix();
		matrix.translate(x,y);
		this._matrix=matrix.multiply(this._matrix);
	}



	void rotate(float angle,float ox,float oy){
		TransformMatrix matrix=new TransformMatrix();
		matrix.rotate(angle,ox,oy);
		this._matrix=matrix.multiply(this._matrix);
	}



	void update(float delta_time,TransformMatrix parent_matrix){
		if (parent_matrix==null){
			parent_matrix=new TransformMatrix();
		}
		TransformMatrix matrix=parent_matrix.multiply(this._matrix);
		this._matrix.identity();
		int child=this._first_child;
		while (child!=0xffffffff){
			if ((child&TransformGroup.NEXT_CHILD_TYPE_MASK)==TransformGroup.NEXT_CHILD_TYPE_GROUP){
				TransformGroup group=TransformGroup.data.get(child>>TransformGroup.NEXT_CHILD_ID_SHIFT);
				group.update(delta_time,matrix);
				child=group._next_child;
			}
			else{
				Line line=Line.data.get(child>>TransformGroup.NEXT_CHILD_ID_SHIFT);
				line.update_matrix(matrix);
				player.collide(line);
				child=line._next_child;
			}
		}
	}
}
