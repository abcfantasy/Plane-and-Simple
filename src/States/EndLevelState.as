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
			this.add( Helpers.createText( 20, 50, FlxG.width - 20, "Level " + FlxG.level + " Complete!", 35, 0xFFFFFFFF, "center" ) );
			
			// create instructions (depending on whether replaying a level or playing a new level)
			var instructions:FlxText = new FlxText( 20, 150, FlxG.width - 20, "" );
			if ( FlxG.level == SettingsManager.Max_Level - 1 )
				this.add( Helpers.createText( 20, 150, FlxG.width - 20, "Press ENTER/SPACE to play next level or ESC to go back to level selection.", 24, 0xFFFFFFFF, "center" ) );
			else
				this.add( Helpers.createText( 20, 150, FlxG.width - 20, "Press ENTER/SPACE to replay the current level or ESC to go back to level selection.", 24, 0xFFFFFFFF, "center" ) );
			
			if (SettingsManager.Game_mode == SettingsManager.TIME_MODE)
			{
				// create current time		
				this.add( Helpers.createText( 20, 300, FlxG.width - 20, "Your Time: " + Helpers.timeToString( elapsed_ ), 28, 0xFFFFFF, "center" ) );
				
				// if best time exists, create it too
				var bestTime:Number = SettingsManager.loadLevelTime( FlxG.level );
				if ( bestTime > 0 )
				{
					this.add( Helpers.createText( 20, 340, FlxG.width - 20, "Best Time: " + Helpers.timeToString( bestTime ), 28, 0xFFFFFFFF, "center" ) );
				}
			}
			else
			{
				// create current points
				this.add( Helpers.createText( 20, 300, FlxG.width - 20, "Your Points: " + FlxG.points, 28, 0xFFFFFFFF, "center" ) );
			}
			FlxG.points = 0;
		}
		
		override public function update():void 
		{
			super.update();
			
			if ( InputManager.confirm() )
			{
				// if at the last level, go to new level
				if ( FlxG.level == SettingsManager.Max_Level - 1  && FlxG.level != SettingsManager.Last_Level )
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