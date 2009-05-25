package net.guitarpoet.joyce.pool {
	public class LRUStrategy implements PoolStrategy {
		public function findEntryToRemove(entries:Array):Entry {
			var e : Entry = null;
			for each(var entry : Entry in entries){
				if(e == null || e.readTime > entry.readTime){
					e = entry;
				}
			}
			return e;
		}
	}
}