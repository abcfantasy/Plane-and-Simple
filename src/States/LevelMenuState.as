package States
{
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	import Managers.SettingsManager;
	import Managers.InputManager;
	
	public class LevelMenuState extends FlxState
	{
		[Embed(source = '../../assets/font1.png')] private var titleFont:Class;
		
		// text
		private var levelTexts:Array = new Array();
		
		// menu state
		private var selected:int = 1;
		
		// sort of "constructor"
		override public function create():void 
		{
			super.create();
			
			// create title
			var title:FlxBitmapFont = new FlxBitmapFont( titleFont, 31, 25, FlxBitmapFont.TEXT_SET2, 10, 1, 0 );
			title.scale.y = 1.3;
			title.text = "Plane And Simple";
			title.x = ( FlxG.width / 2 ) - ( title.width / 2 );
			title.y = 70;
			this.add( title );
			
			// create levels menu
			for ( var i:int = 1; i <= SettingsManager.Max_Level; i++ )
			{
				levelTexts.push( new FlxText( 20, 200 + ( i * 20 ), FlxG.width - 20, "Level " + i ) );
				levelTexts[i - 1].setFormat( null, 14, 0xFFFFFFFF, "center" );
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