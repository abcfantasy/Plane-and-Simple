package  
{
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxSprite;
	
	public class PlayState extends FlxState
	{
		[Embed(source = "../assets/map_prototype.csv", mimeType = "application/octet-stream")]public var mapString:Class;
		[Embed(source = "../assets/newTiles.png")]public var newTiles:Class;
		
		public var _world:b2World;
		private var p:Player;		// the player object
		private var c:Coin;			// TEST coin object

		private var groundMap:FlxTilemap = new FlxTilemap();
		private var emitter:FlxEmitter;

		// sort of "constructor"
		override public function create():void 
		{
			super.create();
			setupWorld();
			
			// create tilemap
			this.add( groundMap.loadMap( new mapString, newTiles, 23, 23 ) );
			FlxU.setWorldBounds( 0, 0, groundMap.width, groundMap.height );
			
			// set up emitter for coins
			emitter = new FlxEmitter( this.x, this.y );
			for ( var i:int = 0; i < 50; i++ )
			{
				var particle:FlxSprite = new FlxSprite();
				particle.createGraphic( 4, 4, 0xffffff00 );
				emitter.add( particle );
			}
			emitter.gravity = 0;
			
			emitter.minParticleSpeed.y = -150;
			emitter.maxParticleSpeed.y = 150;
			emitter.maxParticleSpeed.x = 150;
			emitter.minParticleSpeed.x = -150;
			emitter.particleDrag.x = 50;
			emitter.particleDrag.y = 150;
			this.add(emitter);
			
			this.add( p = new Player(100, 50, this, _world ) );		// add the player object
			this.add( c = new Coin( 300, 450, p, emitter ) );
			this.add( new Coin( 400, 370, p, emitter ) );
			this.add( new Coin( 500, 370, p, emitter ) ); 
		}
		
		private function setupWorld():void 
		{
			var gravity:b2Vec2 = new b2Vec2(0, 0); 
			_world = new b2World(gravity, false);
		}
		
		override public function update():void 
		{
			_world.Step(FlxG.elapsed, 10, 10);
			_world.DrawDebugData();
			
			FlxG.debug = true;
			if ( p.getLeftPlane().collide( groundMap ) )
				FlxG.log( "COLLIDE" );
			if ( p.getRightPlane().collide( groundMap ) )
				FlxG.log( "COLLIDE" );
			
			super.update();
			
			// boundaries
			/*
			leftPlane:B2FlxSprite = p.getLeftPlane();
			
			if ( leftPlane.x < 0 ) {
				leftPlane.x = 0;
			}
			else if ( (leftPlane.x + leftPlane.width) > groundMap.width ) {
				leftPlane.x = (FlxG.width - leftPlane.width)
			}
			
			if ( leftPlane.y < 0 ) {
				leftPlane.y = 0;
			}
			else if ( (leftPlane.y + leftPlane.height ) > FlxG.height ) {
				leftPlane.y = (FlxG.height - leftPlane.height )
			}
			
			if ( player2.x < 0 ) {
				player2.x = 0;
			}
			else if ( (player2.x + player2.width) > FlxG.width ) {
				player2.x = (FlxG.width - player2.width)
			}
			
			if ( player2.y < 0 ) {
				player2.y = 0;
			}
			else if ( (player2.y + player2.height ) > FlxG.height ) {
				player2.y = (FlxG.height - player2.height )
			}*/
		}
	}

}