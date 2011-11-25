package States
{
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	import Managers.SettingsManager;
	import Managers.InputManager;
	import Managers.SoundManager;
	
	public class LevelMenuState extends FlxState
	{		
		// text
		private var levelTexts:Array = new Array();
		
		// menu state
		private var selected:int = 1;
		
		// sort of "constructor"
		override public function create():void 
		{
			super.create();
			
			// play menu music
			SoundManager.MenuMusic();
			
			// create title
			this.add( Helpers.createTitleText() );
			
			// create levels menu
			for ( var i:int = 1; i <= SettingsManager.Max_Level; i++ )
			{
				levelTexts.push( Helpers.createText( 20, 200 + ( i * 20 ), FlxG.width - 20, "Level " + i, 25, 0xFFFFFFFF, "center", 0.5 ) );
				var bestTime:Number = SettingsManager.loadLevelTime( i );
				if ( bestTime != 0 ) {
					levelTexts[i - 1].text += " - Best time: " + Helpers.timeToString( bestTime );
				}
				this.add( levelTexts[i - 1] );
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			// set all dim
			for ( var i:int = 1; i <= SettingsManager.Max_Level; i++ )
			{
				levelTexts[i - 1].alpha = 0.5;
			}
			
			// highlight selected
			levelTexts[selected - 1].alpha = 1;
			
			// check input
			if ( InputManager.confirm() )
			{
				FlxG.level = selected;
				FlxG.score = 0;
				FlxG.state = new PlayState();
			}
			else if ( InputManager.down() )
			{
				if ( selected < SettingsManager.Max_Level )
					selected++;
			}
			else if ( InputManager.up() )
			{
				if ( selected > 1 )
					selected--;
			}
			else if ( InputManager.exit() )
			{
				FlxG.state = new MenuState();
			}
		}
	}
}