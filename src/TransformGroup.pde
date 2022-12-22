class TransformGroup{
	static ArrayList<TransformGroup> data=new ArrayList<TransformGroup>();

	Object _next_child;
	private Object _first_child;
	private TransformMatrix _matrix;



	TransformGroup(){
		this._first_child=null;
		this._matrix=new TransformMatrix();
		TransformGroup.data.add(this);
	}



	void add(Line line){
		if (line._next_child!=null){
			throw new RuntimeException("Line already has a parent");
		}
		line._next_child=this._first_child;
		this._first_child=line;
	}



	void add(TransformGroup group){
		if (group._next_child!=null){
			throw new RuntimeException("Transform Group already has a parent");
		}
		group._next_child=this._first_child;
		this._first_child=group;
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
		Object child=this._first_child;
		while (child!=null){
			if (child instanceof TransformGroup){
				TransformGroup group=(TransformGroup)child;
				group.update(delta_time,matrix);
				child=group._next_child;
			}
			else{
				Line line=(Line)child;
				line.update_matrix(matrix);
				player.collide(line);
				child=line._next_child;
			}
		}
	}
}
