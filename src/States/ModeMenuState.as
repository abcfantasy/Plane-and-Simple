package States
{
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	import Managers.SettingsManager;
	import Managers.InputManager;
	
	public class ModeMenuState extends FlxState
	{
		[Embed(source = '../../assets/font1.png')] private var titleFont:Class;
		
		// text
		private var modeTexts:Array = new Array();
		
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
			
			// create modes menu

			modeTexts.push( new FlxText( 20, 200 + ( 20 ), FlxG.width - 20, "Normal-mode" ) );
			modeTexts.push( new FlxText( 20, 200 + ( 40 ), FlxG.width - 20, "Pointbased-mode" ) );
			for (var i:int = 0; i < 2; i++)
			{
				modeTexts[i].setFormat( null, 14, 0xFFFFFFFF, "center" );
				this.add( modeTexts[i] );
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			// set all dim
			modeTexts[0].alpha = 0.5;
			modeTexts[1].alpha = 0.5;
			
			// highlight selected
			modeTexts[selected - 1].alpha = 1;
			
			// check input
			if ( InputManager.confirm() )
			{
				FlxG.mode = selected;
				FlxG.state = new LevelMenuState();
			}
			else if ( InputManager.down() )
			{
				if ( selected == 1 )
					selected++;
			}
			else if ( InputManager.up() )
			{
				if ( selected == 2 )
					selected--;
			}
			else if ( InputManager.exit() )
			{
				FlxG.state = new MenuState();
			}
		}
	}
}