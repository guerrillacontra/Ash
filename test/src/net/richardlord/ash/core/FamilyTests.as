package net.richardlord.ash.core
{
	import asunit.framework.IAsync;

	import org.hamcrest.assertThat;
	import org.hamcrest.collection.emptyArray;
	import org.hamcrest.collection.hasItem;
	import org.hamcrest.object.nullValue;
	import org.hamcrest.object.sameInstance;

	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class FamilyTests
	{
		[Inject]
		public var async : IAsync;
		
		private var game : Game;
		
		[Before]
		public function createEntity() : void
		{
			game = new Game();
		}

		[After]
		public function clearEntity() : void
		{
			game = null;
		}

		[Test]
		public function testFamilyIsInitiallyEmpty() : void
		{
			var nodes : NodeList = game.getFamily( MockNode );
			assertThat( nodes.head, nullValue() );
		}

		[Test]
		public function testNodeContainsEntityProperties() : void
		{
			var entity : Entity = new Entity();
			var point : Point = new Point();
			var matrix : Matrix = new Matrix();
			entity.add( point );
			entity.add( matrix );
			
			var nodes : NodeList = game.getFamily( MockNode );
			game.addEntity( entity );
			assertThat( nodes.head.point, sameInstance( point ) );
			assertThat( nodes.head.matrix, sameInstance( matrix ) );
		}

		[Test]
		public function testCorrectEntityAddedToFamilyWhenAccessFamilyFirst() : void
		{
			var entity : Entity = new Entity();
			entity.add( new Point() );
			entity.add( new Matrix() );
			var nodes : NodeList = game.getFamily( MockNode );
			game.addEntity( entity );
			assertThat( nodes.head.entity, sameInstance( entity ) );
		}

		[Test]
		public function testCorrectEntityAddedToFamilyWhenAccessFamilySecond() : void
		{
			var entity : Entity = new Entity();
			entity.add( new Point() );
			entity.add( new Matrix() );
			game.addEntity( entity );
			var nodes : NodeList = game.getFamily( MockNode );
			assertThat( nodes.head.entity, sameInstance( entity ) );
		}

		[Test]
		public function testCorrectEntityAddedToFamilyWhenComponentsAdded() : void
		{
			var entity : Entity = new Entity();
			game.addEntity( entity );
			var nodes : NodeList = game.getFamily( MockNode );
			entity.add( new Point() );
			entity.add( new Matrix() );
			assertThat( nodes.head.entity, sameInstance( entity ) );
		}
		
		[Test]
		public function testIncorrectEntityNotAddedToFamilyWhenAccessFamilyFirst() : void
		{
			var entity : Entity = new Entity();
			var nodes : NodeList = game.getFamily( MockNode );
			game.addEntity( entity );
			assertThat( nodes.head, nullValue() );
		}
		
		[Test]
		public function testIncorrectEntityNotAddedToFamilyWhenAccessFamilySecond() : void
		{
			var entity : Entity = new Entity();
			game.addEntity( entity );
			var nodes : NodeList = game.getFamily( MockNode );
			assertThat( nodes.head, nullValue() );
		}

		[Test]
		public function testEntityRemovedFromFamilyWhenComponentRemovedAndFamilyAlreadyAccessed() : void
		{
			var entity : Entity = new Entity();
			entity.add( new Point() );
			entity.add( new Matrix() );
			game.addEntity( entity );
			var nodes : NodeList = game.getFamily( MockNode );
			entity.remove( Point );
			assertThat( nodes.head, nullValue() );
		}

		[Test]
		public function testEntityRemovedFromFamilyWhenComponentRemovedAndFamilyNotAlreadyAccessed() : void
		{
			var entity : Entity = new Entity();
			entity.add( new Point() );
			entity.add( new Matrix() );
			game.addEntity( entity );
			entity.remove( Point );
			var nodes : NodeList = game.getFamily( MockNode );
			assertThat( nodes.head, nullValue() );
		}

		[Test]
		public function testEntityRemovedFromFamilyWhenRemovedFromGameAndFamilyAlreadyAccessed() : void
		{
			var entity : Entity = new Entity();
			entity.add( new Point() );
			entity.add( new Matrix() );
			game.addEntity( entity );
			var nodes : NodeList = game.getFamily( MockNode );
			game.removeEntity( entity );
			assertThat( nodes.head, nullValue() );
		}

		[Test]
		public function testEntityRemovedFromFamilyWhenRemovedFromGameAndFamilyNotAlreadyAccessed() : void
		{
			var entity : Entity = new Entity();
			entity.add( new Point() );
			entity.add( new Matrix() );
			game.addEntity( entity );
			game.removeEntity( entity );
			var nodes : NodeList = game.getFamily( MockNode );
			assertThat( nodes.head, nullValue() );
		}

		[Test]
		public function familyContainsOnlyMatchingEntities() : void
		{
			var entities : Array = new Array();
			for( var i : int = 0; i < 5; ++i )
			{
				var entity : Entity = new Entity();
				entity.add( new Point() );
				entity.add( new Matrix() );
				entities.push( entity );
				game.addEntity( entity );
			}
			
			var nodes : NodeList = game.getFamily( MockNode );
			var node : MockNode;
			for( node = nodes.head; node; node = node.next )
			{
				assertThat( entities, hasItem( node.entity ) );
			}
		}

		[Test]
		public function familyContainsAllMatchingEntities() : void
		{
			var entities : Array = new Array();
			for( var i : int = 0; i < 5; ++i )
			{
				var entity : Entity = new Entity();
				entity.add( new Point() );
				entity.add( new Matrix() );
				entities.push( entity );
				game.addEntity( entity );
			}
			
			var nodes : NodeList = game.getFamily( MockNode );
			var node : MockNode;
			for( node = nodes.head; node; node = node.next )
			{
				var index : int = entities.indexOf( node.entity );
				entities.splice( index, 1 );
			}
			assertThat( entities, emptyArray() );
		}
		
		[Test]
		public function addingNodeTriggersAddedSignal() : void
		{
			var nodes : NodeList = new NodeList();
			var node : MockNode = new MockNode();
			nodes.nodeAdded.add( async.add() );
			nodes.add( node );
		}
		
		[Test]
		public function removingNodeTriggersRemovedSignal() : void
		{
			var nodes : NodeList = new NodeList();
			var node : MockNode = new MockNode();
			nodes.add( node );
			nodes.nodeRemoved.add( async.add() );
			nodes.remove( node );
		}
		
		private var tempNode : Node;
		
		[Test]
		public function componentAddedSignalContainsCorrectParameters() : void
		{
			var nodes : NodeList = new NodeList();
			tempNode = new MockNode();
			nodes.nodeAdded.add( async.add( testSignalContent, 10 ) );
			nodes.add( tempNode );
		}
		
		[Test]
		public function componentRemovedSignalContainsCorrectParameters() : void
		{
			var nodes : NodeList = new NodeList();
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
		public function releaseFamilyEmptiesNodeList() : void
		{
			var entity : Entity = new Entity();
			entity.add( new Point() );
			entity.add( new Matrix() );
			game.addEntity( entity );
			game.removeEntity( entity );
			var nodes : NodeList = game.getFamily( MockNode );
			game.releaseFamily( MockNode );
			assertThat( nodes.head, nullValue() );
		}

		[Test]
		public function releaseFamilySetsNextNodeToNull() : void
		{
			var entities : Array = new Array();
			for( var i : int = 0; i < 5; ++i )
			{
				var entity : Entity = new Entity();
				entity.add( new Point() );
				entity.add( new Matrix() );
				entities.push( entity );
				game.addEntity( entity );
			}
			
			var nodes : NodeList = game.getFamily( MockNode );
			var node : MockNode = nodes.head.next;
			game.releaseFamily( MockNode );
			assertThat( node.next, nullValue() );
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