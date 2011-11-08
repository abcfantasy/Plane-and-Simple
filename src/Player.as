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
	
	public class Player extends FlxObject
	{
		// images of the planes
		[Embed(source = "../assets/left2.png")]public var leftPlaneImage:Class;
		[Embed(source = "../assets/right2.png")]public var rightPlaneImage:Class;
		//[Embed(source = "../assets/left.png")]public var leftPlaneImage:Class;
		//[Embed(source = "../assets/right.png")]public var rightPlaneImage:Class;
		
		// sprite objects
		private var playerLeft:B2FlxSprite;
		private var playerRight:B2FlxSprite;
		
		// distance joint
		private var jointDef:b2DistanceJointDef = new b2DistanceJointDef();
		private var joint:b2DistanceJoint;
		// debugDraw can draw all the invisible physics stuff, such as joints, bodies, shapes, centres of mass etc.
		private var dbgDraw:b2DebugDraw = new b2DebugDraw();
		// A sprite is required for debugDraw
		private var dbgSprite:Sprite = new Sprite();
		// Temp vectors for impulse-movement and position
		private var leftImpulse:b2Vec2 = new b2Vec2(0, 0);
		private var rightImpulse:b2Vec2 = new b2Vec2(0, 0);
		private var leftPosition:b2Vec2 = new b2Vec2(0, 0);
		private var rightPosition:b2Vec2 = new b2Vec2(0, 0);

		// constants
		protected static const PLAYER_IMPULSE_FORCE:int = 2;
		protected static const STRING_DISTANCE:int = 4; // Meters, i.e. 120 pixels
		protected static const PLAYER_MAX_VELOCITY:int = 150;
		
		private function CreateString(_world:b2World):void
		{
			// The distance joint is initialized. _obj refers to the bodies of the player sprites
			jointDef.Initialize(playerLeft._obj, playerRight._obj, playerLeft._anchor, playerRight._anchor);
			jointDef.collideConnected = true;
			joint = _world.CreateJoint(jointDef) as b2DistanceJoint;
			// Frequency and damping ratio can changes the physical properties of the string. These values should be fine-tuned at some point
			joint.SetDampingRatio(0.5);
			joint.SetFrequency(1);
			joint.SetLength(STRING_DISTANCE);
			
			FlxG.stage.addChild(dbgSprite);
			dbgDraw.SetSprite(dbgSprite);
			// 30 is used as drawScale, since box2D per default uses a ratio of 30, i.e. 30 pixels = 1 meter
			dbgDraw.SetDrawScale(30.0);
			dbgDraw.SetAlpha(1);
			dbgDraw.SetFillAlpha(0.3);
			dbgDraw.SetLineThickness(1.0);
			
			// Here we specify which physics we want debugDraw to draw
			dbgDraw.SetFlags(/*b2DebugDraw.e_shapeBit | */b2DebugDraw.e_jointBit);
			_world.SetDebugDraw(dbgDraw);
		}

		public function Player( x:int, y:int, parent:FlxState, _world:b2World) 
		{		
			playerLeft = new B2FlxSprite(x - 40, y, 20, _world);
			playerRight = new B2FlxSprite(x + 40, y, 20, _world);
			playerLeft.createBody();
			playerRight.createBody();
			playerLeft.loadGraphic(leftPlaneImage, false, false, 40, 40);
			playerRight.loadGraphic(rightPlaneImage, false, false, 40, 40);
			
			// This bool is enabled by default, so the call below will disable it
			//playerRight.toggleBodyFollowsSprite();
			
			CreateString(_world);
					
			// add the planes to the parent game state
			parent.add( playerLeft );
			parent.add( playerRight );
			
			super( x, y );
		}
		
		private function updateLeftPlane():void
		{
			// movement-flag
			var flag:Boolean = false;
			// linear velocity is calculated - used for angle-direction and drag
			var linVel:b2Vec2 = playerLeft._obj.GetLinearVelocity();
			
			// position of sprite is set to the body's position
			leftPosition.x = (playerLeft._obj.GetPosition().x * 30) - playerLeft._radius;
			leftPosition.y = (playerLeft._obj.GetPosition().y * 30) - playerLeft._radius;
			
			// impulse vector is reset, to avoid e.g. applied y-force, when only x-force is desired
			leftImpulse.SetZero();
			
			// keys input
			// an impulse in the corresponding direction is stored in the leftImpulse vector
			if ( FlxG.keys.RIGHT )		// right direction
			{
				flag = true;
				leftImpulse.x = PLAYER_IMPULSE_FORCE;
			}
			if ( FlxG.keys.LEFT )		// left direction
			{
				flag = true;
				leftImpulse.x = -PLAYER_IMPULSE_FORCE;
			}
			if ( FlxG.keys.UP )			// up direction
			{
				flag = true;
				leftImpulse.y = -PLAYER_IMPULSE_FORCE;
			}
			if ( FlxG.keys.DOWN )		// down direction
			{
				flag = true;
				leftImpulse.y = PLAYER_IMPULSE_FORCE;
			}
			
			// when no key is pressed, the impulse is set to the opposite of its current direction and velocity, to slow it down
			if(!flag)
			{
				leftImpulse.x = -(linVel.x);
				leftImpulse.y = -(linVel.y);
				
			}
			// finally, leftImpulse containing the impulse based on what happened above, is applied to the body of the player object
			playerLeft._obj.ApplyImpulse(leftImpulse, leftPosition);
			// ... and the angle is set for which way the object is turning.
			playerLeft._obj.SetAngle(Math.atan2(linVel.y, linVel.x));
		}
		
		private function updateRightPlane():void
		{
			var linVel:b2Vec2 = playerRight._obj.GetLinearVelocity();
			var flag:Boolean = false;
			
			rightPosition.x = (playerRight._obj.GetPosition().x * 30) - playerRight._radius;
			rightPosition.y = (playerRight._obj.GetPosition().y * 30) - playerRight._radius;
			
			rightImpulse.SetZero();
			
			// keys input
			if ( FlxG.keys.D )		// right direction
			{
				flag = true;
				rightImpulse.x = PLAYER_IMPULSE_FORCE;
			}
			
			if ( FlxG.keys.A )		// left direction
			{
				flag = true;
				rightImpulse.x = -PLAYER_IMPULSE_FORCE;
			}
			if ( FlxG.keys.W )		// up direction
			{
				flag = true;
				rightImpulse.y = -PLAYER_IMPULSE_FORCE;	
			}
			if ( FlxG.keys.S )		// down direction
			{
				flag = true;
				rightImpulse.y = PLAYER_IMPULSE_FORCE;
			}
			
			if(!flag)
			{
				rightImpulse.x = -(linVel.x);
				rightImpulse.y = -(linVel.y);
				
			}
			playerRight._obj.ApplyImpulse(rightImpulse, rightPosition);
			playerRight._obj.SetAngle(Math.atan2(linVel.y, linVel.x));
		}
		
		public function getLeftPlaneCoord():Point
		{
			return new Point(this.playerLeft.x, this.playerLeft.y);
		}
		
		public function getRightPlaneCoord():Point
		{
			return new Point(this.playerRight.x, this.playerRight.y);
		}
		
		public function getLeftPlane():B2FlxSprite
		{
			return this.playerLeft;
		}
		public function getRightPlane():B2FlxSprite
		{
			return this.playerRight;
		}
		
		override public function update():void 
		{
			updateLeftPlane();
			updateRightPlane();
			if (playerLeft._obj.GetLinearVelocity().LengthSquared() > PLAYER_MAX_VELOCITY)
			{
				var velLeft:b2Vec2 = playerLeft._obj.GetLinearVelocity();
				velLeft.Multiply(PLAYER_MAX_VELOCITY / playerLeft._obj.GetLinearVelocity().LengthSquared())
				playerLeft._obj.SetLinearVelocity(velLeft);
			}
			if (playerRight._obj.GetLinearVelocity().LengthSquared() > PLAYER_MAX_VELOCITY)
			{
				var velRight:b2Vec2 = playerRight._obj.GetLinearVelocity();
				velRight.Multiply(PLAYER_MAX_VELOCITY / playerRight._obj.GetLinearVelocity().LengthSquared())
				playerRight._obj.SetLinearVelocity(velRight);
			}
			playerLeft.angle = playerLeft._angle;
			playerRight.angle = playerRight._angle;
			super.update();
		}
	}

}