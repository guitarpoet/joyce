package net.guitarpoet.joyce.pool {
	public interface PoolStrategy {
		function findEntryToRemove(entries : Array) : Entry;
	}
}