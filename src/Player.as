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
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Point;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxObject;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.plugin.photonstorm.FlxExtendedSprite;
	import GamePads.*;
	import Managers.SettingsManager;
	
	public class Player extends FlxObject
	{
		// images of the planes
		[Embed(source = "../assets/graphics/plane2_green_small.png")]public var leftPlaneImage:Class;
		[Embed(source = "../assets/graphics/plane2_pinkish_small.png")]public var rightPlaneImage:Class;
		
		// image of rope
		[Embed(source = "../assets/graphics/string.png")]public var ropeImage:Class;
		
		// sprite and bitmap for rope
		private var rope:Sprite = new Sprite();
		private var ropeBitMap:Bitmap;
		
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
		private var leftImpulse:b2Vec2= new b2Vec2(0, 0);
		private var rightImpulse:b2Vec2 = new b2Vec2(0, 0);
		private var leftPosition:b2Vec2 = new b2Vec2(0, 0);
		private var rightPosition:b2Vec2 = new b2Vec2(0, 0);
		
		private var massNormal:Number = 10.0;
		private var massLockDown:Number = 2000.0;
		
		private var controller:XBOX360Manager = XBOX360Manager.getInstance();
		private var controllerState:int = 0;

		private var exhaustEmitters:Array;
		
		// actual string length
		private var dist:Number;
		
		// constants
		protected static const PLAYER_IMPULSE_FORCE:int = 2.5;
		protected static const STRING_DISTANCE:int = 150;
		protected static const PLAYER_MAX_VELOCITY:int = 100;
		
		public function Player( x:int, y:int, parent:FlxState, _world:b2World, state:int) 
		{		
			playerLeft = new B2FlxSprite(x - 40, y, 30, _world, 0);
			playerRight = new B2FlxSprite(x + 40, y, 30, _world, 1);
			playerLeft.createBody();
			playerRight.createBody();
			
			playerLeft.loadGraphic(leftPlaneImage, true, false, 30, 30);
			playerRight.loadGraphic(rightPlaneImage, true, false, 30, 30);
			
			CreateString(_world);
			
			//XBOX360Manager.getInstance().connect();
			controllerState = state;
			
			// add the planes to the parent game state
			parent.add( playerLeft );
			parent.add( playerRight );
			super( x, y );
			
			// create exhaust emitter for left plane
			exhaustEmitters = new Array();
			for (  var i:int = 0; i < 2; i++ )
			{
				exhaustEmitters[i] = new FlxEmitter(this.x, this.y);
				for (var j:int = 0; j < 100; j++)
				{
					exhaustEmitters[i].add(new Exhaust());
				}
				exhaustEmitters[i].gravity = 0;
				exhaustEmitters[i].maxRotation = 0;
				exhaustEmitters[i].minRotation = 0;
				exhaustEmitters[i].minParticleSpeed.y = -30;
				exhaustEmitters[i].maxParticleSpeed.y = 30;
				exhaustEmitters[i].maxParticleSpeed.x = 30;
				exhaustEmitters[i].minParticleSpeed.x = -30;
				exhaustEmitters[i].particleDrag.x = 0;
				exhaustEmitters[i].particleDrag.y = 0;
				parent.add(exhaustEmitters[i]);
			}
		}
		
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
			
			/*		
			// Here we specify which physics we want debugDraw to draw
			dbgDraw.SetFlags(/*b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			_world.SetDebugDraw(dbgDraw);
			*/
			
			ropeBitMap = new ropeImage;
			rope.graphics.lineStyle(4, 0xFF0000, 1, true, "normal", null, null, 3);
			rope.graphics.lineBitmapStyle(ropeBitMap.bitmapData, null, false, true);
			FlxG.stage.addChild(rope);			
		}
		
		private function updatePlaneController(position:b2Vec2, impulse:b2Vec2, player:B2FlxSprite, keys:Array):void 
		{
			// Flags
			var movement:Boolean = false;
			var lockdown:Boolean = false;
			
			// linear velocity is calculated - used for angle-direction and drag
			var linVel:b2Vec2 = player._obj.GetLinearVelocity();
			
			// The angle the plane is currently turning.
			var currentAngle:Number = player.angle;
			
			// position of sprite is set to the body's position
			position.x = (player._obj.GetPosition().x * 30) - player._radius;
			position.y = (player._obj.GetPosition().y * 30) - player._radius;
			
			// impulse vector is reset, to avoid e.g. applied y-force, when only x-force is desired
			impulse.SetZero();
			
			// Either the ship goes into Lockdown, or movement is being handled.
			if ( keys[1] )
			{
				lockdown = true;
				player._massData.mass = massLockDown;
				player._obj.SetMassData(player._massData);
				player._obj.SetLinearVelocity(new b2Vec2(0, 0));
			}
			else
			{	
				// Since there's no lockdown, the mass is set to be normal again
				player._massData.mass = massNormal;
				player._obj.SetMassData(player._massData);
				// An impulse in the corresponding direction is stored in the impulse vector
				if ( keys[0].x != 0 || keys[0].y != 0)		// RIGHT direction
				{
					movement = true;
					impulse.x = keys[0].x * PLAYER_IMPULSE_FORCE;
					impulse.y = -(keys[0].y * PLAYER_IMPULSE_FORCE);
				}
			}
			
			if(movement)
			{
				// The angle is set based on the current velocity.
				player._obj.SetAngle(Math.atan2(linVel.y, linVel.x));
				player.angle = player._angle;
				// Here the ship should be emitting exhaust... eventually!
				exhaustEmitters[player.ID].at( player );
				exhaustEmitters[player.ID].start( true, 0, 1 );
			}
			else
			{
				// The impulse is set to the inverted velocity, to slow it down
				impulse.x = -0.5*(linVel.x);
				impulse.y = -0.5*(linVel.y);
				// The original angle is retained.
				player.angle = currentAngle;
			}
			
			// The resulting impulse is applied to the body of the player object
			player._obj.ApplyImpulse(impulse, position);
			
			if (!lockdown)
			{	
				// The maximum velocity is capped.
				if (linVel.LengthSquared() > PLAYER_MAX_VELOCITY)
				{
					var scaleVector:b2Vec2 = linVel;
					scaleVector.Multiply(PLAYER_MAX_VELOCITY / linVel.LengthSquared());
					player._obj.SetLinearVelocity(scaleVector);
				}
			}
		}
		
		private function updatePlane(position:b2Vec2, impulse:b2Vec2, player:B2FlxSprite, keys:Array):void 
		{
			// Flags
			var movement:Boolean = false;
			var lockdown:Boolean = false;
			
			// linear velocity is calculated - used for angle-direction and drag
			var linVel:b2Vec2 = player._obj.GetLinearVelocity();
			
			// The angle the plane is currently turning.
			var currentAngle:Number = player.angle;
			
			// position of sprite is set to the body's position
			position.x = (player._obj.GetPosition().x * 30) - player._radius;
			position.y = (player._obj.GetPosition().y * 30) - player._radius;
			
			// impulse vector is reset, to avoid e.g. applied y-force, when only x-force is desired
			impulse.SetZero();
			
			// Either the ship goes into Lockdown, or movement is being handled.
			if ( keys[4] )
			{
				lockdown = true;
				player._massData.mass = massLockDown;
				player._obj.SetMassData(player._massData);
				player._obj.SetLinearVelocity(new b2Vec2(0, 0));
			}
			else
			{	
				// Since there's no lockdown, the mass is set to be normal again
				player._massData.mass = massNormal;
				player._obj.SetMassData(player._massData);
				// An impulse in the corresponding direction is stored in the impulse vector
				if ( keys[0] )		// RIGHT direction
				{
					movement = true;
					impulse.x = PLAYER_IMPULSE_FORCE;
				}
				if ( keys[1] )		// LEFT direction
				{
					movement = true;
					impulse.x = -PLAYER_IMPULSE_FORCE;
				}
				if ( keys[2] )		// UP direction
				{
					movement = true;
					impulse.y = -PLAYER_IMPULSE_FORCE;
				}
				if ( keys[3] )		// DOWN direction
				{
					movement = true;
					impulse.y = PLAYER_IMPULSE_FORCE;
				}
			}
			
			if(movement)
			{
				// The angle is set based on the current velocity.
				player._obj.SetAngle(Math.atan2(linVel.y, linVel.x));
				player.angle = player._angle;
				// Here the ship should be emitting exhaust... eventually!
				exhaustEmitters[player.ID].at( player );
				exhaustEmitters[player.ID].start( true, 0, 1 );
			}
			else
			{
				// The impulse is set to the inverted velocity, to slow it down
				impulse.x = -(linVel.x);
				impulse.y = -(linVel.y);
				// The original angle is retained.
				player.angle = currentAngle;
			}
			
			// The resulting impulse is applied to the body of the player object
			player._obj.ApplyImpulse(impulse, position);
			
			if (!lockdown)
			{	
				// If not, the maximum velocity is capped.
				if (linVel.LengthSquared() > PLAYER_MAX_VELOCITY)
				{
					var scaleVector:b2Vec2 = linVel;
					scaleVector.Multiply(PLAYER_MAX_VELOCITY / linVel.LengthSquared());
					player._obj.SetLinearVelocity(scaleVector);
				}
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
		/*
		public function getJoint():b2JointDef
		{
			return this.jointDef;
		}
		*/
		public function getRope():Sprite
		{
			return this.rope;
		}
		
		public function getRopeLengthPercentage():Number
		{
			return Math.round( this.dist / STRING_DISTANCE * 100 );
		}
		
		override public function update():void 
		{
			if ( SettingsManager.Game_Controller == SettingsManager.KEYBOARD )
			{
				updatePlane(leftPosition, leftImpulse, playerLeft, [FlxG.keys.D, FlxG.keys.A, FlxG.keys.W, FlxG.keys.S, FlxG.keys.R]);
				updatePlane(rightPosition, rightImpulse, playerRight, [FlxG.keys.RIGHT, FlxG.keys.LEFT, FlxG.keys.UP, FlxG.keys.DOWN, FlxG.keys.SHIFT]);
			}
			else
			{
				updatePlaneController(leftPosition, leftImpulse, playerLeft, [controller.getState(controllerState).RightStick, controller.getState(controllerState).RB]); 
				if(SettingsManager.Player_mode == SettingsManager.SINGLEPLAYER)
					updatePlaneController(rightPosition, rightImpulse, playerRight, [controller.getState(controllerState).LeftStick, controller.getState(controllerState).LB]); 
				else
					updatePlaneController(rightPosition, rightImpulse, playerRight, [controller.getState(controllerState+1).LeftStick, controller.getState(controllerState+1).LB]); 
			}
			// Methods for keeping the string as an actual string, rather than an elastic band
			this.dist = Math.sqrt((Math.pow((playerLeft.x - playerRight.x), 2) + Math.pow((playerLeft.y - playerRight.y), 2))); 
			
			if (this.dist > (STRING_DISTANCE+25))
				joint.SetFrequency(5.0);
				// Fire object here, potentially :D
			else 
			{
				if (this.dist > (STRING_DISTANCE+5))
					joint.SetFrequency(1.0);
				else
					joint.SetFrequency(0.1); // Consider lowering even further
			}
			
			rope.graphics.clear();
			// 400/dist makes the width of the rope depend on the distance between the planes
			rope.graphics.lineStyle(400 / dist, 0xFF0000, 1, true, "normal", null, null, 3);
			rope.graphics.lineBitmapStyle(ropeBitMap.bitmapData, null, true, true);
			rope.graphics.moveTo(playerLeft.x + (playerLeft.width/2), playerLeft.y + (playerLeft.height/2));
			rope.graphics.lineTo(playerRight.x + (playerRight.width/2), playerRight.y + (playerRight.height/2));
			
			super.update();
		}
	}
}