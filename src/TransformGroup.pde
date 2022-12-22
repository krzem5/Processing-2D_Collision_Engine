class TransformGroup{
	static ArrayList<TransformGroup> data=new ArrayList<TransformGroup>();

	Object _next_child;
	private Object _first_child;



	TransformGroup(){
		this._first_child=null;
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



	void update(float delta_time){
		Object child=this._first_child;
		while (child!=null){
			if (child instanceof TransformGroup){
				TransformGroup group=(TransformGroup)child;
				group.update(delta_time);
				child=group._next_child;
			}
			else{
				Line line=(Line)child;
				line.update(delta_time);
				player.collide(line);
				child=line._next_child;
			}
		}
	}
}
