package States
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Managers.*;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	
	public class PlayState extends FlxState
	{
		
		public var _world:b2World; // The Game World
		private var p:Player; // The Player
		
		private var groundMap:FlxTilemapExt = new FlxTilemapExt();
		private var emitter:FlxEmitter; // coin taking
		private var jewelEmitter:FlxEmitter;
		private var explosionEmitter:FlxEmitter; // exploding planes
		
		// text
		//private var scoreText:FlxText;
		private var coinsText:FlxText;
		private var timeText:FlxText;
		
		private var coinList:Array;
		private var coinsRemaining:Number = 0; // number of remaining coins in the level
		private var elapsedTime:Number = 0; // elapsed time since starting the level
		private var planeDestroyed:Boolean = false; // flag determining whether the plane collided
		private var resetCounter:Number = 0; // counter for delay after plane is destroyed
		private var endCounter:Number = 0; // counter for delay after all coins taken
		
		// sort of "constructor"
		override public function create():void
		{
			super.create();
			setupWorld();
			
			// create level background
			this.add(LevelManager.getBackgroundImage(FlxG.level));
			
			// create level tilemap
			groundMap = LevelManager.getTileMap(FlxG.level);
			this.add(groundMap);
			groundMap.collideIndex = 2;
			FlxU.setWorldBounds(0, 0, groundMap.width, groundMap.height);
			
			// create score text
			/*
			   scoreText = new FlxText(5, 20, 150, "Score: 0");
			   scoreText.setFormat(null, 12, 0xFFFFFFFF, "left");
			   scoreText.scrollFactor = new FlxPoint(0, 0);
			   this.add(scoreText);
			 */
			// create coins remaining text
			coinsText = new FlxText(5, 5, 150, "Coins Remaining: 0");
			coinsText.setFormat(null, 12, 0xFFFFFFFF, "left");
			coinsText.scrollFactor = new FlxPoint(0, 0);
			this.add(coinsText);
			
			// create time text
			timeText = new FlxText(FlxG.width - 155, 5, 150, "0:00");
			timeText.setFormat(null, 12, 0xFFFFFFFF, "right");
			timeText.scrollFactor = new FlxPoint(0, 0);
			this.add(timeText);
			
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
			
			// set up emitter for jewels
			jewelEmitter = new FlxEmitter(this.x, this.y);
			for (var j:int = 0; j < 100; j++)
			{
				var particle:FlxSprite = new FlxSprite();
				particle.createGraphic(3, 3, 0xffee2222);
				jewelEmitter.add(particle);
			}
			jewelEmitter.gravity = 0;
			jewelEmitter.minParticleSpeed.y = -250;
			jewelEmitter.maxParticleSpeed.y = 250;
			jewelEmitter.maxParticleSpeed.x = 250;
			jewelEmitter.minParticleSpeed.x = -250;
			jewelEmitter.particleDrag.x = 30;
			jewelEmitter.particleDrag.y = 30;
			this.add(jewelEmitter);
			
			// set up emitter for exploding planes
			explosionEmitter = new FlxEmitter(this.x, this.y);
			var explosionColors:Array = [0xFFFF0000, 0xFFFFFF00, 0xFFFF8C00]
			for (var i:int = 0; i < 50; i++)
			{
				var explosionParticle:FlxSprite = new FlxSprite();
				explosionParticle.createGraphic(3, 3, explosionColors[i % explosionColors.length]);
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
			var playerPos:FlxPoint = LevelManager.getPlayerPosition(FlxG.level);
			p = new Player(playerPos.x, playerPos.y, this, _world, 1);
			this.add(p); // add the player object
			
			// get coins for level
			coinList = LevelManager.getCoins(FlxG.level);
			coinsRemaining = coinList.length;
			coinsText.text = "Coins Remaining: " + coinsRemaining;
			
			for (var k:int = 0; k < coinList.length; k++)
			{
				this.add(new Coin(coinList[k].x, coinList[k].y, p, emitter, onCoinTaken));
			}
			
			// get jewels for level
			var jewelList:Array = LevelManager.getjewels( FlxG.level );
			for ( var k:int = 0; k < jewelList.length; k++ )
			{
				this.add( new Jewel( jewelList[k].x, jewelList[k].y, p, jewelEmitter ) );
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
			
			// update elapsed time and text
			elapsedTime += FlxG.elapsed;
			var minutes:Number = Math.round(elapsedTime / 60);
			var seconds:Number = Math.round(elapsedTime % 60);
			timeText.text = (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
			
			// update and check for coins remaining
			coinsText.text = "Coins Remaining: " + coinsRemaining;
			
			// WIN
			if (coinsRemaining == 0)
				endLevel();
			else
			{					
				// LOSE
				if (planeDestroyed)
				{
					resetCounter += FlxG.elapsed;
					if (resetCounter >= 4)
						FlxG.state = new PlayState();
				}
				// PLAY
				else
				{
					_world.Step(FlxG.elapsed, 10, 80);
					_world.DrawDebugData();

					// check input
					if ( InputManager.exit() ) {
						FlxG.stage.removeChild(p.getRope());
						FlxG.state = new LevelMenuState();
					}
				
					var planes:Array = [p.getLeftPlane(), p.getRightPlane()];
					
					// checks collision with the groundMap
					for (var j:uint = 0; j < planes.length; j++)
					{
						if (groundMap.solveSlopeCollide(groundMap, planes[j]))
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
		
		private function onCoinTaken(coin:Coin):void
		{
			// deduct coins remaining
			this.coinsRemaining--;
			
			// emit particles
			emitter.at(coin);
			emitter.start(true, 0.5, 10);
			
			// play coin
			SoundManager.TakeCoin();
			
			// add score
			FlxG.score++;
			
			// kill coin
			coin.kill();
		}
		
		private function endLevel():void
		{
			endCounter += FlxG.elapsed;
			if (endCounter >= 1)
			{
				// remove graphics
				FlxG.stage.removeChild(p.getRope());
				
				// if it was latest level, include new level
				if ( FlxG.level == SettingsManager.Max_Level )
					SettingsManager.Max_Level++;
				
				// go to end level state
				FlxG.state = new EndLevelState(elapsedTime);
			}
		}
	}
}