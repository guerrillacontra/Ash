package net.richardlord.ash.core
{
	import asunit.framework.IAsync;

	import net.richardlord.ash.matchers.nodeList;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.sameInstance;
	
	public class NodeListTests
	{
		[Inject]
		public var async : IAsync;
		
		private var nodes : NodeList;
		
		[Before]
		public function createEntity() : void
		{
			nodes = new NodeList();
		}

		[After]
		public function clearEntity() : void
		{
			nodes = null;
		}

		[Test]
		public function addingNodeTriggersAddedSignal() : void
		{
			var node : MockNode = new MockNode();
			nodes.nodeAdded.add( async.add() );
			nodes.add( node );
		}
		
		[Test]
		public function removingNodeTriggersRemovedSignal() : void
		{
			var node : MockNode = new MockNode();
			nodes.add( node );
			nodes.nodeRemoved.add( async.add() );
			nodes.remove( node );
		}
		
		private var tempNode : Node;
		
		[Test]
		public function componentAddedSignalContainsCorrectParameters() : void
		{
			tempNode = new MockNode();
			nodes.nodeAdded.add( async.add( testSignalContent, 10 ) );
			nodes.add( tempNode );
		}
		
		[Test]
		public function componentRemovedSignalContainsCorrectParameters() : void
		{
			tempNode = new MockNode();
			nodes.add( tempNode );
			nodes.nodeRemoved.add( async.add( testSignalContent, 10 ) );
			nodes.remove( tempNode );
		}
		
		private function testSignalContent( signalNode : Node ) : void
		{
			assertThat( signalNode, sameInstance( tempNode ) );
		}
		
		[Test]
		public function nodesInitiallySortedInOrderOfAddition() : void
		{
			var node1 : MockNode = new MockNode();
			var node2 : MockNode = new MockNode();
			var node3 : MockNode = new MockNode();
			nodes.add( node1 );
			nodes.add( node2 );
			nodes.add( node3 );
			assertThat( nodes, nodeList( node1, node2, node3 ) );
		}
		
		[Test]
		public function swappingOnlyTwoNodesChangesTheirOrder() : void
		{
			var node1 : MockNode = new MockNode();
			var node2 : MockNode = new MockNode();
			nodes.add( node1 );
			nodes.add( node2 );
			nodes.swap( node1, node2 );
			assertThat( nodes, nodeList( node2, node1 ) );
		}
		
		[Test]
		public function swappingAdjacentNodesChangesTheirPositions() : void
		{
			var node1 : MockNode = new MockNode();
			var node2 : MockNode = new MockNode();
			var node3 : MockNode = new MockNode();
			var node4 : MockNode = new MockNode();
			nodes.add( node1 );
			nodes.add( node2 );
			nodes.add( node3 );
			nodes.add( node4 );
			nodes.swap( node2, node3 );
			assertThat( nodes, nodeList( node1, node3, node2, node4 ) );
		}
		
		[Test]
		public function swappingNonAdjacentNodesChangesTheirPositions() : void
		{
			var node1 : MockNode = new MockNode();
			var node2 : MockNode = new MockNode();
			var node3 : MockNode = new MockNode();
			var node4 : MockNode = new MockNode();
			var node5 : MockNode = new MockNode();
			nodes.add( node1 );
			nodes.add( node2 );
			nodes.add( node3 );
			nodes.add( node4 );
			nodes.add( node5 );
			nodes.swap( node2, node4 );
			assertThat( nodes, nodeList( node1, node4, node3, node2, node5 ) );
		}
		
		[Test]
		public function swappingEndNodesChangesTheirPositions() : void
		{
			var node1 : MockNode = new MockNode();
			var node2 : MockNode = new MockNode();
			var node3 : MockNode = new MockNode();
			nodes.add( node1 );
			nodes.add( node2 );
			nodes.add( node3 );
			nodes.swap( node1, node3 );
			assertThat( nodes, nodeList( node3, node2, node1 ) );
		}
	}
}

import net.richardlord.ash.core.Node;

import flash.geom.Matrix;
import flash.geom.Point;
class MockNode extends Node
{
	public var point : Point;
	public var matrix : Matrix;
}