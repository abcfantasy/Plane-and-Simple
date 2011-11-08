package  
{
	import Box2D.Collision.Shapes.b2MassData;
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
		
		private var massNormal:Number = 10.0;
		private var massLockDown:Number = 2000.0;

		// constants
		protected static const PLAYER_IMPULSE_FORCE:int = 2;
		protected static const STRING_DISTANCE:int = 120;
		//protected static const STRING_MAX_DISTANCE:int = 125;
		protected static const PLAYER_MAX_VELOCITY:int = 150;
		
		private function CreateString(_world:b2World):void
		{
			// The distance joint is initialized. _obj refers to the bodies of the player sprites
			jointDef.Initialize(playerLeft._obj, playerRight._obj, playerLeft._anchor, playerRight._anchor);
			jointDef.collideConnected = true;
			joint = _world.CreateJoint(jointDef) as b2DistanceJoint;
			// Frequency and damping ratio can changes the physical properties of the string. These values should be fine-tuned at some point
			joint.SetDampingRatio(0.1);
			joint.SetFrequency(0.0);
			joint.SetLength(STRING_DISTANCE/30);
			
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
		
		private function updatePlane(position:b2Vec2, impulse:b2Vec2, player:B2FlxSprite, keys:Array):void 
		{
			// Flags
			var movement:Boolean = false;
			var lockdown:Boolean = false;
			
			// linear velocity is calculated - used for angle-direction and drag
			var linVel:b2Vec2 = player._obj.GetLinearVelocity();
			
			// position of sprite is set to the body's position
			position.x = (player._obj.GetPosition().x * 30) - player._radius;
			position.y = (player._obj.GetPosition().y * 30) - player._radius;
			
			// impulse vector is reset, to avoid e.g. applied y-force, when only x-force is desired
			impulse.SetZero();
			
			// keys input
			// an impulse in the corresponding direction is stored in the impulse vector
			if ( keys[4] )		// lockdown
			{
				//var prevAngle:Number = player.angle;
				lockdown = true;
				player._massData.mass = massLockDown;
				player._obj.SetMassData(player._massData);
				player._obj.SetLinearVelocity(new b2Vec2(0, 0));
				//player.angle = prevAngle;
			}
			else
			{	
				if ( keys[0] )		// right direction
				{
					movement = true;
					impulse.x = PLAYER_IMPULSE_FORCE;
				}
				if ( keys[1] )		// left direction
				{
					movement = true;
					impulse.x = -PLAYER_IMPULSE_FORCE;
				}
				if ( keys[2] )		// up direction
				{
					movement = true;
					impulse.y = -PLAYER_IMPULSE_FORCE;
				}
				if ( keys[3] )		// down direction
				{
					movement = true;
					impulse.y = PLAYER_IMPULSE_FORCE;
				}
				// Since there's no lockdown, the mass is set to be normal again
				player._massData.mass = massNormal;
				player._obj.SetMassData(player._massData);
			}
			
			// If no movement, the impulse is set to the inverted velocity, to slow it down
			if(!movement)
			{
				impulse.x = -(linVel.x);
				impulse.y = -(linVel.y);
			}
			else
			{
				// Here the ship should be emitting exhaust!
			}
			
			// The resulting impulse is applied to the body of the player object
			player._obj.ApplyImpulse(impulse, position);
			// The angle is set for which way the object is turning.
			player._obj.SetAngle(Math.atan2(linVel.y, linVel.x));
			player.angle = player._angle;
			// Lastly, the maximum velocity is capped.
			if (linVel.LengthSquared() > PLAYER_MAX_VELOCITY)
			{
				var scaleVector:b2Vec2 = linVel;
				scaleVector.Multiply(PLAYER_MAX_VELOCITY / linVel.LengthSquared());
				player._obj.SetLinearVelocity(scaleVector);
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
			updatePlane(leftPosition, leftImpulse, playerLeft, [FlxG.keys.RIGHT, FlxG.keys.LEFT, FlxG.keys.UP, FlxG.keys.DOWN, FlxG.keys.SHIFT]);
			updatePlane(rightPosition, rightImpulse, playerRight, [FlxG.keys.D, FlxG.keys.A, FlxG.keys.W, FlxG.keys.S, FlxG.keys.CONTROL]);
			
			// Methods for keeping the string as an actual string, rather than an elastic band
			var dist:Number = Math.sqrt((Math.pow((playerLeft.x - playerRight.x), 2) + Math.pow((playerLeft.y - playerRight.y), 2))); 
			
			if (dist > (STRING_DISTANCE+25))
				joint.SetFrequency(5.0);
			else 
			{
				if (dist > (STRING_DISTANCE+5))
					joint.SetFrequency(1.0);
				else
					joint.SetFrequency(0.1);
			}
			super.update();
		}
	}

}