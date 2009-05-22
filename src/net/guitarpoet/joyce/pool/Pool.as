package net.guitarpoet.joyce.pool {
	import mx.controls.Alert;
	
	
	/**
	 *
	 * The simple pool for retrive and hold objects.
	 *  
	 * @author jack
	 * @since 05/20/09
	 * 
	 */
	public class Pool {
		private var _limit : int;
		
		protected var entries : Object;
		
		protected var strategy : PoolStrategy;
		
		protected var _disposer : Function;
		
		public function Pool(limit : int = 100, strategy : PoolStrategy = null) {
			entries = new Object();
			this._limit = limit;
			if(strategy == null)
				this.strategy = new LRUStrategy();
		}
		
		public function get capacity() : int {
			return items.length;
		}
		
		public function get limit() : int {
			return _limit;
		}
		
		public function set limit(limit : int) : void {
			for(var i : int = _limit; i < limit; i++){
				evict();
			}
			_limit = limit;
		}
		
		public function get disposer() : Function {
			return this._disposer;
		}
		
		public function set disposer(d : Function) : void {
			this._disposer = d;
		}
		
		public function has(name : String) : Boolean {
			return entries[name] is Entry;
		}
		
		public function getObject(name : String) : * {
			if(has(name)){
				return entries[name].value;
			}
			return null;
		}
		
		public function addObject(name : String, value : *, weight : int = 0) : void {
			var e : Entry = new Entry();
			e.name = name;
			e.value = value;
			e.weight = weight;
			if(capacity == limit)
				evict();
			this.entries[name] = e;
		}
		
		public function removeObject(name : String) : void {
			if(entries[name] is Entry){
				if(disposer != null)
					disposer(Entry(entries[name]).value);
				delete entries[name];
			}
		}
		
		public function get items() : Array {
			var items : Array = new Array();
			for(var p : String in entries){
				if(entries[p] is Entry){
					items.push(entries[p]);
				}
			}
			return items;
		}

		public function evict() : void {
			removeObject(strategy.findEntryToRemove(items).name);
		}
	}
}