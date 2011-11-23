package States
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Managers.*;
	import Objects.*;
	import GamePads.*;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	import org.flixel.plugin.photonstorm.FlxHealthBar;
	
	public class PlayState extends FlxState
	{
		// image of explosion (animation)
		[Embed(source = "../../assets/graphics/explosion_animated.png")] public var explosionImage:Class;
		
		public var _world:b2World; // The Game World
		private var p:Player; // The Player
		
		private var groundMap:FlxTilemapExt = new FlxTilemapExt();
		private var emitterCoin:FlxEmitter; 		// Picking-up Coin
		private var emitterJewel:FlxEmitter;		// Picking-up Jewel
		private var emitterExplosion:FlxEmitter;	// Plane explosion
		
		// text
		//private var scoreText:FlxText;
		private var coinsText:FlxText;
		private var pointsText:FlxText;
		private var timeText:FlxText;
		
		private var coinList:Array;
		private var coinsRemaining:Number = 0; // number of remaining coins in the level
		private var jewelsRemaining:Number = 0; // number of remaining jewels in the level
		private var elapsedTime:Number = 0; // elapsed time since starting the level
		private var planeDestroyed:Boolean = false; // flag determining whether the plane collided
		private var resetCounter:Number = 0; // counter for delay after plane is destroyed
		private var endCounter:Number = 0; // counter for delay after all coins taken
		private var timeLeft:uint = 20;
		
		private var stringElasticityBar:SimpleBar;
		//private var stringElasticityText:FlxText;
		
		// sort of "constructor"
		override public function create():void
		{
			super.create();
			setupWorld();
			
			// set xbox controller if enabled
			if ( SettingsManager.Game_Controller == SettingsManager.XBOX )
				XBOX360Manager.getInstance().connect();
				
			// create level background
			this.add(LevelManager.getBackgroundImage(FlxG.level));
			
			// create level tilemap
			groundMap = LevelManager.getTileMap(FlxG.level);
			this.add(groundMap);
			groundMap.collideIndex = 2;
			FlxU.setWorldBounds(0, 0, groundMap.width, groundMap.height);
			
			// Score texts
			if (FlxG.mode == 1)
			{
				// Coin Game-mode
				coinsText = new FlxText(5, 5, 150, "Coins Remaining: 0");
				coinsText.setFormat(null, 12, 0xFFFFFFFF, "left");
				coinsText.scrollFactor = new FlxPoint(0, 0);
				this.add(coinsText);
			}
			else
			{
				// Point Game-mode
				pointsText = new FlxText(5, 5, 150, "Points: 0");
				pointsText.setFormat(null, 12, 0xFFFFFFFF, "left");
				pointsText.scrollFactor = new FlxPoint(0, 0);
				this.add(pointsText);
			}
			
			// create time text
			if(FlxG.mode == 1)
				timeText = new FlxText(FlxG.width - 80, 5, 100, "0:00:000");
			else
				timeText = new FlxText(FlxG.width - 110, 5, 150, "Time left 0:20");
			timeText.setFormat(null, 12, 0xFFFFFFFF, "left");
			timeText.scrollFactor = new FlxPoint(0, 0);
			this.add(timeText);
			
			// Sets up the Player
			var playerPos:FlxPoint = LevelManager.getPlayerPosition(FlxG.level);
			p = new Player(playerPos.x, playerPos.y, this, _world, 1);
			this.add(p); // add the player object
			
			// set up emitter for exploding planes
			emitterExplosion = new FlxEmitter(this.x, this.y);
			var explosionColors:Array = [0xFFFF0000, 0xFFFFFF00, 0xFFFF8C00]
			for (var i:int = 0; i < 30; i++)
			{
				var explosionParticle:FlxSprite = new FlxSprite();
				explosionParticle.createGraphic(3, 3, explosionColors[i % explosionColors.length]);
				emitterExplosion.add(explosionParticle);
			}
			emitterExplosion.gravity = 0;
			emitterExplosion.minParticleSpeed.y = -75;
			emitterExplosion.maxParticleSpeed.y = 75;
			emitterExplosion.maxParticleSpeed.x = 75;
			emitterExplosion.minParticleSpeed.x = -75;
			emitterExplosion.particleDrag.x = 45;
			emitterExplosion.particleDrag.y = 45;
			this.add(emitterExplosion);
			
			// set up emitter for coins
			emitterCoin = new FlxEmitter(this.x, this.y);
			for (var j:int = 0; j < 50; j++)
			{
				var particle:FlxSprite = new FlxSprite();
				particle.createGraphic(4, 4, 0xffffff00);
				emitterCoin.add(particle);
			}
			emitterCoin.gravity = 0;
			emitterCoin.minParticleSpeed.y = -150;
			emitterCoin.maxParticleSpeed.y = 150;
			emitterCoin.maxParticleSpeed.x = 150;
			emitterCoin.minParticleSpeed.x = -150;
			emitterCoin.particleDrag.x = 50;
			emitterCoin.particleDrag.y = 150;
			this.add(emitterCoin);
			
			// get coins for level
			coinList = LevelManager.getCoins(FlxG.level);
			coinsRemaining = coinList.length;
			if(FlxG.mode == 1)
				coinsText.text = "Coins Remaining: " + coinsRemaining;
			
			for (var l:int = 0; l < coinList.length; l++)
				this.add(new Coin(coinList[l].x, coinList[l].y, p, emitterCoin, onCoinTaken));
			
			if (FlxG.mode == 2) {
				// set up emitter for jewels
				emitterJewel = new FlxEmitter(this.x, this.y);
				for (var k:int = 0; k < 100; k++)
				{
					var particle2:FlxSprite = new FlxSprite();
					particle2.createGraphic(3, 3, 0xffee2222);
					emitterJewel.add(particle2);
				}
				emitterJewel.gravity = 0;
				emitterJewel.minParticleSpeed.y = -150;
				emitterJewel.maxParticleSpeed.y = 150;
				emitterJewel.maxParticleSpeed.x = 150;
				emitterJewel.minParticleSpeed.x = -150;
				emitterJewel.particleDrag.x = 30;
				emitterJewel.particleDrag.y = 30;
				this.add(emitterJewel);
				
				// get jewels for level
				var jewelList:Array = LevelManager.getjewels( FlxG.level );
				jewelsRemaining = jewelList.length;
				for ( var m:int = 0; m < jewelList.length; m++ )
					this.add( new Jewel( jewelList[m].x, jewelList[m].y, p, emitterJewel, onJewelTaken ) );
			}
			// set up string stress bar
			stringElasticityBar = new SimpleBar( ( FlxG.width / 2 ) - 75, 5, 150, 20, 0, 120 );
			stringElasticityBar.createGradientBar( [0xFF000000, 0xFF000000], [0x99FF0000, 0x99FFFF00, 0x9900FF00, 0x99FFFF00, 0x99FF0000], 1, 180, true, 0xFFFFFFFF );
			this.add(stringElasticityBar);
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
			
			planeBody.SetPosition(new b2Vec2((groundMap.width - plane._radius) / 30, planeBody.GetPosition().y));
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
			
			planeBody.SetPosition(new b2Vec2(planeBody.GetPosition().x, (groundMap.height - plane._radius - 1) / 30));
		}
		
		override public function update():void
		{
			super.update();

			// update and check for coins remaining
			if(FlxG.mode == 1)
				coinsText.text = "Coins Remaining: " + coinsRemaining;
			else
				pointsText.text = "Points: " + FlxG.points;
			
			stringElasticityBar.setValue( p.getRopeLengthPercentage() );
			
			// WIN
			if (FlxG.mode == 1 && coinsRemaining == 0)
				endLevel();
			else if (FlxG.mode == 2 && (coinsRemaining + jewelsRemaining) == 0)
				endLevel();
			else if (FlxG.mode == 2 && (timeLeft - seconds <= 0))
				endLevel();
			else
			{	
				// update elapsed time and text
				elapsedTime += FlxG.elapsed * 1000;
				var minutes:Number = Math.round(elapsedTime / 60000 );
				var seconds:Number = Math.round(elapsedTime % 60000 / 1000);
				var milliseconds:Number = Math.round(elapsedTime % 60000 % 1000);
				if(FlxG.mode == 1)
					timeText.text = (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds + ":" + ( milliseconds < 100 ? ( milliseconds < 10 ? "00" : "0") : "") + milliseconds;
				else 
					timeText.text = "Time left: " + (timeLeft-seconds);
				
				// LOSE
				if (planeDestroyed)
				{
					FlxG.points = 0;
					resetCounter += FlxG.elapsed;
					if (resetCounter >= 1.5)
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
							// play explosion animation
							var explosion:FlxSprite = new FlxSprite( planes[j].x, planes[j].y );
							explosion.loadGraphic( explosionImage, true, false, 30, 30 );
							explosion.addAnimation( "explode", [0, 1, 2, 3], 15, true );
							this.add(explosion);
							explosion.play( "explode" );
							emitterExplosion.at(planes[j]);
							emitterExplosion.start(true, 2);
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
						if (planes[i].x >= (groundMap.width - planes[i]._radius - 1))
							forceRightBoundary(planes[i]);
						if (planes[i].y <= 1)
							forceTopBoundary(planes[i]);
						if (planes[i].y >= (groundMap.height - planes[i]._radius - 1))
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
			emitterCoin.at(coin);
			emitterCoin.start(true, 0.5, 10);
			
			// play coin
			SoundManager.TakeCoin();
			
			// add score
			FlxG.score++;
			
			FlxG.points++;
			
			timeLeft += 2;
			
			// kill coin
			coin.kill();
		}
		
		private function onJewelTaken(jewel:Jewel):void
		{
			jewelsRemaining--;
			emitterJewel.at(jewel);
			emitterJewel.start(true, 0.5, 10);
			FlxG.points += 5;
			timeLeft += 10;
			jewel.kill();
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
				
				// save level
				SettingsManager.saveLevelTime( FlxG.level, elapsedTime );
				
				// go to end level state
				FlxG.state = new EndLevelState(elapsedTime);
			}
		}
	}
}