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
	import org.flixel.FlxObject;
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
		private var boundaries:FlxTilemapExt = new FlxTilemapExt();
		private var emitterCoin:FlxEmitter; 		// Picking-up Coin
		private var emitterJewel:FlxEmitter;		// Picking-up Jewel
		private var emitterExplosion:FlxEmitter;	// Plane explosion
		private var cameraPivot:FlxObject = new FlxObject();
		
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
			
			// play game music
			SoundManager.GameMusic();
			
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
			
			boundaries = LevelManager.getBoundaries(groundMap.widthInTiles, groundMap.heightInTiles);
			this.add(boundaries);
			
			// Score texts
			if (SettingsManager.Game_mode == SettingsManager.TIME_MODE)
			{
				// Coin Game-mode
				this.add( coinsText = Helpers.createText( 5, 5, 250, "Coins left: 0", 20, 0xFFFFFFFF, "left" ) );
			}
			else
			{
				// Point Game-mode
				this.add( pointsText = Helpers.createText( 5, 5, 150, "Points: 0", 20, 0xFFFFFFFF, "left" ) );
			}
			
			// create time text
			if (SettingsManager.Game_mode == SettingsManager.TIME_MODE)
				this.add( timeText = Helpers.createText( FlxG.width - 150, 5, 145, "0:00:000", 20, 0xFFFFFFFF, "left" ) );
			else
				this.add( timeText = Helpers.createText( FlxG.width - 180, 5, 175, "Time left 0:20", 20, 0xFFFFFFFF, "left" ) );
			
			// Sets up the Player
			var playerPos:FlxPoint = LevelManager.getPlayerPosition(FlxG.level);
			p = new Player(playerPos.x, playerPos.y, this, _world, 1);
			this.add(p); // add the player object
			
			
			// set up emitter for exploding planes
			this.add( emitterExplosion = Helpers.createEmitter( 75, 45, 30, null, 3, 3, [0xFFFF0000, 0xFFFFFF00, 0xFFFF8C00] ) );
			
			// set up emitter for coins
			this.add( emitterCoin = Helpers.createEmitter( 150, 150, 50, null, 4, 4, [0xFFFFFF00] ) );
			
			// get coins for level
			coinList = LevelManager.getCoins(FlxG.level);
			coinsRemaining = coinList.length;
			if(SettingsManager.Game_mode == SettingsManager.TIME_MODE)
				coinsText.text = "Coins Remaining: " + coinsRemaining;
			
			for (var l:int = 0; l < coinList.length; l++)
				this.add(new Coin(coinList[l].x, coinList[l].y, p, emitterCoin, onCoinTaken));
			
			if (SettingsManager.Game_mode == SettingsManager.POINT_MODE) {
				// set up emitter for jewels
				this.add( emitterJewel = Helpers.createEmitter( 150, 30, 100, null, 3, 3, [0xFFEE2222] ) );
				
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
		
		override public function update():void
		{
			super.update();

			// update and check for coins remaining
			if(SettingsManager.Game_mode == SettingsManager.TIME_MODE)
				coinsText.text = "Coins left: " + coinsRemaining;
			else
				pointsText.text = "Points: " + FlxG.points;
			
			stringElasticityBar.setValue( p.getRopeLengthPercentage() );
			
			// WIN
			if ( ( SettingsManager.Game_mode == SettingsManager.TIME_MODE && coinsRemaining == 0 ) ||
				 ( SettingsManager.Game_mode == SettingsManager.POINT_MODE && (coinsRemaining + jewelsRemaining) == 0) ||
				 ( SettingsManager.Game_mode == SettingsManager.POINT_MODE && (timeLeft - Math.round(elapsedTime / 1000) <= 0) ) )
			{
				endLevel();
			}
			else
			{	
				// update elapsed time and text
				elapsedTime += FlxG.elapsed * 1000;
				if(SettingsManager.Game_mode == SettingsManager.TIME_MODE)
					timeText.text = Helpers.timeToString( elapsedTime );
				else 
					timeText.text = "Time left: " + ( timeLeft - Math.round(elapsedTime / 1000) );
				
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
					
					cameraPivot.x = p.getCenter().x;
					cameraPivot.y = p.getCenter().y;
					
					if (cameraPivot.x <= 400)
						cameraPivot.x = 400;
					else if (cameraPivot.x >= groundMap.width - 400)
						cameraPivot.x = groundMap.width - 400;
					if (cameraPivot.y <= 250)
						cameraPivot.y = 250;
					else if (cameraPivot.y >= groundMap.height - 250)
						cameraPivot.y = groundMap.height - 250;
					
					FlxG.follow(cameraPivot, 1); 
					
					// checks collision with the groundMap
					for (var j:uint = 0; j < planes.length; j++)
					{
						if (groundMap.solveSlopeCollide(groundMap, planes[j]) > 0) // the function returns the index of the tile (from the .csv file)
						{	
							// play explosion animation
							var explosion:FlxSprite = new FlxSprite( planes[j].x, planes[j].y );
							explosion.loadGraphic( explosionImage, true, false, 30, 30 );
							explosion.addAnimation( "explode", [0, 1, 2, 3], 15, true );
							this.add(explosion);
							explosion.play( "explode" );
							// shake screen
							FlxG.quake.start( 0.01, 0.2 );
							// emit exploding particles
							emitterExplosion.at(planes[j]);
							emitterExplosion.start(true, 2);
							planes[j].kill();
							FlxG.stage.removeChild( p.getRope() );
							SoundManager.Explosion();
							planeDestroyed = true;
						}
					}
					
					stringElasticityBar.x = ( FlxG.width / 2 ) - 75 - FlxG.scroll.x;
					stringElasticityBar.y = 5 - FlxG.scroll.y;
					
					// check boundaries 
					// Note: must check each plane independently for each boundary, to handle the case where
					// both planes are at the boundary
					for (var i:uint = 0; i < planes.length; i++)
					{
						if (boundaries.solveSlopeCollide(boundaries, planes[i]) >= 1)
							planes[i]._obj.SetLinearVelocity( new b2Vec2( -planes[i]._obj.GetLinearVelocity().x*0.2, planes[i]._obj.GetLinearVelocity().y*0.2));
						if (boundaries.solveSlopeCollide(boundaries, planes[i]) == 3)
							planes[i]._obj.SetPosition(new b2Vec2(planes[i]._obj.GetPosition().x + 0.05, planes[i]._obj.GetPosition().y));
						else if (boundaries.solveSlopeCollide(boundaries, planes[i]) == 2)
							planes[i]._obj.SetPosition(new b2Vec2(planes[i]._obj.GetPosition().x - 0.05, planes[i]._obj.GetPosition().y));
						else if (boundaries.solveSlopeCollide(boundaries, planes[i]) == 1)
							planes[i]._obj.SetPosition(new b2Vec2(planes[i]._obj.GetPosition().x, planes[i]._obj.GetPosition().y + 0.05));
						else if (boundaries.solveSlopeCollide(boundaries, planes[i]) == 4)
							planes[i]._obj.SetPosition(new b2Vec2(planes[i]._obj.GetPosition().x, planes[i]._obj.GetPosition().y - 0.05));
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
				if ( FlxG.level == SettingsManager.Max_Level && FlxG.level != SettingsManager.Last_Level )
					SettingsManager.Max_Level++;
				
				// save level
				SettingsManager.saveLevelTime( FlxG.level, elapsedTime );
				
				// go to end level state
				FlxG.state = new EndLevelState(elapsedTime);
			}
		}
	}
}