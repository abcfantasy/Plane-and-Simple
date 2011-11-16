package
{
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import org.flixel.FlxObject;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxPoint;
	
	public class PlayState extends FlxState
	{
		
		public var _world:b2World; // The Game World
		private var p:Player; // The Player
		
		private var groundMap:FlxTilemap = new FlxTilemap();
		private var emitter:FlxEmitter; // coin taking
		private var explosionEmitter:FlxEmitter; // exploding planes
		private var scoreText:FlxText;
		private var levelText:FlxText;
		
		private var planeDestroyed:Boolean = false; // flag determining whether the plane collided
		private var resetCounter:Number = 0; 		// counter for delay after plane is destroyed
		
		// sort of "constructor"
		override public function create():void
		{
			// FOR TESTING
			FlxG.level = 1;
			
			super.create();
			setupWorld();
			
			// create level background
			this.add( LevelManager.getBackgroundImage( FlxG.level ) );
			
			// create level tilemap
			groundMap = LevelManager.getTileMap( FlxG.level );
			this.add(groundMap);
			FlxU.setWorldBounds(0, 0, groundMap.width, groundMap.height);
			
			// create score text
			scoreText = new FlxText(5, 5, 150, "Score: 0");
			scoreText.setFormat(null, 8, 0xFFFFFFFF, "left");
			scoreText.scrollFactor = new FlxPoint(0, 0);
			this.add(scoreText);
			
			// create level text
			levelText = new FlxText(FlxG.width - 155, 5, 150, "Level: " + FlxG.level);
			levelText.setFormat(null, 8, 0xFFFFFFFF, "right");
			levelText.scrollFactor = new FlxPoint(0, 0);
			this.add(levelText);
			
			// set up emitter for coins
			emitter = new FlxEmitter(this.x, this.y);
			for (var j:int = 0; j < 50; j++)
			{
				var particle:FlxSprite = new FlxSprite();
				particle.createGraphic(4, 4, 0xffffff00);
				emitter.add(particle);
			}
			emitter.gravity = 0;
			emitter.minParticleSpeed.y = -150;
			emitter.maxParticleSpeed.y = 150;
			emitter.maxParticleSpeed.x = 150;
			emitter.minParticleSpeed.x = -150;
			emitter.particleDrag.x = 50;
			emitter.particleDrag.y = 150;
			this.add(emitter);
			
			// set up emitter for exploding planes
			explosionEmitter = new FlxEmitter(this.x, this.y);
			for (var i:int = 0; i < 50; i++)
			{
				var explosionParticle:FlxSprite = new FlxSprite();
				explosionParticle.createGraphic(3, 3, 0xFFFF0000);
				explosionEmitter.add(explosionParticle);
			}
			explosionEmitter.gravity = 0;
			explosionEmitter.minParticleSpeed.y = -200;
			explosionEmitter.maxParticleSpeed.y = 200;
			explosionEmitter.maxParticleSpeed.x = 200;
			explosionEmitter.minParticleSpeed.x = -200;
			explosionEmitter.particleDrag.x = 60;
			explosionEmitter.particleDrag.y = 60;
			this.add(explosionEmitter);
			
			p = new Player(200, 50, this, _world, 1);
			this.add(p); // add the player object
			
			// get coins for level
			var coinList:Array = LevelManager.getCoins( FlxG.level );
			for ( var k:int = 0; k < coinList.length; k++ )
			{
				this.add( new Coin( coinList[k].x, coinList[k].y, p, emitter ) );
			}
		}
		
		private function setupWorld():void
		{
			var gravity:b2Vec2 = new b2Vec2(0, 0);
			_world = new b2World(gravity, false);
		}
		
		private function forceLeftBoundary(plane:B2FlxSprite):void
		{
			// get body of the correct plane
			var planeBody:b2Body = plane._obj;
			
			// apply boundary physics
			planeBody.ApplyImpulse(new b2Vec2(-(planeBody.GetLinearVelocity().x), 0), new b2Vec2((planeBody.GetPosition().x * 30) - plane._radius, (planeBody.GetPosition().y * 30) - plane._radius));
			
			planeBody.SetPosition(new b2Vec2(0.73, planeBody.GetPosition().y));
		}
		
		private function forceRightBoundary(plane:B2FlxSprite):void
		{
			// get body of the correct plane
			var planeBody:b2Body = plane._obj;
			
			// apply boundary physics
			planeBody.ApplyImpulse(new b2Vec2(-(planeBody.GetLinearVelocity().x), 0), new b2Vec2((planeBody.GetPosition().x * 30) - plane._radius, (planeBody.GetPosition().y * 30) - plane._radius));
			
			planeBody.SetPosition(new b2Vec2((groundMap.width - 2) / 30, planeBody.GetPosition().y));
		}
		
		private function forceTopBoundary(plane:B2FlxSprite):void
		{
			// get body of the plane
			var planeBody:b2Body = plane._obj;
			
			// aply boundary physics
			planeBody.ApplyImpulse(new b2Vec2(0, -(planeBody.GetLinearVelocity().y)), new b2Vec2((planeBody.GetPosition().x * 30) - plane._radius, (planeBody.GetPosition().y * 30) - plane._radius));
			
			planeBody.SetPosition(new b2Vec2(planeBody.GetPosition().x, 0.73));
		}
		
		private function forceBottomBoundary(plane:B2FlxSprite):void
		{
			// get body of the plane
			var planeBody:b2Body = plane._obj;
			
			// aply boundary physics
			planeBody.ApplyImpulse(new b2Vec2(0, -(planeBody.GetLinearVelocity().y)), new b2Vec2((planeBody.GetPosition().x * 30) - plane._radius, (planeBody.GetPosition().y * 30) - plane._radius));
			
			planeBody.SetPosition(new b2Vec2(planeBody.GetPosition().x, (groundMap.height - 2) / 30));
		}
		
		override public function update():void
		{
			super.update();
			
			if (planeDestroyed)
			{
				resetCounter += FlxG.elapsed;
				if ( resetCounter >= 4 )
					FlxG.state = new PlayState();
			}
			else
			{
				_world.Step(FlxG.elapsed, 10, 10);
				_world.DrawDebugData();
				
				// update score
				scoreText.text = "Score: " + FlxG.score;
				
				var planes:Array = [p.getLeftPlane(), p.getRightPlane()];
				
				// checks collision with the groundMap
				for (var j:uint = 0; j < planes.length; j++)
				{
					if (groundMap.overlaps(planes[j]))
					{	
						explosionEmitter.at(planes[j]);
						explosionEmitter.start(true, 2);
						planes[j].kill();
						FlxG.stage.removeChild( p.getRope() );
						SoundManager.Explosion();
						planeDestroyed = true;
					}
				}
				
				// check boundaries 
				// Note: must check each plane independently for each boundary, to handle the case where
				// both planes are at the boundary
				for (var i:uint = 0; i < planes.length; i++)
				{
					if (planes[i].x <= 1)
						forceLeftBoundary(planes[i]);
					if (planes[i].x >= groundMap.width - planes[i]._radius - 1)
						forceRightBoundary(planes[i]);
					if (planes[i].y <= 1)
						forceTopBoundary(planes[i]);
					if (planes[i].y >= groundMap.height - planes[i]._radius - 1)
						forceBottomBoundary(planes[i]);
				}
			}
		}
	}
}