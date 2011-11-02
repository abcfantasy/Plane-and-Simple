package  
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2JointDef;
	import Box2D.Common.Math.b2Vec2;
	import flash.display.Sprite;
	import flash.geom.Point;
	import org.flixel.FlxObject;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.plugin.photonstorm.FlxExtendedSprite;
	
	/*
	 * Note about drag: Drag in flixel automatically decelerates an object ONLY when 
	 * there is no acceleration. Therefore, if object is moving to the left, and player
	 * accelerates to the right, the object should first slow down according to the 
	 * "rightwards" acceleration + drag acceleration. This drag needs to be added
	 * manually. - Andrew
	 */
	public class Player extends FlxObject
	{
		// images of the planes
		[Embed(source = "../assets/left.png")]public var leftPlaneImage:Class;
		[Embed(source = "../assets/right.png")]public var rightPlaneImage:Class;
		
		// sprite objects
		private var playerLeft:B2FlxSprite;
		private var playerRight:B2FlxSprite;
		
		// distance joint
		private var jointDef:b2DistanceJointDef = new b2DistanceJointDef();
		// debugDraw can draw all the invisible physics stuff, such as joints, bodies, shapes, centres of mass etc.
		private var dbgDraw:b2DebugDraw = new b2DebugDraw();
		// A sprite is required for debugDraw
		private var dbgSprite:Sprite = new Sprite();

		// constants
		protected static const PLAYER_RUN_SPEED:int = 300;
		protected static const STRING_DISTANCE:int = 80;
		
		private function CreateString(_world:b2World):void
		{
			// The distance joint is initialized. _obj refers to the bodies of the player sprites
			jointDef.Initialize(playerLeft._obj, playerRight._obj, playerLeft._anchor, playerRight._anchor);
			_world.CreateJoint(jointDef);
			// Frequency and damping ratio can changes the physical properties of the string. These values should be fine-tuned at some point
			jointDef.frequencyHz = 4;
			jointDef.dampingRatio = 0.5;
			
			FlxG.stage.addChild(dbgSprite);
			dbgDraw.SetSprite(dbgSprite);
			// 30 is used as drawScale, since box2D per default uses a ratio of 30, i.e. 30 pixels = 1 meter
			dbgDraw.SetDrawScale(30.0);
			dbgDraw.SetAlpha(1);
			dbgDraw.SetFillAlpha(0.3);
			dbgDraw.SetLineThickness(1.0);
			
			// Here we specify which physics we want debugDraw to draw
			dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			_world.SetDebugDraw(dbgDraw);
		}

		public function Player( x:int, y:int, parent:FlxState, _world:b2World) 
		{
			// create the plane sprites
			//playerLeft = new FlxSprite( x - 40, y, leftPlaneImage );
			//playerRight = new FlxSprite( x + 40, y, rightPlaneImage );
			
			playerLeft = new B2FlxSprite(x - 40, y, 40, 40, _world);
			playerRight = new B2FlxSprite(x + 40, y, 40, 40, _world);
			playerLeft.createBody();
			playerRight.createBody();
			playerLeft.loadGraphic(leftPlaneImage, false, false, 40, 40);
			playerRight.loadGraphic(rightPlaneImage, false, false, 40, 40);
			
			CreateString(_world);
			
			// set the drag and maximum velocity of left plane
			playerLeft.drag.x = PLAYER_RUN_SPEED * 1.5;
			playerLeft.drag.y = PLAYER_RUN_SPEED * 1.5;
			playerLeft.maxVelocity.x = 300;
			playerLeft.maxVelocity.y = 300;
			
			// set the drag and maximum velocity of right plane
			playerRight.drag.x = PLAYER_RUN_SPEED * 1.5;
			playerRight.drag.y = PLAYER_RUN_SPEED * 1.5;
			playerRight.maxVelocity.x = 300;
			playerRight.maxVelocity.y = 300;
			
			// add the planes to the parent game state
			parent.add( playerLeft );
			parent.add( playerRight );
			
			super( x, y );
		}
		
		private function updateLeftPlane():void
		{
			// reset acceleration every frame
			playerLeft.acceleration.x = 0;
			playerLeft.acceleration.y = 0;
			
			// keys input
			if ( FlxG.keys.RIGHT )		// right direction
			{
				if ( playerLeft.velocity.x < 0 )		// if moving left, add drag to acceleration (note above)
					playerLeft.acceleration.x = PLAYER_RUN_SPEED + playerLeft.drag.x;
				else
					playerLeft.acceleration.x = PLAYER_RUN_SPEED;
			}
			if ( FlxG.keys.LEFT )		// left direction
			{
				if ( playerLeft.velocity.x > 0 )
					playerLeft.acceleration.x = -PLAYER_RUN_SPEED - playerLeft.drag.x;
				else
					playerLeft.acceleration.x = -PLAYER_RUN_SPEED;
			}
			if ( FlxG.keys.UP )			// up direction
			{
				if ( playerLeft.velocity.y > 0 )
					playerLeft.acceleration.y = -PLAYER_RUN_SPEED - playerLeft.drag.y;
				else
					playerLeft.acceleration.y = -PLAYER_RUN_SPEED;		
			}
			if ( FlxG.keys.DOWN )		// down direction
			{
				if ( playerLeft.velocity.y < 0 )
					playerLeft.acceleration.y = PLAYER_RUN_SPEED + playerLeft.drag.y;
				else
					playerLeft.acceleration.y = PLAYER_RUN_SPEED;
			}
		}
		
		private function updateRightPlane():void
		{
			// reset acceleration every frame
			playerRight.acceleration.x = 0;
			playerRight.acceleration.y = 0;
			
			// keys input
			if ( FlxG.keys.D )		// right direction
			{
				if ( playerRight.velocity.x < 0 )
					playerRight.acceleration.x = PLAYER_RUN_SPEED + playerRight.drag.x;
				else
					playerRight.acceleration.x = PLAYER_RUN_SPEED;
			}
			
			if ( FlxG.keys.A )		// left direction
			{
				if ( playerRight.velocity.x > 0 )
					playerRight.acceleration.x = -PLAYER_RUN_SPEED - playerRight.drag.x;
				else
					playerRight.acceleration.x = -PLAYER_RUN_SPEED;
			}
			if ( FlxG.keys.W )		// up direction
			{
				if ( playerRight.velocity.y > 0 )
					playerRight.acceleration.y = -PLAYER_RUN_SPEED - playerRight.drag.y;
				else
					playerRight.acceleration.y = -PLAYER_RUN_SPEED;		
			}
			if ( FlxG.keys.S )		// down direction
			{
				if ( playerRight.velocity.y < 0 )
					playerRight.acceleration.y = PLAYER_RUN_SPEED + playerRight.drag.y;
				else
					playerRight.acceleration.y = PLAYER_RUN_SPEED;
			}
		}
		
		public function getLeftPlaneCoord():Point
		{
			return new Point(this.playerLeft.x, this.playerLeft.y);
		}
		
		public function getRightPlaneCoord():Point
		{
			return new Point(this.playerRight.x, this.playerRight.y);
		}
		
		override public function update():void 
		{
			updateLeftPlane();
			updateRightPlane();
			super.update();
		}
	}

}