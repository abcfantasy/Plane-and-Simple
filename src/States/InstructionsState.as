package States 
{
	import Objects.Coin;
	import Objects.Jewel;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxG;
	import Managers.InputManager;
	
	public class InstructionsState extends FlxState
	{
		// images of the planes
		[Embed(source = "../../assets/graphics/plane2_left_animated.png")]public var rightPlaneImage:Class;
		[Embed(source = "../../assets/graphics/plane2_right_animated.png")]public var leftPlaneImage:Class;
		[Embed(source = "../../assets/graphics/tiles_simple_image.png")]public var tileImage:Class;
		// image of rope
		[Embed(source = "../../assets/graphics/string.png")]public var ropeImage:Class;
		
		
		override public function create():void 
		{
			super.create();
			
			// create title
			this.add( Helpers.createTitleImage() );
			
			// add planes
			this.add( Helpers.createText( 80, 160, FlxG.width - 20, "Control this with arrow keys or right analog stick (Xbox)", 18, 0xFFFFFFFF, "left" ) );
			this.add( new FlxSprite( 20, 150 ).loadGraphic( leftPlaneImage, false, false, 40, 40 ) );
			
			this.add( Helpers.createText( 80, 195, FlxG.width - 20, "Control this with WASD keys or left analog stick (Xbox)", 18, 0xFFFFFFFF, "left" ) );
			this.add( new FlxSprite( 20, 185 ).loadGraphic( rightPlaneImage, false, false, 40, 40 ) );
			
			// add coin
			this.add ( Helpers.createText( 80, 230, FlxG.width - 20, "Gather these coins", 18, 0xFFFFFFFF, "left" ) );
			this.add( new Coin( 35, 233, null, null, null ) );
			
			// add jewel
			this.add( Helpers.createText( 80, 265, FlxG.width - 20, "Gather these jewels in point-based mode for additional points", 18, 0xFFFFFFFF, "left" ) );
			this.add( new Jewel( 35, 265, null, null, null ) );
			
			// add tile
			this.add( Helpers.createText( 80, 300, FlxG.width - 20, "Don''t crash on this with the planes", 18, 0xFFFFFFFF, "left" ) );
			this.add( new FlxSprite( 27, 295, tileImage ) );
			
			// add string
			this.add( Helpers.createText( 200, 335, FlxG.width - 220, "The string connects the 2 planes, and is used to gather coins/jewels", 18, 0xFFFFFFFF, "left" ) );
			var rope:FlxSprite = new FlxSprite( -210, 355, ropeImage );
			rope.scale.x = 0.2;
			this.add( rope );
			
			// add stretch bar
			this.add( Helpers.createText( 200, 390, FlxG.width - 220, "This bar shows how stretched the string is", 18, 0xFFFFFFFF, "left" ) );
			var stringElasticityBar:SimpleBar = new SimpleBar( 25, 390, 150, 20, 0, 120 );
			stringElasticityBar.createGradientBar( [0xFF000000, 0xFF000000], [0x99FF0000, 0x99FFFF00, 0x9900FF00, 0x99FFFF00, 0x99FF0000], 1, 180, true, 0xFFFFFFFF );
			stringElasticityBar.setValue( 50 );
			this.add(stringElasticityBar);
			
			// lockdown
			this.add( Helpers.createText( 120, 425, FlxG.width - 140, "Activate lockdown mode by holding SHIFT and R key or LB and RB (Xbox). In this mode, the plane will not be dragged by the other if the string stretches too much.", 18, 0xFFFFFFFF, "left" ) );
			var playerLeft:FlxSprite = new FlxSprite(20, 430);
			var playerRight:FlxSprite = new FlxSprite(60, 430);
			playerLeft.loadGraphic(leftPlaneImage, true, false, 40, 40);
			playerRight.loadGraphic(rightPlaneImage, true, false, 40, 40);
			playerLeft.addAnimation( "lockdown", [1, 2, 3, 4], 10, true );
			playerRight.addAnimation( "lockdown", [1, 2, 3, 4], 10, true );
			playerLeft.play( "lockdown" );
			playerRight.play( "lockdown" );
			this.add( playerLeft );
			this.add( playerRight );
		}
		
		override public function update():void 
		{
			super.update();
			
			if ( InputManager.exit() )
			{
				FlxG.state = new MenuState();
			}
		}
	}

}