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
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
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
		// Temp vectors for impulse-movement and position
		private var leftImpulse:b2Vec2 = new b2Vec2(0, 0);
		private var rightImpulse:b2Vec2 = new b2Vec2(0, 0);
		private var leftPosition:b2Vec2 = new b2Vec2(0, 0);
		private var rightPosition:b2Vec2 = new b2Vec2(0, 0);

		// constants
		protected static const PLAYER_IMPULSE_FORCE:int = 3;
		protected static const STRING_DISTANCE:int = 150;
		
		
		private function CreateString(_world:b2World):void
		{
			// The distance joint is initialized. _obj refers to the bodies of the player sprites
			jointDef.Initialize(playerLeft._obj, playerRight._obj, playerLeft._anchor, playerRight._anchor);
			_world.CreateJoint(jointDef);
			// Frequency and damping ratio can changes the physical properties of the string. These values should be fine-tuned at some point
			jointDef.frequencyHz = 4;
			jointDef.dampingRatio = 0.5;
			
			jointDef.length = STRING_DISTANCE / 30;	// I'm not sure whether we should divide by 30	
			jointDef.collideConnected = false;
			
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
			playerLeft = new B2FlxSprite(x - 40, y, 20, _world);
			playerRight = new B2FlxSprite(x + 40, y, 20, _world);
			playerLeft.createBody();
			playerRight.createBody();
			playerLeft.loadGraphic(leftPlaneImage, false, false, 40, 40);
			playerRight.loadGraphic(rightPlaneImage, false, false, 40, 40);
			
			// This bool is enabled by default, so the call below will disable it
			playerRight.toggleBodyFollowsSprite();
			
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
			
			// position of sprite is set to the body's position
			leftPosition.x = (playerLeft._obj.GetPosition().x * 30) - playerLeft._radius;
			leftPosition.y = (playerLeft._obj.GetPosition().y * 30) - playerLeft._radius;
			
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
				leftImpulse.x = -(playerLeft._obj.GetLinearVelocity().x);
				leftImpulse.y = -(playerLeft._obj.GetLinearVelocity().y);
				
			}
			// finally, leftImpulse containing the impulse based on what happened above, is applied to the body of the player object
			playerLeft._obj.ApplyImpulse(leftImpulse, leftPosition);
		}
		
		private function updateRightPlane():void
		{
			var flag:Boolean = false;
			
			rightPosition.x = (playerRight._obj.GetPosition().x * 30) - playerRight._radius;
			rightPosition.y = (playerRight._obj.GetPosition().y * 30) - playerRight._radius;
			
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
				rightImpulse.x = -(playerRight._obj.GetLinearVelocity().x);
				rightImpulse.y = -(playerRight._obj.GetLinearVelocity().y);
				
			}
			playerRight._obj.ApplyImpulse(rightImpulse, rightPosition);
		}
		
		override public function update():void 
		{
			updateLeftPlane();
			updateRightPlane();
			super.update();
		}
	}

}