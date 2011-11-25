package States
{
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	import Managers.SettingsManager;
	import Managers.InputManager;
	import Managers.SoundManager;
	
	public class MenuState extends FlxState
	{
		
		// text
		private var startGame:FlxText;
		private var controller:FlxText;
		private var playermode:FlxText;
		private var gameMode:FlxText;
		
		// menu state
		private var selected:int = 0;
		private var maxOptions:int = 4;		// total options
		
		// sort of "constructor"
		override public function create():void 
		{
			super.create();
			
			// play menu music
			SoundManager.MenuMusic();
			
			// create title
			this.add( Helpers.createTitleText() );
			
			// show start game option
			this.add( startGame = Helpers.createText( 20, 220, FlxG.width - 20, "Start Game", 30, 0xFFFFFFFF, "center" ) );
			
			// show controller options
			this.add( controller = Helpers.createText( 20, 250, FlxG.width - 20, "Controller: " + SettingsManager.getGameControllerString(), 30, 0xFFFFFFFF, "center", 0.5 ) );
			
			// show single/multiplayer options
			this.add( playermode = Helpers.createText( 20, 280, FlxG.width - 20, "Player Mode: " + SettingsManager.getPlayerModeString(), 30, 0xFFFFFFFF, "center", 0.5 ) );
			
			// show game mode
			this.add( gameMode = Helpers.createText( 20, 310, FlxG.width - 20, "Game Mode: " + SettingsManager.getGameModeString(), 30, 0xFFFFFFFF, "center", 0.5 ) );
			
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
					case 2:
						SettingsManager.togglePlayerMode();
						break;
					case 3:
						SettingsManager.toggleGameMode();
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
					playermode.alpha = 0.5;
					gameMode.alpha = 0.5;
					break;
				case 1:
					startGame.alpha = 0.5;
					controller.alpha = 1;
					playermode.alpha = 0.5;
					gameMode.alpha = 0.5;
					break;
				case 2:
					startGame.alpha = 0.5;
					controller.alpha = 0.5;
					playermode.alpha = 1;
					gameMode.alpha = 0.5;
					break;
				case 3:
					startGame.alpha = 0.5;
					controller.alpha = 0.5;
					playermode.alpha = 0.5;
					gameMode.alpha = 1;
					break;
			}
			
			// update text
			controller.text = "Controller: " + SettingsManager.getGameControllerString();
			playermode.text = "Player Mode: " + SettingsManager.getPlayerModeString();
			gameMode.text = "Game Mode: " + SettingsManager.getGameModeString();
			
		}
	}

}