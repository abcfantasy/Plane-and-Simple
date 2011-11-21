package States
{
	import org.flixel.data.FlxAnim;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import Managers.InputManager;
	import Managers.SettingsManager;
	
	public class EndLevelState extends FlxState
	{
		private var elapsed_:Number;
		
		public function EndLevelState( elapsed:Number )
		{
			elapsed_ = elapsed;
		}
		
		override public function create():void 
		{
			super.create();
			
			// create level complete
			var levelComplete:FlxText = new FlxText( 20, 50, FlxG.width - 20, "Level " + FlxG.level + " Complete!" );
			levelComplete.setFormat( null, 25, 0xFFFFFFFF, "center" );
			this.add( levelComplete );
			
			// create instructions (depending on whether replaying a level or playing a new level)
			var instructions:FlxText = new FlxText( 20, 150, FlxG.width - 20, "" );
			if ( FlxG.level == SettingsManager.Max_Level - 1 )
				instructions.text = "Press ENTER/SPACE to play next level or ESC to go back to level selection.";
			else
				instructions.text = "Press ENTER/SPACE to replay the current level or ESC to go back to level selection.";
			instructions.setFormat( null, 14, 0xFFFFFFFF, "center" );
			this.add( instructions );
			
			// create current time			
			var time:FlxText = new FlxText( 20, 300, FlxG.width - 20, "" );
			var minutes:Number = Math.round( elapsed_ / 60 );
			var seconds:Number = Math.round( elapsed_ % 60 );
			time.text = "Your Time: " + (minutes < 10 ? "0":"") + minutes + ":" + (seconds < 10 ? "0":"") + seconds;
			time.setFormat( null, 18, 0xFFFFFFFF, "center" );
			this.add( time );
			
			// if best time exists, create it too
			var bestTime:Number = SettingsManager.loadLevelTime( FlxG.level );
			if ( bestTime > 0 )
			{
				var bestTimeText:FlxText = new FlxText( 20, 340, FlxG.width - 20, "" );
				var best_minutes:Number = Math.round( bestTime / 60 );
				var best_seconds:Number = Math.round( bestTime % 60 );
				bestTimeText.text = "Best Time: " + (best_minutes < 10 ? "0":"") + best_minutes + ":" + (best_seconds < 10 ? "0":"") + best_seconds;
				bestTimeText.setFormat( null, 18, 0xFFFFFFFF, "center" );
				this.add( bestTimeText );
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			if ( InputManager.confirm() )
			{
				// if at the last level, go to new level
				if ( FlxG.level == SettingsManager.Max_Level )
				{
					FlxG.level++;
					FlxG.state = new PlayState();
				}
				// otherwise replay level
				else
				{
					FlxG.state = new PlayState();
				}
			}
			else if ( InputManager.exit() )
			{
				FlxG.state = new LevelMenuState();
			}
		}
	}

}