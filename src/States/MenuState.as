package States
{
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	import Managers.SettingsManager;
	import Managers.InputManager;
	
	public class MenuState extends FlxState
	{
		[Embed(source = '../../assets/font1.png')] private var titleFont:Class;
		
		// text
		private var startGame:FlxText;
		private var controller:FlxText;
		
		// menu state
		private var selected:int = 0;
		private var maxOptions:int = 3;		// total options
		
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
			
			// show start game option
			startGame = new FlxText( 20, 220, FlxG.width - 20, "Start Game" );
			startGame.setFormat( null, 14, 0xFFFFFFFF, "center" );
			this.add( startGame );
			
			// show controller options
			controller = new FlxText( 20, 240, FlxG.width - 20, "Controller: " + SettingsManager.getGameControllerString() );
			controller.setFormat( null, 14, 0xFFFFFFFF, "center" );
			controller.alpha = 0.5;
			this.add( controller );
			
		}
		
		override public function update():void 
		{
			super.update();
			
			// check input
			if ( InputManager.confirm() )
			{
				switch ( selected )
				{
					case 0:
						FlxG.state = new LevelMenuState();
						break;
					case 1:
						SettingsManager.toggleController();
						break;
				}
			}
			else if ( InputManager.down() )
			{
				if ( selected < maxOptions - 1 )
					selected++;
			}
			else if ( InputManager.up() )
			{
				if ( selected > 0 )
					selected--;
			}
			
			// update menu selection
			switch ( selected )
			{
				case 0:
					startGame.alpha = 1;
					controller.alpha = 0.5;
					break;
				case 1:
					startGame.alpha = 0.5;
					controller.alpha = 1;
					break;
			}
			
			// update text
			controller.text = "Controller: " + SettingsManager.getGameControllerString();
			
		}
	}

}