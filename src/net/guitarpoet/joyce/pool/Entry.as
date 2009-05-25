package net.guitarpoet.joyce.pool {
	/**
	 * The pool entry for object pool.
	 *  
	 * @author jack
	 * @since 05/20/09
	 * 
	 */
	public class Entry {
		private var hold : * = null;
		public var name : String;
		public var createTime : Date;
		public var modifyTime : Date;
		public var readTime : Date;
		public var weight : int;
		
		public function get value() : * {
			readTime = new Date();
			return hold;
		}
		
		public function set value(value : *) : void {
			hold = value;
			modifyTime = new Date();
			if(!createTime)
				createTime = modifyTime;
			readTime = modifyTime;
		}
	}
}