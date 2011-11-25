package  
{
	import org.flixel.FlxEmitter;
	import org.flixel.FlxPoint;
	import org.flixel.FlxText;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	public class Helpers 
	{
		[Embed(source = '../assets/font1.png')] private static var titleFont:Class;
		[Embed(source = '../assets/unlearne.ttf', fontFamily = "mainFont", embedAsCFF = "false")] private static var mainFont:String;
		
		// creates title text
		public static function createTitleText() : FlxBitmapFont
		{
			var titleText:FlxBitmapFont = new FlxBitmapFont( titleFont, 31, 25, FlxBitmapFont.TEXT_SET2, 10, 1, 0 );
			titleText.scale.y = 1.3;
			titleText.text = "Plane And Simple";
			titleText.x = ( FlxG.width / 2 ) - ( titleText.width / 2 );
			titleText.y = 70;
			return titleText;
		}
		
		// creates a text
		public static function createText( x:int, y:int, width:int, text:String, size:int, color:uint, align:String, alpha:Number = 1.0 ) : FlxText
		{
			var newText:FlxText = new FlxText( x, y, width, text );
			newText.setFormat( "mainFont", size, color, align );
			newText.scrollFactor = new FlxPoint( 0, 0 );
			newText.alpha = alpha;
			return newText;
		}
		
		// creates an emitter
		// if particleSprite is null, it creates the sprites using width/height/color
		public static function createEmitter( particleSpeed:Number, particleDrag:Number, particlesCount:int, particlesSprite:Class=null, width:int=0, height:int=0, colors:Array=null ) : FlxEmitter
		{
			// create emitter object
			var newEmitter:FlxEmitter = new FlxEmitter();
			newEmitter.gravity = 0;
			newEmitter.minParticleSpeed = new FlxPoint( -particleSpeed, -particleSpeed );
			newEmitter.maxParticleSpeed = new FlxPoint( particleSpeed, particleSpeed );
			newEmitter.particleDrag = new FlxPoint( particleDrag, particleDrag );
			// create particles
			if ( particlesSprite == null ) {
				// add pixel particles
				for ( var i:int = 0; i < particlesCount; i++ ) {
					var particle:FlxSprite = new FlxSprite();
					particle.createGraphic(width, height, colors[i % colors.length]);
					newEmitter.add(particle);
				}
			}
			else {
				// add graphic particles
				for ( var j:int = 0; j < particlesCount; j++ ) {
					newEmitter.add( new particlesSprite() );
				}
			}
			return newEmitter;
		}
		
		// converts a time to a string incl. minutes, seconds & milliseconds
		public static function timeToString( time:Number ) : String
		{
			var minutes:Number = Math.round( time / 60000 );
			var seconds:Number = Math.round( time % 60000 / 1000 );
			var milliseconds:Number = Math.round( time % 60000 % 1000 );
			return (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds + ":" + ( milliseconds < 100 ? ( milliseconds < 10 ? "00" : "0") : "") + milliseconds;
		}
	}

}